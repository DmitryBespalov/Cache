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

    let maxCost: Int
    var totalCost: Int = 0
    var costs: [KeyType: Int] = [:]

    public init(maxCost: Int) {
        assert(maxCost >= 0)
        self.maxCost = maxCost
    }

    // NOTE: If you don't override this method, you have to override removeKey()
    public func evictedKeysForAdded(key newKey: KeyType, cost newCost: Int) -> [KeyType] {
        guard maxCost > 0 else { return [] }
        var evicted = [KeyType]()
        while totalCost + newCost > maxCost && !costs.isEmpty {
            evicted.append(evictKey())
        }
        add(newKey, cost: newCost)
        return evicted
    }

    public func remove(key: KeyType) {
        guard maxCost > 0 else { return }
        totalCost -= costs.removeValue(forKey: key) ?? 0
    }

    public func cacheHit(for key: KeyType) {
    }

    /// Called on cache miss
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

}
