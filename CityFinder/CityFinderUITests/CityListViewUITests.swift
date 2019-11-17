//
//  CityListViewUITests.swift
//  CityFinderUITests
//
//  Created by fahad c h on 16/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import XCTest

class CityListViewUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
        XCUIDevice.shared.orientation = .portrait
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }
    
    func test_tappingcells_loadsCorrectData() {
        XCUIDevice.shared.orientation = .landscapeLeft
        XCUIDevice.shared.orientation = .portrait
        if XCUIDevice.shared.orientation.isPortrait {
            let listTableView = app.tables["automationCitiesTableView"]
            let cityListcell = listTableView.cells["automationCityCell_0"]
            self.waitForElementToAppear(element: cityListcell)
            var cityListCellTitleValue = cityListcell.staticTexts["automationCityCellTitleLabel"].label

            cityListcell.tap()
            let aboutButton = app.buttons["automationAboutButton"]
            aboutButton.tap()
            let aboutTableView = app.tables["automationAboutTableView"]
            let aboutcell = aboutTableView.cells["automationAboutCell_0"]
            self.waitForElementToAppear(element: aboutcell)
            let aboutCellTitleValue = aboutcell.staticTexts["automationAboutCelldetailTextLabel"].label
            cityListCellTitleValue = cityListCellTitleValue.components(separatedBy: ",").first ?? ""
            XCTAssertTrue(aboutCellTitleValue == cityListCellTitleValue)
            sleep(3)
        }
    }
    
    func testAboutButtonExist() {
        XCUIDevice.shared.orientation = .landscapeLeft
        if XCUIDevice.shared.orientation.isLandscape {
            let aboutButton = app.buttons["automationAboutButton"]
            XCTAssertTrue(aboutButton.exists)
        }
    }

    func testTableViewloadesWithCells() {
        if XCUIDevice.shared.orientation.isPortrait {
            let listTableView = app.tables["automationCitiesTableView"]
            let cell0 = listTableView.cells["automationCityCell_0"]
            self.waitForElementToAppear(element: cell0)
            XCTAssert(cell0.exists)
        }
    }

    func test_tappingAboutViewButton_loadsAboutView() {
        XCUIDevice.shared.orientation = .landscapeLeft
        if XCUIDevice.shared.orientation.isLandscape {
            let aboutButton = app.buttons["automationAboutButton"]
            let listTableView = app.tables["automationCitiesTableView"]
            let cell0 = listTableView.cells["automationCityCell_0"]
            self.waitForElementToAppear(element: cell0)
            aboutButton.tap()
        }
    }

    func test_tappingcells_loadsAboutViewWithData() {
        if XCUIDevice.shared.orientation.isPortrait {
            let listTableView = app.tables["automationCitiesTableView"]
            let cityListcell = listTableView.cells["automationCityCell_0"]
            self.waitForElementToAppear(element: cityListcell)
            cityListcell.tap()
            let aboutButton = app.buttons["automationAboutButton"]
            aboutButton.tap()
            let aboutTableView = app.tables["automationAboutTableView"]
            let aboutcell = aboutTableView.cells["automationAboutCell_0"]
            self.waitForElementToAppear(element: aboutcell)
            sleep(3)
        }
    }


    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 15,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
            }
        }
    }

}
