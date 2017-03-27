//
//  RReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 27/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Random replacement policy
class RReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    var randomGenerator: (Int) -> Int = { count in Int(arc4random_uniform(UInt32(count))) }
    private var keys: [KeyType] = []

    override func add(_ key: KeyType, cost: Int) {
        super.add(key, cost: cost)
        keys.append(key)
    }

    override func removeKey() -> KeyType {
        return keys.remove(at: randomGenerator(keys.count))
    }

    override func remove(key: KeyType) {
        super.remove(key: key)
        guard maxCost > 0 else { return }
        if let index = keys.index(of: key) {
            keys.remove(at: index)
        }
    }
    
}
