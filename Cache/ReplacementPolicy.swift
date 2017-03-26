//
//  ReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

public class CostFunction<ValueType> {
    
    public static func calculateMemorySize(_ value: ValueType) -> Int {
        return MemoryLayout<ValueType>.size(ofValue: value)
    }

}

public class ReplacementPolicy<KeyType> where KeyType: Hashable {

    private let maxCost: Int
    private var totalCost: Int = 0
    private var costs: [KeyType: Int] = [:]

    public init(maxCost: Int) {
        assert(maxCost >= 0)
        self.maxCost = maxCost
    }

    public func evictedKeysForAdded(key: KeyType, cost: Int) -> [KeyType] {
        guard maxCost > 0 else { return [] }
        var evicted = [KeyType]()
        while totalCost + cost > maxCost && !costs.isEmpty {
            evicted.append(evictKey())
        }
        add(key, cost: cost)
        return evicted
    }

    func add(_ key: KeyType, cost: Int) {
        costs[key] = cost
        totalCost += cost
    }

    func evictKey() -> KeyType {
        let key = removeKey()
        totalCost -= costs.removeValue(forKey: key) ?? 0
        return key
    }

    func removeKey() -> KeyType {
        fatalError("\(#function): This method must be overriden")
    }

    public func remove(key: KeyType) {
        guard maxCost > 0 else { return }
        totalCost -= costs.removeValue(forKey: key) ?? 0
    }

    public func cacheHit(for key: KeyType) {
    }

}
