//
//  FifoEvictionPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class FifoReplacementPolicyTests: XCTestCase {

    var policy: ReplacementPolicy<Int, Int>!

    private func createPolicy(maxCost: Int) {
        policy = FifoReplacementPolicy<Int, Int>(maxCost: maxCost)
    }

    private func evictedKeys(for key: Int, value: Int, cost: Int = 1) -> [Int] {
        return policy.evictedKeysForAdded(key: key, cost: cost)
    }

    func test_whenSizeZero_isUnlimited() {
        createPolicy(maxCost: 0)
        for key in (0..<100) {
            XCTAssertEqual(evictedKeys(for: key, value: key), [])
        }
    }

    func test_whenSizeOne_popsTheFirst() {
        createPolicy(maxCost: 1)
        XCTAssertEqual(evictedKeys(for: 0, value: 0), [])
        XCTAssertEqual(evictedKeys(for: 1, value: 1), [0])
    }

    func test_whenSizeTwo_popsTheFirstIn() {
        createPolicy(maxCost: 2)
        XCTAssertEqual(evictedKeys(for: 0, value: 0), [])
        XCTAssertEqual(evictedKeys(for: 1, value: 1), [])
        XCTAssertEqual(evictedKeys(for: 2, value: 2), [0])
        XCTAssertEqual(evictedKeys(for: 3, value: 3), [1])
    }

    func test_whenCostIrregular_popsUntilTotalCostReachesCostLimit() {
        createPolicy(maxCost: 2)
        XCTAssertEqual(evictedKeys(for: 0, value: 0, cost: 0), [])
        XCTAssertEqual(evictedKeys(for: 1, value: 1, cost: 1), [])
        XCTAssertEqual(evictedKeys(for: 2, value: 2, cost: 2), [0, 1])
    }

    func test_whenCostExceedsTheLimit_popsOnTheNextAdd() {
        createPolicy(maxCost: 1)
        XCTAssertEqual(evictedKeys(for: 2, value: 2, cost: 2), [])
        XCTAssertEqual(evictedKeys(for: 3, value: 0, cost: 0), [2])
    }

    func test_keyRemoval() {
        createPolicy(maxCost: 1)
        let _ = evictedKeys(for: 0, value: 0)
        policy.remove(key: 0)
        XCTAssertEqual(evictedKeys(for: 1, value: 1), [])
    }

}
