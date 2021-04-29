//
//  Flickr_AlbumUITests.swift
//  Flickr AlbumUITests
//
//  Created by Hassan on 23.4.2021.
//

import XCTest

class Flickr_AlbumUITests: XCTestCase {

    //MARK:- Variables
    var app: XCUIApplication!
    
    //MARK:- UI TestCases
    func testLabel() {
        app = XCUIApplication()
        app.launch()
        XCTAssert(app.staticTexts["Flickr Album"].exists)
    }
}
