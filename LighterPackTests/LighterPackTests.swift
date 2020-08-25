//
//  LighterPackTests.swift
//  LighterPackTests
//
//  Created by acantallops on 2020/08/19.
//

import XCTest
import Combine
@testable import LighterPack

class LighterPackTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        var sync = SyncEngine()
        sync.run()
    }

}
