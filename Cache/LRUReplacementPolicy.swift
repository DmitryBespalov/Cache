//
//  LRUReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 25/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Replacement policy that discards Least Recently Used items first.
class LRUReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    private let maxCost: Int
    private var costs = [KeyType: Int]()
    private var totalCost: Int = 0
    private var age: Int = 0
    private var recencies = PriorityQueue<KeyType>()

    init(maxCost: Int) {
        assert(maxCost >= 0)
        self.maxCost = maxCost
    }

    override func evictedKeysForAdded(key: KeyType, cost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while totalCost + cost > maxCost && !recencies.isEmpty {
            evicted.append(evictKey())
        }
        add(key, cost: cost)
        return evicted
    }

    private func add(_ key: KeyType, cost: Int) {
        costs[key] = cost
        age += 1
        totalCost += cost
        recencies.insert(key, priority: age)
    }

    private func evictKey() -> KeyType {
        let key = recencies.extractMin()
        totalCost -= costs.removeValue(forKey: key) ?? 0
        return key
    }

    override func cacheHit(for key: KeyType) {
        age += 1
        recencies.updatePriority(for: key, to: age)
    }

    override func remove(key: KeyType) {
        totalCost -= costs.removeValue(forKey: key) ?? 0
        recencies.remove(key)
    }

}
