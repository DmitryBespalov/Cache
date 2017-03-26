//
//  BinaryHeap.swift
//  Cache
//
//  Created by Dmitry Bespalov on 26/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

struct BinaryHeap {

    private var values = [Int]()

    /// Inserts the element value
    mutating func insert(_ key: Int) {
        values.append(Int.max)
        decreaseKey(at: values.count - 1, to: key)
    }

    /// Returns the element with the smallest key
    var minimum: Int? {
        return values.first
    }

    /// Removes and returns the element with the smallest key
    mutating func extractMin() -> Int? {
        if values.isEmpty {
            return nil
        }
        let result = values.removeFirst()
        minHeapify(at: 0)
        return result
    }

    /// Lets the value at the index float down in the 
    /// min-heap so that subtree rooted at the index
    /// obeys min-heap property
    private mutating func minHeapify(at index: Int) {
        let leftIndex = left(of: index)
        let rightIndex = right(of: index)
        var smallestIndex: Int
        if leftIndex < values.count && values[leftIndex] < values[index] {
            smallestIndex = leftIndex
        } else {
            smallestIndex = index
        }
        if rightIndex < values.count && values[rightIndex] < values[smallestIndex] {
            smallestIndex = rightIndex
        }
        if smallestIndex != index {
            exchangeElement(at: index, with: smallestIndex)
            minHeapify(at: smallestIndex)
        }
    }

    /// Decreases the value of element key's key to the new value
    /// newKey, which is assumed to be at least as small key's current
    /// value.
    mutating func decreaseKey(at index: Int, to newKey: Int) {
        assert(newKey <= values[index], "New key is bigger than current key")
        values[index] = newKey
        var elementIndex = index
        while elementIndex > 0 && values[parent(of: elementIndex)] > values[elementIndex] {
            exchangeElement(at: elementIndex, with: parent(of: elementIndex))
            elementIndex = parent(of: elementIndex)
        }
    }

    private func parent(of index: Int) -> Int {
        let result = Int(ceil(Double(index) / 2 - 1))
        return max(0, result)
    }

    private func left(of index: Int) -> Int {
        return 2 * index + 1
    }

    private func right(of index: Int) -> Int {
        return 2 * index + 2
    }

    private mutating func exchangeElement(at index: Int, with otherIndex: Int) {
        let firstValue = values[index]
        values[index] = values[otherIndex]
        values[otherIndex] = firstValue
    }

}
