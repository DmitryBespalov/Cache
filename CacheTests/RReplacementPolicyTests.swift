//
//  RReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 27/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class RReplacementPolicyTests: XCTestCase {

    func test_randomReplacement() {
        let policy = RReplacementPolicy<Int>(maxCost: 4)
        policy.randomGenerator = { count in 0 }
        let _ = policy.evictedKeysForAdded(key: 0, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 1, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 2, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 3, cost: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 4, cost: 1), [0])
        policy.randomGenerator = { count in 1 }
        XCTAssertEqual(policy.evictedKeysForAdded(key: 5, cost: 1), [2])
    }


}
