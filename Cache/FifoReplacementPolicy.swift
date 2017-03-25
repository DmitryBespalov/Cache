//
//  FifoReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

class FifoReplacementPolicy<KeyType, ValueType>: ReplacementPolicy<KeyType, ValueType> where KeyType: Hashable {

    private let maxCost: Int
    private var totalCost: Int = 0
    private var keys: [KeyType] = []
    private var costs: [KeyType: Int] = [:]

    init(maxCost: Int) {
        assert(maxCost >= 0)
        self.maxCost = maxCost
    }

    override func evictedKeysForAdded(key: KeyType, cost: Int) -> [KeyType] {
        if maxCost == 0 {
            return []
        }
        var evicted = [KeyType]()
        while totalCost + cost > maxCost && !keys.isEmpty {
            if let oldKey = pop() {
                evicted.append(oldKey)
            }
        }
        push(key: key, cost: cost)
        return evicted
    }

    override func remove(key: KeyType) {
        if let index = keys.index(of: key) {
            keys.remove(at: index)
        }
        costs[key] = nil
    }

    private func push(key: KeyType, cost: Int) {
        totalCost += cost
        costs[key] = cost
        keys.append(key)
    }

    private func pop() -> KeyType? {
        if keys.isEmpty {
            return nil
        }
        let key = keys.removeFirst()
        totalCost -= costs[key] ?? 0
        return key
    }

}
