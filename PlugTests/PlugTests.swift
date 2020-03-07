//
//  PlugTests.swift
//  PlugTests
//
//  Created by changmin lee on 08/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import XCTest

class PlugTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateFormatter() {
        let str = "2018-12-08T12:37:24.293Z"
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let date = formatter.date(from: str)!
        
        
        let formatter2 = DateFormatter()
//        formatter2.timeZone = TimeZone(abbreviation: "KST")
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        print("log : \(formatter2.string(from: date))")

        XCTAssertNotNil(date)
    }
    
    func testDateSameMin() {
        let str1 = "2018-12-06T20:26:19.710Z"
        let str2 = "2018-12-06T20:26:19.710Z"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let cal = Calendar.current
        let result = cal.component(.minute, from: formatter.date(from: str1)!) == cal.component(.minute, from: formatter.date(from: str2)!)
        XCTAssertTrue(result)
    }
    
    func testFileName() {
        
    }
}
