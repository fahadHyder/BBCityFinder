//
//  PerformanceTests.swift
//  CityFinderTests
//
//  Created by fahad c h on 17/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import XCTest
@testable import CityFinder

class PerformanceTests: XCTestCase {
    
    var viewModel : CityListViewModel!
    var cityDataArray  =  [CityModel]()
    
    lazy var cityDictionary: [String: [CityModel]] = {
        let dic = Dictionary(grouping: self.viewModel.citiesData, by: { $0.country })
        return dic
    }()


    override func setUp() {
        viewModel = CityListViewModel()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPeromanceOf_doSeachMethod() {
        
        let expectation = self.expectation(description: "dataFetch")
        viewModel.fetchCitiesData {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 20)
        XCTAssertTrue(self.viewModel.citiesData.count > 0)
        measure {
            let array = viewModel.doSearch(forKey: "be".lowercased(), cityDictionary: cityDictionary, cityArray: self.viewModel.citiesData)
            XCTAssertTrue(array.count > 0)
        }
        
    }
    
}
