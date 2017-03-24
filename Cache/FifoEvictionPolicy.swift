//
//  FifoEvictionPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

func identityCostFunction<ValueType>(_ value: ValueType) -> Int {
    return 1
}

class FifoEvictionPolicy<KeyType, ValueType>: EvictionPolicy
    where KeyType: Hashable {

    private let costLimit: Int
    private let costFunction: (ValueType) -> Int
    private var keys: [KeyType] = []
    private var totalCost: Int = 0
    private var costs: [KeyType: Int] = [:]

    init(costLimit: Int, costFunction: ((ValueType) -> Int)?) {
        self.costLimit = costLimit
        self.costFunction = costFunction ?? identityCostFunction
    }

    func evictedKeys(for newKey: KeyType, value: ValueType) -> [KeyType] {
        if costLimit == 0 {
            return []
        }
        var evicted = [KeyType]()
        let cost = costFunction(value)
        while totalCost + cost > costLimit && !keys.isEmpty {
            if let oldKey = pop() {
                evicted.append(oldKey)
            }
        }
        push(key: newKey, cost: cost)
        return evicted
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
