//
//  FifoEvictionPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class FifoEvictionPolicyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testCreate() {
        let _ = FifoEvictionPolicy<Int, Int>(costLimit: 0, costFunction: nil)
    }

    func test_whenSizeZero_isUnlimited() {
        let policy = FifoEvictionPolicy<Int, Int>(costLimit: 0, costFunction: nil)
        let unlimited = UnlimitedPolicy<Int, Int>()
        for key in (0..<100) {
            XCTAssertEqual(policy.evictedKeys(for: key, value: key),
                           unlimited.evictedKeys(for: key, value: key))
        }
    }

    func test_whenSizeOne_popsTheFirst() {
        let policy = FifoEvictionPolicy<Int, Int>(costLimit: 1, costFunction: identityCostFunction)
        XCTAssertEqual(policy.evictedKeys(for: 0, value: 0), [])
        XCTAssertEqual(policy.evictedKeys(for: 1, value: 1), [0])
    }

    func test_whenSizeTwo_popsTheFirstIn() {
        let policy = FifoEvictionPolicy<Int, Int>(costLimit: 2, costFunction: identityCostFunction)
        XCTAssertEqual(policy.evictedKeys(for: 0, value: 0), [])
        XCTAssertEqual(policy.evictedKeys(for: 1, value: 1), [])
        XCTAssertEqual(policy.evictedKeys(for: 2, value: 2), [0])
        XCTAssertEqual(policy.evictedKeys(for: 3, value: 3), [1])
    }

    func test_whenCostIrregular_popsUntilTotalCostReachesCostLimit() {
        let policy = FifoEvictionPolicy<Int, Int>(costLimit: 2, costFunction: { $0 })
        XCTAssertEqual(policy.evictedKeys(for: 0, value: 0), [])
        XCTAssertEqual(policy.evictedKeys(for: 1, value: 1), [])
        XCTAssertEqual(policy.evictedKeys(for: 2, value: 2), [0, 1])
    }

    func test_whenCostExceedsTheLimit_popsOnTheNextAdd() {
        let policy = FifoEvictionPolicy<Int, Int>(costLimit: 1, costFunction: { $0 })
        XCTAssertEqual(policy.evictedKeys(for: 2, value: 2), [])
        XCTAssertEqual(policy.evictedKeys(for: 3, value: 0), [2])
    }

}
