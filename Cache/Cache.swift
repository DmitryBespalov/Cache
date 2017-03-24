//
//  Cache.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

final public class Cache<KeyType, ValueType, PolicyType>
    where KeyType: Hashable, PolicyType: EvictionPolicy,
        PolicyType.KeyType == KeyType, PolicyType.ValueType == ValueType {

    private var values: [KeyType: ValueType] = [:]
    private var policy: PolicyType

    public init(evictionPolicy: PolicyType) {
        policy = evictionPolicy
    }

    public func add(key: KeyType, value: ValueType) {
        evict(for: key, value: value)
        values[key] = value
    }

    private func evict(for key: KeyType, value: ValueType) {
        let evictedKeys = policy.evictedKeys(for: key, value: value)
        for evictedKey in evictedKeys {
            remove(key: evictedKey)
        }
    }

    public func value(for key: KeyType) -> ValueType? {
        return values[key]
    }

    public func asyncValue(for key: KeyType, createValue: (KeyType) -> ValueType?, completion: (ValueType?) -> Void) {
        if let result = value(for: key) {
            completion(result)
            return
        }
        let createdValue = createValue(key)
        if let result = createdValue {
            add(key: key, value: result)
        }
        completion(createdValue)
    }

    public func remove(key: KeyType) {
        values[key] = nil
    }

}
