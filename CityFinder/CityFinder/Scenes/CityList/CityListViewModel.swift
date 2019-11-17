//
//  CityListViewModel.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import Foundation

class CityListViewModel {
    
    /// The  previous search term
    private var previousSearch = ""
    
    /// The data source which holds the entire array of cities
    private let cityDataSource = CitiesDataSource()
    
    /// The selected city
    private(set) var selectedCityIndex: Int = 0
    
    /// The CityModel array which is used for filtering and store intermediate search result
    var filteringData = [CityModel]()
    
    /// The array which holds the items sorted by city name
    var citiesData = [CityModel]()
    
    /// The handler which will be called when citiesData updated
    var updateHandler: (() -> Void)?
    
    /// The cities count
    var citiesCount: Int {
        return citiesData.count
    }
    
    /**
    The operation queue which holds search operations. maxConcurrentOperationCount is 1
    because only single search opearation should run  at a particulr instance.
    qualityOfService is userInitiated since seach is high priority.
    */
    private lazy var searchOperationQueue: OperationQueue = {
        let searchOperationQueue = OperationQueue()
        searchOperationQueue.maxConcurrentOperationCount = 1
        searchOperationQueue.qualityOfService = .userInitiated
        return searchOperationQueue
    }()
    
    /// The Dictionary  holds city array, Key is country name and Value is array of CityModel
    var cityDictionary = [String: [CityModel]]()
    
    /// The Dictionary  holds city array, Key is country name first character and Value is array of CityModel
    var alphabeticOrderedDictionary = [String: [CityModel]]()
    
    /// The Dictionary  caches city array that searched previously, Key is Search term and Value is array of CityModel
    var cacheDictionary = [String: [CityModel]]()
    
    /**
     Get all cities data from data source.
     Calling this mehod removes all element from citiesData and Fill it with data from cityDataSource.
     - Parameter completion: Block called on success or failure of getAllcities in cityDataSource
     */
    func fetchCitiesData(completion: @escaping ()-> Void)  {
        citiesData.removeAll()
        cityDataSource.getAllcities { [weak self] (status) in
            switch status {
            case .success:
                if let citiesData = self?.cityDataSource.citiesData {
                    self?.citiesData.append(contentsOf: citiesData)
                    self?.updateDictionaries()
                }
            case .error(let error):
                print(error)
            }
            completion()
        }
    }
    
    func updateDictionaries() {
        if let cities = cityDataSource.citiesData {
            cityDictionary = Dictionary(grouping: cities, by: { $0.country })
            alphabeticOrderedDictionary = Dictionary(grouping: cities, by: { String($0.name.first ?? " ").lowercased() })
        }
    }
    
    /**
     Returns a CityModel at an Index
     - Parameter index: Index of the item
     */
    func city(atIndex index: Int) -> CityModel {
        return citiesData[index]
    }
    
    /// Set selected city  to an Index
    func setSelectedCityIndex(index: Int) {
        selectedCityIndex = index
    }
    
}

// MARK: - Search

extension CityListViewModel {
    

    func measure(_ title: String, block: (@escaping () -> ()) -> ()) {

        let startTime = CFAbsoluteTimeGetCurrent()

        block {
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
            print("\(title):: Time: \(timeElapsed)")
        }
    }

    /**
     Returns filtered and sorted city Array
     - Parameter keywrod: String used to filter the given cityDictionary and cityArray
     - Parameter cityDictionary: Holds the CityModel array as value and Country name as key
     - Parameter cityArray: Holds array of CityModel
     */
    func doSearch(forKey keyword: String, cityDictionary: [String: [CityModel]], cityArray: [CityModel]) -> [CityModel] {
        var filteredKeyBasedItems = [CityModel]()
        if keyword.count < 3 {
            let allKeys = cityDictionary.keys
            let filteredKeys = allKeys.filter { $0.lowercased().hasPrefix(keyword) }
            for item in filteredKeys {
                if let items = cityDictionary[item] {
                    items.forEach { filteredKeyBasedItems.append($0) }
                }
            }
        }
        let filteredAllvalues = cityArray.filter { $0.name.lowercased().hasPrefix(keyword) }
        filteredKeyBasedItems.append(contentsOf: filteredAllvalues)
        var allValueBasedset = Set<CityModel>()
        filteredKeyBasedItems.forEach { allValueBasedset.insert($0) }
        let filteredFinalResult = allValueBasedset.sorted(by: { $0.name < $1.name })
        return filteredFinalResult
    }
    
    
    func updateDataSource() {
        self.citiesData.removeAll()
        self.citiesData.append(contentsOf: self.filteringData)
        self.updateHandler?()
    }
    
    func searchCity(withKeyWord keyword: String)  {
        let lowerCasedKeyWord = keyword.lowercased()
        if let citiesData = cityDataSource.citiesData, lowerCasedKeyWord.isEmpty {
            searchOperationQueue.cancelAllOperations()
            filteringData.removeAll()
            self.citiesData.removeAll()
            self.citiesData.append(contentsOf: citiesData)
            self.cacheDictionary.removeAll()
            self.updateHandler?()
        } else if let array = self.cacheDictionary[lowerCasedKeyWord] {
            filteringData.removeAll()
            filteringData.append(contentsOf: array)
            self.updateDataSource()
        } else if lowerCasedKeyWord.hasPrefix(previousSearch), previousSearch.count > 0 {
            let searchOperation = BlockOperation()
            searchOperation.addExecutionBlock { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let finalResult = strongSelf.doSearch(forKey: lowerCasedKeyWord, cityDictionary: strongSelf.cityDictionary, cityArray: strongSelf.filteringData)
                strongSelf.filteringData.removeAll()
                strongSelf.filteringData.append(contentsOf: finalResult)
                self?.cacheDictionary[lowerCasedKeyWord] = strongSelf.filteringData
            }
            
            searchOperation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    if searchOperation.isCancelled == false {
                        self?.updateDataSource()
                    }
                }
            }
            searchOperationQueue.addOperation(searchOperation)

        }  else {
            searchOperationQueue.cancelAllOperations()
            filteringData.removeAll()

            let searchOperation = BlockOperation()
            searchOperation.addExecutionBlock { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let fisrtLetter = String(lowerCasedKeyWord.first ?? " ")
                let cityArray = strongSelf.alphabeticOrderedDictionary[fisrtLetter] ?? []
                let finalResult = strongSelf.doSearch(forKey: lowerCasedKeyWord, cityDictionary: strongSelf.cityDictionary, cityArray: cityArray)
                strongSelf.filteringData.append(contentsOf: finalResult)
                self?.cacheDictionary[lowerCasedKeyWord] = strongSelf.filteringData
            }
            
            searchOperation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    if searchOperation.isCancelled == false {
                        self?.updateDataSource()
                    }
                }
            }
            searchOperationQueue.addOperation(searchOperation)
        }
        previousSearch = lowerCasedKeyWord
    }
}
