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

    override func setUp() {
        super.setUp()
        cache = Cache<String, Int>()
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

    // how to specify eviction policy?
    // how to specify size/cost constraints?
    // how to specify creation call back for cache misses?
    // how to specify cost function?
    // how to work with implicit cost? 
    // how to work without maximum cost/size?
    // what if cost/size is irrelevant for eviction policy?
    // how to specify dependent protocols, like cache delegate?
    
}
