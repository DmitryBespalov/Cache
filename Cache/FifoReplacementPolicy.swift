//
//  FifoReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

public class FifoReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    private let maxCost: Int
    private var totalCost: Int = 0
    var keys: [KeyType] = []
    private var costs: [KeyType: Int] = [:]

    public init(maxCost: Int) {
        assert(maxCost >= 0)
        self.maxCost = maxCost
    }

    override public func evictedKeysForAdded(key: KeyType, cost: Int) -> [KeyType] {
        if maxCost == 0 {
            return []
        }
        var evicted = [KeyType]()
        while totalCost + cost > maxCost && !keys.isEmpty {
            evicted.append(pop())
        }
        push(key: key, cost: cost)
        return evicted
    }

    override public func remove(key: KeyType) {
        if let index = keys.index(of: key) {
            keys.remove(at: index)
        }
        totalCost -= costs.removeValue(forKey: key) ?? 0
    }

    private func push(key: KeyType, cost: Int) {
        totalCost += cost
        costs[key] = cost
        pushKey(key: key)
    }

    // available for override
    func pushKey(key: KeyType) {
        keys.append(key)
    }

    private func pop() -> KeyType {
        assert(!keys.isEmpty)
        let key = popKey()
        totalCost -= costs[key] ?? 0
        return key
    }

    // available for override
    func popKey() -> KeyType {
        return keys.removeFirst()
    }

}
