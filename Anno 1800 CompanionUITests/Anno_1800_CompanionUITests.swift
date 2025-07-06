//
//  Anno_1800_CompanionUITests.swift
//  Anno 1800 CompanionUITests
//
//  Created by Rodolphe Beck on 24/05/2025.
//

import XCTest

final class Anno_1800_CompanionUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testScreenshots() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        app.activate()
        
        snapshot("01MainScreen")
        
        app/*@START_MENU_TOKEN@*/.buttons["Ajouter"]/*[[".navigationBars.buttons[\"Ajouter\"]",".buttons[\"Ajouter\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons.staticTexts["The Old World"].firstMatch/*[[".staticTexts.matching(identifier: \"The Old World\").element(boundBy: 1)",".buttons",".staticTexts.firstMatch",".staticTexts[\"The Old World\"].firstMatch"],[[[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Enbesa"]/*[[".cells.buttons[\"Enbesa\"]",".buttons[\"Enbesa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let element = app.textFields.matching(identifier: "Number").element(boundBy: 0)
        element.tap()
        element.typeKey(.delete, modifierFlags:[])
        app/*@START_MENU_TOKEN@*/.textFields["300"]/*[[".otherElements.textFields[\"300\"]",".textFields[\"300\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("\"àà")
        
        let element2 = app/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".otherElements.textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element2.tap()
        element2.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".otherElements",".textFields[\"Île enbes\"]",".textFields[\"Name\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.typeText("Ile enbesa")
        app/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements.buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Île en Elsa, 300"]/*[[".buttons",".containing(.image, identifier: \"regions\/enbesa\")",".containing(.staticText, identifier: \"300\")",".containing(.staticText, identifier: \"Île en Elsa\")",".otherElements.buttons[\"Île en Elsa, 300\"]",".buttons[\"Île en Elsa, 300\"]"],[[[-1,5],[-1,4],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        snapshot("02IslandScreen")
        
        let element3 = app/*@START_MENU_TOKEN@*/.buttons["Calculate"]/*[[".otherElements.buttons[\"Calculate\"]",".buttons[\"Calculate\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element3.tap()
        element3.tap()
        
        let element4 = app/*@START_MENU_TOKEN@*/.buttons["BackButton"]/*[[".navigationBars",".buttons",".buttons[\"Islands\"]",".buttons[\"BackButton\"]"],[[[-1,3],[-1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element4.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["1200"]/*[[".buttons.staticTexts[\"1200\"]",".staticTexts[\"1200\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element3.tap()
        
        let cellsQuery = app.cells
        cellsQuery/*@START_MENU_TOKEN@*/.containing(.image, identifier: "Workers").firstMatch/*[[".element(boundBy: 8)",".containing(.image, identifier: \"icons\/workforce-workers\").firstMatch",".containing(.staticText, identifier: \"Workers\").firstMatch",".containing(.image, identifier: \"Workers\").firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        cellsQuery/*@START_MENU_TOKEN@*/.containing(.image, identifier: "Engineers").firstMatch/*[[".element(boundBy: 5)",".containing(.image, identifier: \"icons\/workforce-engineers\").firstMatch",".containing(.staticText, identifier: \"Engineers\").firstMatch",".containing(.image, identifier: \"Engineers\").firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeDown()
        element4.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Île en Elsa"]/*[[".buttons.staticTexts[\"Île en Elsa\"]",".staticTexts[\"Île en Elsa\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        element3.doubleTap()
        element4.tap()
        
        snapshot("03IslandScreen")
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
