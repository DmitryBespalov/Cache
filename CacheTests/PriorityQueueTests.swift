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

    func test_peek() {
        XCTAssertNil(queue.peek)
    }

    private func insert(_ value: Int) {
        queue.insert(value, priority: value)
    }

    func test_oneElement() {
        insert(0)
        XCTAssertEqual(queue.peek, 0)
    }

    func test_twoElements() {
        insert(1)
        insert(0)
        XCTAssertEqual(queue.peek, 0)
    }

    func test_manyElements() {
        for i in (0..<10).reversed() {
            insert(i)
        }
        XCTAssertEqual(queue.peek, 0)
    }

    func test_whenTwoElements_dequeueReturnspeek() {
        insert(1)
        insert(0)
        XCTAssertEqual(queue.dequeue(), 0)
    }

    func test_whenManyelements_dequeueLeavesHeapPropertyCorrect() {
        insert(3)
        insert(1)
        insert(0)
        insert(2)
        XCTAssertEqual(queue.dequeue(), 0)
        XCTAssertEqual(queue.peek, 1)
    }

    func test_updatePriorityToBigger_changespeek() {
        insert(0)
        insert(1)
        queue.updatePriority(for: 0, to: 2)
        XCTAssertEqual(queue.peek, 1)
    }

    func test_updatePriorityToSmaller_changespeek() {
        insert(0)
        insert(1)
        insert(2)
        insert(3)
        queue.updatePriority(for: 3, to: -1)
        XCTAssertEqual(queue.peek, 3)
    }

    func test_remove_deletesValueFromQueue() {
        insert(0)
        insert(1)
        insert(2)
        let _ = queue.remove(0)
        let _ = queue.remove(1)
        XCTAssertEqual(queue.peek, 2)
    }

    func test_whenQueueChangingType_elementsAreResorted() {
        insert(0)
        insert(1)
        insert(2)
        insert(3)
        insert(4)
        queue.type = .maximum
        XCTAssertEqual(queue.dequeue(), 4)
        XCTAssertEqual(queue.dequeue(), 3)
        XCTAssertEqual(queue.dequeue(), 2)
        XCTAssertEqual(queue.dequeue(), 1)
        XCTAssertEqual(queue.dequeue(), 0)
    }
}
