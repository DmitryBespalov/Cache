//
//  LRUReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 25/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class LRUReplacementPolicyTests: XCTestCase {

    func test_createSimple() {
        let policy = LRUReplacementPolicy<Int>(maxCost: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [0])
    }

    func test_whenTwoElements_evictsLeastUsed() {
        let policy = LRUReplacementPolicy<Int>(maxCost: 2)
        let _ = policy.evictedKeysForAdded(key: 0, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 1, cost: 1)

        policy.cacheHit(for: 0)

        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [1])
    }

    func test_withFourElements() {
        let policy = LRUReplacementPolicy<Int>(maxCost: 4)
        let _ = policy.evictedKeysForAdded(key: 0, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 1, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 2, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 3, cost: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 4, cost: 1), [0])
        policy.cacheHit(for: 3)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 5, cost: 1), [1])
    }

    func test_removesElement() {
        let policy = LRUReplacementPolicy<Int>(maxCost: 1)
        let _ = policy.evictedKeysForAdded(key: 0, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 1, cost: 1)
        policy.remove(key: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [])
    }

    func test_evictWithHugeCost() {
        let policy = LRUReplacementPolicy<Int>(maxCost: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 2), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 2), [0])
    }

    func test_doesNotEvicts_whenMaxCostZero() {
        let policy = LRUReplacementPolicy<Int>(maxCost: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 2), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 2), [])
    }

}
