//
//  SLRUReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 27/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class SLRUReplacementPolicyTests: XCTestCase {

    func test_create() {
        let _ = SLRUReplacementPolicy<Int>(maxCost: 2, referencedSegmentFraction: 0.5)
    }

    func test_removeKey() {
        let policy = SLRUReplacementPolicy<Int>(maxCost: 1, referencedSegmentFraction: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.remove(key: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [1])
    }

    func test_removeKeyFromReferencedSegment() {
        let policy = SLRUReplacementPolicy<Int>(maxCost: 2, referencedSegmentFraction: 0.5)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.remove(key: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2), [1])
    }

    func test_cacheHit() {
        let policy = SLRUReplacementPolicy<Int>(maxCost: 2, referencedSegmentFraction: 0.5)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [0])
    }

    func test_cacheHitWithBiggerSegmentSizes() {
        let policy = SLRUReplacementPolicy<Int>(maxCost: 4, referencedSegmentFraction: 0.5)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        policy.cacheHit(for: 0)
        policy.cacheHit(for: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2), [])
        policy.cacheHit(for: 2)
        policy.cacheHit(for: 0)
        policy.cacheHit(for: 1)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 3, cost: 1), [2])
    }

    func test_whenCacheMissOverflow_itemsEvicted() {
        let policy = SLRUReplacementPolicy<Int>(maxCost: 2, referencedSegmentFraction: 0.5)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [0])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [1])
    }

    func test_whenCacheOverflow_itemsEvictedFromBothLists() {
        let policy = SLRUReplacementPolicy<Int>(maxCost: 2, referencedSegmentFraction: 0.5)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 0, cost: 1), [])
        policy.cacheHit(for: 0)
        XCTAssertEqual(policy.evictedKeysForAdded(key: 1, cost: 1), [])
        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 2), [1, 0])
    }

}
