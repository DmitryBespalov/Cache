//
//  LFUReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 28/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation


/// Replaces the least frequently used item first.
class LFUReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    var frequencies = PriorityQueue<KeyType>()

    override func add(_ key: KeyType, cost: Int) {
        super.add(key, cost: cost)
        frequencies.insert(key, priority: 0)
    }

    override func removeKey() -> KeyType {
        return frequencies.dequeue()
    }

    override func cacheHit(for key: KeyType) {
        if let useCount = frequencies.priority(for: key) {
            frequencies.updatePriority(for: key, to: useCount + 1)
        }
    }

    override func remove(key: KeyType) {
        super.remove(key: key)
        let _ = frequencies.remove(key)
    }

}
