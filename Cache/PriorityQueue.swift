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

enum PriorityQueueType {
    case minimum
    case maximum
}


/// Minimum/Maximum Priority queue with binary heap implementation
struct PriorityQueue<ValueType> where ValueType: Hashable {


    var isEmpty: Bool { return entries.isEmpty }
    var count: Int { return entries.count }
    /// Returns the element with the top priority
    var peek: ValueType? {
        return entries.first?.value
    }
    // Complexity O(n logn)
    var type: PriorityQueueType = .minimum {
        didSet {
            switch type {
            case .minimum:
                isOrderedBefore = { $0 < $1 }
            case .maximum:
                isOrderedBefore = { $0 > $1 }
            }
            for i in (0..<(count - 1)/2).reversed() {
                heapify(at: i)
            }
        }
    }
    private var entries = [Entry<ValueType>]()
    private var isOrderedBefore: (Int, Int) -> Bool = { $0 < $1 }

    /// Inserts the payload with specified priority
    mutating func insert(_ payload: ValueType, priority: Int) {
        add(type == .minimum ? Int.max : Int.min, payload)
        changePriority(at: count - 1, to: priority)
    }

    /// Removes and returns the element with the top priority
    mutating func dequeue() -> ValueType {
        assert(!isEmpty)
        let result = removeFirst()
        heapify(at: 0)
        return result
    }

    mutating func dequeueWithPriority() -> (ValueType, Int) {
        assert(!isEmpty)
        let result = entries.removeFirst()
        heapify(at: 0)
        return (result.value, result.priority)
    }

    /// Worst-case complexity is O(n), but since Foundation.Array of Hashable values is 
    /// not an array underneath, but more like a tree, the complexity should be O(log n).
    mutating func updatePriority(for payload: ValueType, to newPriority: Int) {
        guard let index = index(of: payload) else { return }
        let oldPriority = priority(index)
        if isOrderedBefore(newPriority, oldPriority) {
            changePriority(at: index, to: newPriority)
        } else {
            setPriority(at: index, to: newPriority)
            heapify(at: index)
        }
    }

    func contains(_ payload: ValueType) -> Bool {
        return entries.contains(Entry<ValueType>(priority: 0, value: payload))
    }

    private func index(of payload: ValueType) -> Int? {
        return entries.index(of: Entry(priority: 0, value: payload))
    }

    /// Same here, most probably complexity will be O(log n), but in worst case is O(n)
    mutating func remove(_ payload: ValueType) -> ValueType? {
        guard let index = index(of: payload) else { return nil }
        entries.remove(at: index)
        if index < count {
            heapify(at: index)
        }
        return payload
    }

    mutating func removeAll() {
        entries.removeAll()
    }

    private mutating func removeFirst() -> ValueType {
        return entries.removeFirst().value
    }

    /// Lets the value at the index float down in the 
    /// min/max-heap so that subtree rooted at the index
    /// obeys min/max-heap property
    private mutating func heapify(at index: Int) {
        let leftIndex = left(of: index)
        let rightIndex = right(of: index)
        var smallestIndex: Int
        if leftIndex < count && isOrderedBefore(priority(leftIndex), priority(index)) {
            smallestIndex = leftIndex
        } else {
            smallestIndex = index
        }
        if rightIndex < count && isOrderedBefore(priority(rightIndex), priority(smallestIndex)) {
            smallestIndex = rightIndex
        }
        if smallestIndex != index {
            exchangeElement(at: index, with: smallestIndex)
            heapify(at: smallestIndex)
        }
    }

    /// Changes the value of element priority to the new value,
    /// which is assumed to be at least as small as current
    /// value (for min-heap); or at least as big as current value (for max-heap) at the index.
    private mutating func changePriority(at index: Int, to newPriority: Int) {
        assert(isOrderedBefore(newPriority, priority(index)), "New priority is bigger than current priority")
        setPriority(at: index, to: newPriority)
        var elementIndex = index
        while elementIndex > 0 && !isOrderedBefore(priority(parent(of: elementIndex)), priority(elementIndex)) {
            exchangeElement(at: elementIndex, with: parent(of: elementIndex))
            elementIndex = parent(of: elementIndex)
        }
    }

    private func priority(_ index: Int) -> Int {
        return entries[index].priority
    }

    func priority(for key: ValueType) -> Int? {
        if let index = index(of: key) {
            return priority(index)
        }
        return nil
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
