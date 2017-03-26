//
//  Cache.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

final public class Cache<KeyType, ValueType> where KeyType: Hashable {

    public private (set) var hitCount: Int = 0
    public private (set) var missCount: Int = 0
    private var values: [KeyType: ValueType] = [:]
    private let policy: ReplacementPolicy<KeyType>
    private let calculateCost: (ValueType) -> Int

    public init(policy: ReplacementPolicy<KeyType>, calculateCost: @escaping (ValueType) -> Int) {
        self.policy = policy
        self.calculateCost = calculateCost
    }

    public func add(value: ValueType, for key: KeyType) {
        for evictedKey in policy.evictedKeysForAdded(key: key, cost: calculateCost(value)) {
            removeValue(for: evictedKey)
        }
        values[key] = value
    }

    public func value(for key: KeyType) -> ValueType? {
        let result = values[key]
        if let _ = result {
            hitCount = hitCount &+ 1
            policy.cacheHit(for: key)
        } else {
            missCount = missCount &+ 1
        }
        return result
    }

    public func fetchValue(for key: KeyType,
                           create: (KeyType, @escaping (ValueType?) -> Void) -> Void,
                           completion: @escaping (ValueType?) -> Void) {
        if let result = value(for: key) {
            completion(result)
            return
        }
        create(key) { [weak self] (newValue: ValueType?) in
            if let createdValue = newValue {
                self?.add(value: createdValue, for: key)
            }
            completion(newValue)
        }
    }

    public func removeValue(for key: KeyType) {
        policy.remove(key: key)
        values[key] = nil
    }

}
