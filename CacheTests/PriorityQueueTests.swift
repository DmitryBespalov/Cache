//
//  BinaryHeapTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 26/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class PriorityQueueTests: XCTestCase {

    var queue = PriorityQueue<Int>()

    func test_minimum() {
        XCTAssertNil(queue.minimum)
    }

    private func insert(_ value: Int) {
        queue.insert(value, priority: value)
    }

    func test_oneElement() {
        insert(0)
        XCTAssertEqual(queue.minimum, 0)
    }

    func test_twoElements() {
        insert(1)
        insert(0)
        XCTAssertEqual(queue.minimum, 0)
    }

    func test_manyElements() {
        for i in (0..<10).reversed() {
            insert(i)
        }
        XCTAssertEqual(queue.minimum, 0)
    }

    func test_whenTwoElements_extractMinReturnsMinimum() {
        insert(1)
        insert(0)
        XCTAssertEqual(queue.extractMin(), 0)
    }

    func test_whenManyelements_extractMinLeavesHeapPropertyCorrect() {
        insert(3)
        insert(1)
        insert(0)
        insert(2)
        XCTAssertEqual(queue.extractMin(), 0)
        XCTAssertEqual(queue.minimum, 1)
    }

    func test_updatePriorityToBigger_changesMinimum() {
        insert(0)
        insert(1)
        queue.updatePriority(for: 0, to: 2)
        XCTAssertEqual(queue.minimum, 1)
    }

    func test_updatePriorityToSmaller_changesMinimum() {
        insert(0)
        insert(1)
        insert(2)
        insert(3)
        queue.updatePriority(for: 3, to: -1)
        XCTAssertEqual(queue.minimum, 3)
    }

    func test_remove_deletesValueFromQueue() {
        insert(0)
        insert(1)
        insert(2)
        queue.remove(0)
        queue.remove(1)
        XCTAssertEqual(queue.minimum, 2)
    }
}
