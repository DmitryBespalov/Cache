//
//  FifoReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

public class FifoReplacementPolicy<KeyType>: ReplacementPolicy<KeyType>  where KeyType: Hashable {

    var keys: [KeyType] = []

    override public func remove(key: KeyType) {
        super.remove(key: key)
        if let index = keys.index(of: key) {
            keys.remove(at: index)
        }
    }

    override func add(_ key: KeyType, cost: Int) {
        super.add(key, cost: cost)
        keys.append(key)
    }

    override func removeKey() -> KeyType {
        return keys.removeFirst()
    }

}
