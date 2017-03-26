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

public class ReplacementPolicy<KeyType> {

    public func evictedKeysForAdded(key: KeyType, cost: Int) -> [KeyType] {
        return []
    }

    public func remove(key: KeyType) {
        
    }

    public func cacheHit(for key: KeyType) {
        
    }

}
