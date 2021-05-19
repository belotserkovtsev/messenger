//
//  MessengerUITests.swift
//  MessengerUITests
//
//  Created by belotserkovtsev on 05.05.2021.
//

import XCTest

class ProfileUITests: XCTestCase {

    func testTextInputsExist() throws {
		let app = XCUIApplication()
		app.launch()
		app.navigationBars.buttons.element(boundBy: 1).tap()
		let textView = app.textViews["descriptionTextView"]
		let textField = app.textFields["nameTextField"]
		
		XCTAssertTrue(textView.exists)
		XCTAssertTrue(textField.exists)
    }
}
