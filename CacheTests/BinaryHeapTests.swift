//
//  BinaryHeapTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 26/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class BinaryHeapTests: XCTestCase {

    var heap = BinaryHeap()

    func test_minimum() {
        XCTAssertNil(heap.minimum)
    }

    func test_oneElement() {
        heap.insert(0)
        XCTAssertEqual(heap.minimum, 0)
    }

    func test_extractMin() {
        XCTAssertNil(heap.extractMin())
    }

    func test_twoElements() {
        heap.insert(1)
        heap.insert(0)
        XCTAssertEqual(heap.minimum, 0)
    }

    func test_manyElements() {
        for i in (0..<10).reversed() {
            heap.insert(i)
        }
        XCTAssertEqual(heap.minimum, 0)
    }

    func test_whenTwoElements_extractMinReturnsMinimum() {
        heap.insert(1)
        heap.insert(0)
        XCTAssertEqual(heap.extractMin(), 0)
    }

    func test_whenManyelements_extractMinLeavesHeapPropertyCorrect() {
        heap.insert(3)
        heap.insert(1)
        heap.insert(0)
        heap.insert(2)
        XCTAssertEqual(heap.extractMin(), 0)
        XCTAssertEqual(heap.minimum, 1)
    }
}
