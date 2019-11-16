//
//  CityListViewModel.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import Foundation

class CityListViewModel {

    private var previousSearch = ""
    private let cityDataSource = CitiesDataSource()
    private(set) var selectedCityIndex: Int = 0
    
    var updateHandler: (() -> Void)?
    
    var filteringData = [CityModel]()
    
    var citiesData = [CityModel]()
    
    var citiesCount: Int {
        return citiesData.count
    }
    
    private lazy var searchOperationQueue: OperationQueue = {
        let searchOperationQueue = OperationQueue()
        searchOperationQueue.maxConcurrentOperationCount = 1
        searchOperationQueue.qualityOfService = .userInitiated
        return searchOperationQueue
    }()
    
    lazy var cityDictionary: [String: [CityModel]] = {
        if let cities = cityDataSource.citiesData {
            let dic = Dictionary(grouping: cities, by: { $0.country })
            return dic
        }
        return [String: [CityModel]]()
    }()
    
    
    func fetchCitiesData(completion: @escaping ()-> Void)  {
        citiesData.removeAll()
        cityDataSource.getAllcities { [weak self] (status) in
            switch status {
            case .success:
                if let citiesData = self?.cityDataSource.citiesData {
                    self?.citiesData.append(contentsOf: citiesData)
                }
            case .error(let error):
                print(error)
            }
            completion()
        }
    }
    
    func city(atIndex index: Int) -> CityModel? {
        return citiesData[index]
    }
    
    func setSelectedCityIndex(index: Int) {
        selectedCityIndex = index
    }
    
    func cityCoordinate(atIndex index: Int) -> (Double, Double) {
        if let city = city(atIndex: index) {
            return (city.coordinate.latitude, city.coordinate.longitude)
        }
        return (0, 0)
    }
}

//Mark :- Search

extension CityListViewModel {
    
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
        var keyBasedset = Set<CityModel>()
        var allValueBasedset = Set<CityModel>()
        filteredKeyBasedItems.forEach { keyBasedset.insert($0) }
        filteredAllvalues.forEach { allValueBasedset.insert($0) }
        let filteredFinalResult = allValueBasedset.union(keyBasedset).sorted(by: { $0.name < $1.name })
        return filteredFinalResult
    }
    
    func updateDataSource() {
        self.citiesData.removeAll()
        self.citiesData.append(contentsOf: self.filteringData)
        self.updateHandler?()
    }
    
    func searchCity(withKeyWord keyword: String)  {
        let lowerCasedKeyWord = keyword.lowercased()
        if let citiesData = cityDataSource.citiesData, lowerCasedKeyWord.count == 0 {
            searchOperationQueue.cancelAllOperations()
            filteringData.removeAll()
            self.citiesData.removeAll()
            self.citiesData.append(contentsOf: citiesData)
            self.updateHandler?()
        } else if lowerCasedKeyWord.hasPrefix(previousSearch), previousSearch.count > 0 {
            let searchOperation = BlockOperation()
            searchOperation.addExecutionBlock { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let filteredDic = Dictionary(grouping: strongSelf.filteringData, by: { $0.country })
                let finalResult = strongSelf.doSearch(forKey: lowerCasedKeyWord, cityDictionary: filteredDic, cityArray: strongSelf.filteringData)
                strongSelf.filteringData.removeAll()
                strongSelf.filteringData.append(contentsOf: finalResult)
            }
            
            searchOperation.completionBlock = { [weak self] in
                DispatchQueue.main.async {
                    if searchOperation.isCancelled == false {
                        self?.updateDataSource()
                    }
                }
            }
            searchOperationQueue.addOperation(searchOperation)

        } else {
            searchOperationQueue.cancelAllOperations()
            filteringData.removeAll()

            let searchOperation = BlockOperation()
            searchOperation.addExecutionBlock { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let finalResult = strongSelf.doSearch(forKey: lowerCasedKeyWord, cityDictionary: strongSelf.cityDictionary, cityArray: strongSelf.cityDataSource.citiesData ?? [])
                strongSelf.filteringData.append(contentsOf: finalResult)
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
