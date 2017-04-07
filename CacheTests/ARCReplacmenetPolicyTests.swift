//
//  ARCReplacmenetPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 07/04/2017.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class ARCReplacementPolicyTests: XCTestCase {

    let policy = ARCReplacementPolicy<Int>(maxCost: 2)

    func test_cacheNotFull_cacheHit_noEviction() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
    }

    func test_cacheFull_cacheHit_noEviction() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
    }

    func test_cacheFull_cacheMiss_evictsOne() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [0])
    }

    func test_whenCacheHit_staysInCache() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [0])
    }

    func test_whenCacheHitToPreviouslyHit_updatesPriority() {
        let policy = ARCReplacementPolicy<Int>(maxCost: 4)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 0)
        policy.cacheHit(for: 1)
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [])
        policy.cacheHit(for: 2)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 3, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 4, cost: 1), [1])
    }

    func test_evictionOfMultipleKeys() {
        let policy = ARCReplacementPolicy<Int>(maxCost: 3)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2).sorted(), [0, 1])
    }

    func test_replacementOfMultipleKeys() {
        let policy = ARCReplacementPolicy<Int>(maxCost: 4)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 1)
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2), [])
        policy.cacheHit(for: 2)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 3, cost: 1), [1])
    }

    func test_evictionOfAllItems() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2).sorted(), [0, 1])
    }

    func test_ghostListForRecentItems() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [0])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
    }

    func test_ghostListForFrequentItems() {
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 1)
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [1])
    }

}
