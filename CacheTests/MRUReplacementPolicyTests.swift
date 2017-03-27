//
//  MRUReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 27/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class MRUReplacementPolicyTests: XCTestCase {
    
    func test_whenTwoElements_evictsMostUsed() {
        let policy = MRUReplacementPolicy<Int>(maxCost: 2)
        let _ = policy.evictedKeysForAdded(key: 0, cost: 1)
        let _ = policy.evictedKeysForAdded(key: 1, cost: 1)

        policy.cacheHit(for: 0)

        XCTAssertEqual(policy.evictedKeysForAdded(key: 2, cost: 1), [0])
    }

    
}
