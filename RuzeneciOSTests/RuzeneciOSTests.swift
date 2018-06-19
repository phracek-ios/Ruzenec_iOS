//
//  RuzeneciOSTests.swift
//  RuzeneciOSTests
//
//  Created by Petr Hracek on 06/06/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import XCTest
@testable import RuzeneciOS

class RuzeneciOSTests: XCTestCase {
    
    //MARK: Desatek Class Tests
    
    func testDesatekInitializationSucceeds() {
        let desatek = Desatek.init(name: "test", photo: nil)
        XCTAssertNotNil(desatek)
    }
    func testDesatekInitializationFails(){
        let emptyStringDesatek = Desatek.init(name: "", photo: nil)
        XCTAssertNil(emptyStringDesatek)
    }
}
