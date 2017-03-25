//
//  CacheIntegrationTests.swift
//  CacheIntegrationTests
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class CacheIntegrationTests: XCTestCase {

    class Server {

        func loadValue(for key: Int, completion: @escaping (_ value: Int?) -> Void) {
            DispatchQueue.global().async {
                sleep(1)
                DispatchQueue.main.async {
                    completion(key)
                }
            }
        }

    }

    let server = Server()

    func test_fifo() {
        let policy: ReplacementPolicy<Int, Int> = FifoReplacementPolicy<Int, Int>(maxCost: 5)
        let cache = Cache<Int, Int>(policy: policy, calculateCost: { _ in 1 })

        for key in (0..<10) {
            let exp = expectation(description: "exp\(key)")
            cache.fetchValue(for: key, create: { key, completion in
                self.server.loadValue(for: key, completion: completion)
            }, completion: { _ in
                exp.fulfill()
            })
        }
        waitForExpectations(timeout: 5, handler: nil)

        for key in (0..<10).reversed() {
            let _ = cache.value(for: key)
        }
        XCTAssertEqual(cache.hitCount, 5)
        XCTAssertEqual(cache.missCount, 10 + 5)
    }

}
