//
//  Cache.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

final public class Cache<KeyType, ValueType, DelegateType>
    where KeyType: Hashable,
          DelegateType: CacheDelegate,
            DelegateType.KeyType == KeyType, DelegateType.ValueType == ValueType,
          DelegateType.Policy: EvictionPolicy,
            DelegateType.Policy.KeyType == KeyType, DelegateType.Policy.ValueType == ValueType {

    private var values: [KeyType: ValueType] = [:]
    private var policy: DelegateType.Policy
    private weak var delegate: DelegateType!
    public private (set) var hitCount: Int = 0
    public private (set) var missCount: Int = 0

    public init(delegate: DelegateType) {
        self.delegate = delegate
        policy = self.delegate.evictionPolicy
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
        let result = values[key]
        if let _ = result {
            hitCount = hitCount &+ 1
        } else {
            missCount = missCount &+ 1
        }
        return result
    }

    public func asyncValue(for key: KeyType, completion: @escaping (ValueType?) -> Void) {
        if let result = value(for: key) {
            completion(result)
            return
        }
        delegate.createValue(for: key) { [weak self] (newValue: ValueType?) in
            if let createdValue = newValue {
                self?.add(key: key, value: createdValue)
            }
            completion(newValue)
        }
    }

    public func remove(key: KeyType) {
        values[key] = nil
    }

}
