//
//  PriorityQueue.swift
//  Cache
//
//  Created by Dmitry Bespalov on 26/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

private struct Entry<ValueType>: Hashable where ValueType: Hashable {
    var priority: Int
    var value: ValueType
    var hashValue: Int { return value.hashValue }

    public static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return lhs.value == rhs.value
    }
}


/// Minimum Priority queue with binary heap implementation
struct PriorityQueue<ValueType> where ValueType: Hashable {

    private var entries = [Entry<ValueType>]()

    var isEmpty: Bool { return entries.isEmpty }
    var count: Int { return entries.count }
    /// Returns the element with the smallest priority
    var minimum: ValueType? {
        return entries.first?.value
    }

    /// Inserts the payload with specified priority
    mutating func insert(_ payload: ValueType, priority: Int) {
        add(Int.max, payload)
        decreasePriority(at: count - 1, to: priority)
    }

    /// Removes and returns the element with the smallest priority
    mutating func extractMin() -> ValueType {
        assert(!isEmpty)
        let result = removeFirst()
        minHeapify(at: 0)
        return result
    }

    mutating func updatePriority(for payload: ValueType, to newPriority: Int) {
        guard let index = index(of: payload) else { return }
        let oldPriority = priority(index)
        if newPriority > oldPriority {
            setPriority(at: index, to: newPriority)
            minHeapify(at: index)
        } else {
            decreasePriority(at: index, to: newPriority)
        }
    }

    private func index(of payload: ValueType) -> Int? {
        return entries.index(of: Entry(priority: 0, value: payload))
    }

    mutating func remove(_ payload: ValueType) {
        guard let index = index(of: payload) else { return }
        entries.remove(at: index)
        if index < count {
            minHeapify(at: index)
        }
    }

    private mutating func removeFirst() -> ValueType {
        return entries.removeFirst().value
    }

    /// Lets the value at the index float down in the 
    /// min-heap so that subtree rooted at the index
    /// obeys min-heap property
    private mutating func minHeapify(at index: Int) {
        let leftIndex = left(of: index)
        let rightIndex = right(of: index)
        var smallestIndex: Int
        if leftIndex < count && priority(leftIndex) < priority(index) {
            smallestIndex = leftIndex
        } else {
            smallestIndex = index
        }
        if rightIndex < count && priority(rightIndex) < priority(smallestIndex) {
            smallestIndex = rightIndex
        }
        if smallestIndex != index {
            exchangeElement(at: index, with: smallestIndex)
            minHeapify(at: smallestIndex)
        }
    }

    /// Decreases the value of element priority to the new value, 
    /// which is assumed to be at least as small as current
    /// value at the index.
    private mutating func decreasePriority(at index: Int, to newPriority: Int) {
        assert(newPriority <= priority(index), "New priority is bigger than current priority")
        setPriority(at: index, to: newPriority)
        var elementIndex = index
        while elementIndex > 0 && priority(parent(of: elementIndex)) > priority(elementIndex) {
            exchangeElement(at: elementIndex, with: parent(of: elementIndex))
            elementIndex = parent(of: elementIndex)
        }
    }

    private func priority(_ index: Int) -> Int {
        return entries[index].priority
    }

    private mutating func setPriority(at index: Int, to value: Int) {
        entries[index].priority = value
    }

    private mutating func add(_ priority: Int, _ payload: ValueType) {
        entries.append(Entry(priority: priority, value: payload))
    }

    private func parent(of index: Int) -> Int {
        let result = (index - 1) / 2
        return max(0, result)
    }

    private func left(of index: Int) -> Int {
        return 2 * index + 1
    }

    private func right(of index: Int) -> Int {
        return 2 * index + 2
    }

    private mutating func exchangeElement(at index: Int, with otherIndex: Int) {
        let firstEntry = entries[index]
        entries[index] = entries[otherIndex]
        entries[otherIndex] = firstEntry
    }

}
