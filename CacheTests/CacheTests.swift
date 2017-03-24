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

    var cache: Cache<String, Int, TestDelegate>!
    var policy: TestPolicy!
    var delegate: TestDelegate!

    override func setUp() {
        super.setUp()
        delegate = TestDelegate()
        policy = delegate.evictionPolicy
        cache = Cache<String, Int, TestDelegate>(delegate: delegate)
    }

    func test_getStoredValue() {
        cache.add(key: "0", value: 0)
        XCTAssertEqual(cache.value(for: "0"), 0)
    }

    func test_removesStoredValue() {
        cache.add(key: "0", value: 0)
        cache.remove(key: "0")
        XCTAssertNil(cache.value(for: "0"))
    }

    func test_removesEvictedValue_whenAddingNewEntries() {
        policy.evictedKeys = ["removed"]
        cache.add(key: "removed", value: 0)

        cache.add(key: "new", value: 1)

        XCTAssertNil(cache.value(for: "removed"))
        XCTAssertEqual(cache.value(for: "new"), 1)
    }

    func test_removesMultipleEvictedValues_whenAddingNewEntries() {
        policy.evictedKeys = ["removed1", "removed2"]
        cache.add(key: "removed1", value: -1)
        cache.add(key: "removed2", value: 0)

        cache.add(key: "new", value: 1)

        XCTAssertNil(cache.value(for: "removed1"))
        XCTAssertNil(cache.value(for: "removed2"))
        XCTAssertEqual(cache.value(for: "new"), 1)
    }

    func test_callsCreateCallback_whenCacheMissOccurs() {
        let exp = expectation(description: "Async")
        var result: Int?
        delegate.createdValue = 0
        cache.asyncValue(for: "0", completion: {
            result = $0
            exp.fulfill()
        })

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(result, 0)
    }

    func test_skipsCreateIfValueExists() {
        cache.add(key: "0", value: 0)
        var result: Int?
        delegate.createdValue = 1
        let exp = expectation(description: "Async")
        cache.asyncValue(for: "0", completion: {
            result = $0
            exp.fulfill()
        })

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(result, 0)
    }

    func test_whenCreatesValueAndHasSomethingToEvict_evictsValues() {
        policy.evictedKeys = ["removed"]
        cache.add(key: "removed", value: 1)
        delegate.createdValue = 0
        let exp = expectation(description: "Async")
        cache.asyncValue(for: "0", completion: { _ in
            exp.fulfill()
        })

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNil(cache.value(for: "removed"))
    }

    func test_whenCreatesValue_itStaysInCache() {
        let exp = expectation(description: "Async")
        delegate.createdValue = 0
        cache.asyncValue(for: "0", completion: { _ in
            exp.fulfill()
        })

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(cache.value(for: "0"), 0)
    }

    // I'll make as few extra architecture as possible
    // so that overall architecture as simple as needed
    // API needs to be intuitive and easy to use

    // how to specify eviction policy?
    //  * enum
    //  * class in constructor
    // how to specify size/cost constraints?
    //  * in constructor
    //  * in property
    //  * in eviction policy
    // how to specify creation call back for cache misses?
    //  * in constructor - one for all
    //  * in getter - more flexible
    //  * in delegate - also flexible
    // how to specify cost function?
    //  * constructor / property / delegate
    // how to work with implicit cost? 
    //  * have default function that has cost = 1 for each element
    // how to work without maximum cost/size?
    //  * do not evict at all
    // what if cost/size is irrelevant for eviction policy?
    //  * need concrete example to answer this.
    // how to specify dependent protocols, like cache delegate?
    //  * associated types
    //  * but i want to make things as simple, as possible
    
}
