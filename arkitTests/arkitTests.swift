//
//  arkitTests.swift
//  arkitTests
//
//  Created by Thiago Delmotte on 01/02/2018.
//  Copyright © 2018 personalit. All rights reserved.
//

import XCTest
import CoreLocation

class arkitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testToRadians() {
        let math = Float(1.0).toRadians()
        XCTAssertEqual(math, Float(0.01745329252), accuracy: 0.00000000001)
    }
    
    func testBearingBetweenLocations() {
        let brazil = CLLocation(latitude: -23.6553654, longitude: -46.6685875)
        let norway = CLLocation(latitude: 59.8937806, longitude: 10.6450365)
        let result = ARHelper.bearingBetweenLocations(norway, brazil)
        XCTAssertEqual(result, -2.2553121453851719, accuracy: 0.0000000000000001)
    }
    
}
