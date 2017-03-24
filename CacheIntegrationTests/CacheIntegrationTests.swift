//
//  CacheIntegrationTests.swift
//  CacheIntegrationTests
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class CacheIntegrationTests: XCTestCase, CacheDelegate {

    typealias KeyType = String
    typealias ValueType = Int
    typealias Policy = UnlimitedPolicy<String, Int>

    class Server {

        func loadValue(for key: String, completion: @escaping (_ value: Int?) -> Void) {
            DispatchQueue.global().async {
                sleep(1)
                DispatchQueue.main.async {
                    completion(Int(key))
                }
            }
        }

    }

    var server: Server!
    var cache: Cache<String, Int, CacheIntegrationTests>!

    override func setUp() {
        super.setUp()
        server = Server()
        cache = Cache<String, Int, CacheIntegrationTests>(delegate: self)
    }

    // MARK - CacheDelegate
    var evictionPolicy = UnlimitedPolicy<String, Int>()

    func createValue(for key: String, completion: @escaping (Int?) -> Void) {
        server.loadValue(for: key, completion: completion)
    }

    // MARK - Tests

    func test_integrationWithNetworkMock() {
        let expectedCacheMissCount = 10 + 10 + 5
        let expectedCacheHitCount = 5
        for keyBase in (0..<10) {
            let key = String(keyBase)
            XCTAssertNil(cache.value(for: key))
            let exp = expectation(description: key)
            cache.asyncValue(for: key) { result in
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        for keyBase in (0..<5) {
            let key = String(keyBase)
            XCTAssertEqual(cache.value(for: key), keyBase)
        }
        for keyBase in (10..<15) {
            let key = String(keyBase)
            XCTAssertNil(cache.value(for: key))
        }
        XCTAssertEqual(cache.hitCount, expectedCacheHitCount)
        XCTAssertEqual(cache.missCount, expectedCacheMissCount)
    }
    
}
