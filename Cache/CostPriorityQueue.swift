//
//  CostPriorityQueue.swift
//  Cache
//
//  Created by Dmitry Bespalov on 07/04/2017.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

struct CostPriorityQueue<ValueType> where ValueType: Hashable {

    private var queue = PriorityQueue<ValueType>()
    private var costs: [ValueType: Int] = [:]

    var isEmpty: Bool { return queue.isEmpty }
    var count: Int { return queue.count }
    var peek: ValueType? { return queue.peek }
    var totalCost: Int { return costs.reduce(0) { (sum: Int, value: (ValueType, Int)) -> Int in return  sum + value.1 } }
    var maxCost: Int = 0

    mutating func insert(_ payload: ValueType, priority: Int, cost: Int) {
        queue.insert(payload, priority: priority)
        costs[payload] = cost
    }

    func cost(of item: ValueType) -> Int {
        return costs[item] ?? 0
    }

    func shouldDequeueForAdding(cost: Int) -> Bool {
        return totalCost + cost > maxCost && !isEmpty
    }

    mutating func dequeue() -> (ValueType, Int, Int) {
        let (item, prio) = queue.dequeueWithPriority()
        let cost = costs.removeValue(forKey: item)!
        return (item, prio, cost)
    }

    mutating func updatePriority(for payload: ValueType, to newPriority: Int) {
        queue.updatePriority(for: payload, to: newPriority)
    }

    func contains(_ payload: ValueType) -> Bool {
        return queue.contains(payload)
    }

    /// @return removed key and cost
    mutating func remove(_ payload: ValueType) -> (ValueType, Int)? {
        if let item =  queue.remove(payload) {
            return (item, costs.removeValue(forKey: item)!)
        }
        return nil
    }

    mutating func removeAll() {
        queue.removeAll()
        costs.removeAll()
    }

    func priority(for key: ValueType) -> Int? {
        return queue.priority(for: key)
    }
    
}
