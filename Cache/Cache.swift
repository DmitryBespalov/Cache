//
//  Cache.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

final class Cache<KeyType, ValueType, PolicyType> where KeyType: Hashable, PolicyType: EvictionPolicy, PolicyType.KeyType == KeyType, PolicyType.ValueType == ValueType {

    private var values: [KeyType: ValueType] = [:]
    private var policy: PolicyType

    init(evictionPolicy: PolicyType) {
        policy = evictionPolicy
    }

    func add(key: KeyType, value: ValueType) {
        let evictedKeys = policy.evictedKeys(for: key, value: value)
        for evictedKey in evictedKeys {
            remove(key: evictedKey)
        }
        values[key] = value
    }

    func value(for key: KeyType) -> ValueType? {
        return values[key]
    }

    func remove(key: KeyType) {
        values[key] = nil
    }

}
