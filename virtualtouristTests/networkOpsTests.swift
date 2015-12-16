//
//  networkOpsTests.swift
//  virtualtourist
//
//  Created by Matthew Rocco on 12/7/15.
//  Copyright © 2015 Matthew Rocco. All rights reserved.
//

import Foundation
import XCTest

@testable import virtualtourist

class networkOpsTests  : XCTestCase {
    
    func testJSON () {
        let networkOPS = NetworkingOps(lat: 0.0, long: 0.0)
        networkOPS.getFlikrPhoto()
        XCTAssertEqual(networkOPS.lat, 0.0)
        XCTAssertEqual(networkOPS.long, 0.0)
    }
    
}