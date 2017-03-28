//
//  LFUReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 28/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class LFUReplacementPolicyTests: XCTestCase {
    
    func test_evictsUnusedItemFirst() {
        let policy = LFUReplacementPolicy<Int>(maxCost: 2)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [0])
    }

    func test_remove() {
        let policy = LFUReplacementPolicy<Int>(maxCost: 2)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.remove(key: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2), [0])
    }

}
