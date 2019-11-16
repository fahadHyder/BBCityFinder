//
//  CityListViewModelTests.swift
//  CityFinderTests
//
//  Created by fahad c h on 16/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import XCTest
@testable import CityFinder

class CityListViewModelTests: XCTestCase {
    var viewModel : CityListViewModel!
    
    var cityDataArray: [CityModel]!

    var countryKeyDictionary: [String: [CityModel]]!
    
    override func setUp() {
        super.setUp()
        viewModel = CityListViewModel()
        cityDataArray = dumbCityData()
        countryKeyDictionary = Dictionary(grouping: cityDataArray, by: { $0.country })
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func dumbCityData() -> [CityModel] {
        let dumbData = "[\r\n{\"country\":\"UA\",\"name\":\"Hurzuf\",\"_id\":707860,\"coord\":{\"lon\":34.283333,\"lat\":44.549999}},\r\n{\"country\":\"RU\",\"name\":\"Novinki\",\"_id\":519188,\"coord\":{\"lon\":37.666668,\"lat\":55.683334}},\r\n{\"country\":\"NP\",\"name\":\"Gorkh\",\"_id\":1283378,\"coord\":{\"lon\":84.633331,\"lat\":28}},\r\n{\"country\":\"IN\",\"name\":\"State of Haryna\",\"_id\":1270260,\"coord\":{\"lon\":76,\"lat\":29}},\r\n{\"country\":\"UA\",\"name\":\"Holubynka\",\"_id\":708546,\"coord\":{\"lon\":33.900002,\"lat\":44.599998}},\r\n{\"country\":\"NP\",\"name\":\"BgmatB Zone\",\"_id\":1283710,\"coord\":{\"lon\":85.416664,\"lat\":28}},\r\n{\"country\":\"RU\",\"name\":\"Marina Roshcha\",\"_id\":529334,\"coord\":{\"lon\":37.611111,\"lat\":55.796391}},\r\n{\"country\":\"AO\",\"name\":\"Uacu Cungo\",\"_id\":3345497,\"coord\":{\"lon\":15.12078,\"lat\":-11.36343}},\r\n{\"country\":\"LT\",\"name\":\"Murava\",\"_id\":596826,\"coord\":{\"lon\":23.966669,\"lat\":54.916672}}\r\n]".data(using: .utf8);

        if let data = dumbData {
            do {
                let decoder = JSONDecoder()
                let citiesData = try decoder.decode([CityModel].self, from: data)
                let dumbCities = citiesData.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                return dumbCities
            } catch {
                print("error:\(error)")
            }
        }
        return [CityModel]()
    }
    
    func test_cityListSearch_withValidSearchTerm_returnsResults_WhichMatches_countryNameANDCityName() {
        let filteredArray = viewModel.doSearch(forKey: "UA".lowercased(), cityDictionary: countryKeyDictionary, cityArray: cityDataArray)
        XCTAssertTrue(filteredArray.count == 3, "The array should contain 3 elements whose either name or country starts with UA")
        
    }
    
    func test_cityListSearch_withValidSearchTerm_returnsValidSearchResult_WhichMatches_countryNameORCityName() {
        let filteredArray = viewModel.doSearch(forKey: "s".lowercased(), cityDictionary: countryKeyDictionary, cityArray: cityDataArray)
        XCTAssertTrue(filteredArray.count == 1, "The array should contain 1 element when the enite data set contains city with either name starts with 's' or country starts with 's'")
    }
    
    func test_cityListSearch_withValidSearchTerm_returnsResults_InAlphabeticalOrderOfCityName() {
        let filteredArray = viewModel.doSearch(forKey: "UA".lowercased(), cityDictionary: countryKeyDictionary, cityArray: cityDataArray)
        XCTAssertTrue(filteredArray[0].name == "Holubynka")
        XCTAssertTrue(filteredArray[1].name == "Hurzuf")
        XCTAssertTrue(filteredArray[2].name == "Uacu Cungo")
    }
    
    func test_cityListSearch_withInvalidSearchTerm_returnsEmptyResult() {
        let filteredArray = viewModel.doSearch(forKey: "bu".lowercased(), cityDictionary: countryKeyDictionary, cityArray: cityDataArray)
        XCTAssertTrue(filteredArray.count == 0, "The array should be empty when city name or coutry name doesn't match search term")
    }
    
}

