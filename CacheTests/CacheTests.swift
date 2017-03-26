//
//  CacheTests.swift
//  CacheTests
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class CacheTests: XCTestCase {

    var cache: Cache<String, Int>!
    var policy: TestPolicy<String>!

    override func setUp() {
        super.setUp()
        policy = TestPolicy<String>()
        cache = Cache<String, Int>(policy: policy, calculateCost: CostFunction.calculateMemorySize)
    }

    private func add(key: String, value: Int) {
        cache.add(value: value, for: key)
    }

    private func fetch(key: String, createdValue: Int) -> Int? {
        let exp = expectation(description: "exp")
        var result: Int?
        cache.fetchValue(for: key, create: { _, completion in
            completion(createdValue)
        }) {
            result = $0
            exp.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
        return result
    }
    
    func test_getStoredValue() {
        add(key: "0", value: 0)
        XCTAssertEqual(cache.value(for: "0"), 0)
    }

    func test_removesStoredValue() {
        add(key: "0", value: 0)
        cache.removeValue(for: "0")
        XCTAssertNil(cache.value(for: "0"))
    }

    func test_removesEvictedValue_whenAddingNewEntries() {
        policy.evictedKeys = ["removed"]
        add(key: "removed", value: 0)

        add(key: "new", value: 1)

        XCTAssertNil(cache.value(for: "removed"))
        XCTAssertEqual(cache.value(for: "new"), 1)
    }

    func test_removesMultipleEvictedValues_whenAddingNewEntries() {
        policy.evictedKeys = ["removed1", "removed2"]
        add(key: "removed1", value: -1)
        add(key: "removed2", value: 0)

        add(key: "new", value: 1)

        XCTAssertNil(cache.value(for: "removed1"))
        XCTAssertNil(cache.value(for: "removed2"))
        XCTAssertEqual(cache.value(for: "new"), 1)
    }

    func test_callsCreateCallback_whenCacheMissOccurs() {
        XCTAssertEqual(fetch(key: "0", createdValue: 0), 0)
    }

    func test_skipsCreateIfValueExists() {
        add(key: "0", value: 0)
        XCTAssertEqual(fetch(key: "0", createdValue: 1), 0)
    }

    func test_whenCreatesValueAndHasSomethingToEvict_evictsValues() {
        policy.evictedKeys = ["removed"]
        add(key: "removed", value: 1)
        let _ = fetch(key: "0", createdValue: 0)

        XCTAssertNil(cache.value(for: "removed"))
    }

    func test_whenCreatesValue_itStaysInCache() {
        let _ = fetch(key: "0", createdValue: 0)

        XCTAssertEqual(cache.value(for: "0"), 0)
    }
    
}
