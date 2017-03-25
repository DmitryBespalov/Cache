//
//  LifoReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 25/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class LifoReplacementPolicyTests: XCTestCase {

    var policy: ReplacementPolicy<Int, Int>!

    private func createPolicy(maxCost: Int) {
        policy = LifoReplacementPolicy<Int, Int>(maxCost: maxCost)
    }

    private func evictedKeys(for key: Int, value: Int, cost: Int = 1) -> [Int] {
        return policy.evictedKeysForAdded(key: key, cost: cost)
    }

    func test_whenSizeTwo_popsLastIn() {
        createPolicy(maxCost: 2)
        XCTAssertEqual(evictedKeys(for: 0, value: 0), [])
        XCTAssertEqual(evictedKeys(for: 1, value: 1), [])
        XCTAssertEqual(evictedKeys(for: 2, value: 2), [1])
        XCTAssertEqual(evictedKeys(for: 3, value: 3), [2])
    }

}
