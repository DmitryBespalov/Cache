//
//  SLRUReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 27/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation


/// Segmented LRU. 
/// Uses 2 lists: unreferenced and referenced. Size of the referenced list is a fixed fraction of max cache size.
///
/// All cache misses go into unreferenced list. 
/// When cache hit occurs, the element goes to the referenced list with updated priority (age).
///
/// When referenced list is full and there's a cache hit for item A in unreferenced list,
/// referenced list evicts least recently used item B, places item A in referenced list, and item B in unreferenced list.
///
/// When cache size exceeds the threshold, least recently used items are evicted from unreferenced list, then
/// least recently used items are evicted from referenced list.
/// 
/// You need to specify proportion between size of reference and unreferenced lists.
class SLRUReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    let maxReferencedCost: Int
    var referencedSegment = PriorityQueue<KeyType>()
    var unreferencedSegment = PriorityQueue<KeyType>()
    var age = 0
    var totalReferencedCost = 0

    init(maxCost: Int, referencedSegmentFraction: Double) {
        assert(0 <= referencedSegmentFraction && referencedSegmentFraction <= 1)
        maxReferencedCost = Int(Double(maxCost) * referencedSegmentFraction)
        super.init(maxCost: maxCost)
    }

    override func evictedKeysForAdded(key newKey: KeyType, cost newCost: Int) -> [KeyType] {
        guard maxCost > 0 else { return [] }
        let evicted = evictedUnreferencedKeys(for: newCost) + evictedReferencedKeys(for: newCost)
        add(newKey, cost: newCost)
        assert(totalCost <= maxCost)
        assert(totalReferencedCost <= maxReferencedCost)
        return evicted
    }

    override func add(_ key: KeyType, cost: Int) {
        unreferencedSegment.insert(key, priority: age)
        age += 1
        totalCost += cost
        costs[key] = cost
    }

    private func evictedUnreferencedKeys(for newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while totalCost - totalReferencedCost + newCost > maxCost - maxReferencedCost && !unreferencedSegment.isEmpty {
            let evictedKey = unreferencedSegment.dequeue()
            let evictedCost = costs.removeValue(forKey: evictedKey) ?? 0
            totalCost -= evictedCost
            evicted.append(evictedKey)
        }
        return evicted
    }

    private func evictedReferencedKeys(for newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while totalCost + newCost > maxCost && !referencedSegment.isEmpty {
            let evictedKey = referencedSegment.dequeue()
            let evictedCost = costs.removeValue(forKey: evictedKey) ?? 0
            totalCost -= evictedCost
            totalReferencedCost -= evictedCost
            evicted.append(evictedKey)
        }
        return evicted
    }

    override func cacheHit(for key: KeyType) {
        if let hitKey = unreferencedSegment.remove(key) {
            moveLeastRecentReferencedKeysToUnreferencedSegmentForReplacement(with: hitKey)
            referencedSegment.insert(hitKey, priority: age)
            totalReferencedCost += cost(of: hitKey)
            assert(totalCost <= maxCost)
            assert(totalReferencedCost <= maxReferencedCost)
        } else {
            referencedSegment.updatePriority(for: key, to: age)
        }
        age += 1
    }

    private func moveLeastRecentReferencedKeysToUnreferencedSegmentForReplacement(with hitKey: KeyType) {
        while totalReferencedCost + cost(of: hitKey) > maxReferencedCost && !referencedSegment.isEmpty {
            let forcedKey: (key: KeyType, priority: Int) = referencedSegment.dequeueWithPriority()
            let forcedCost = cost(of: forcedKey.key)
            totalReferencedCost -= forcedCost
            unreferencedSegment.insert(forcedKey.key, priority: forcedKey.priority)
        }
    }

    override func remove(key: KeyType) {
        super.remove(key: key)
        if referencedSegment.contains(key) {
            let _ = referencedSegment.remove(key)
        } else if unreferencedSegment.contains(key) {
            let _ = unreferencedSegment.remove(key)
        }
    }

}
