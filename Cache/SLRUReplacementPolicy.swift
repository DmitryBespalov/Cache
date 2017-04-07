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
/// You need to specify proportion between size of referenced and unreferenced lists.
class SLRUReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    var referencedItems = CostPriorityQueue<KeyType>()
    var unreferencedItems = CostPriorityQueue<KeyType>()
    var age = 0

    override var totalCost: Int {
        get { return referencedItems.totalCost + unreferencedItems.totalCost }
        set { fatalError("Trying to set totalCost") }
    }

    init(maxCost: Int, referencedSegmentFraction: Double) {
        assert(0 <= referencedSegmentFraction && referencedSegmentFraction <= 1)
        referencedItems.maxCost = Int(Double(maxCost) * referencedSegmentFraction)
        unreferencedItems.maxCost = maxCost - referencedItems.maxCost
        super.init(maxCost: maxCost)
    }

    override func evictedKeysForAdded(key newKey: KeyType, cost newCost: Int) -> [KeyType] {
        guard maxCost > 0 else { return [] }
        let evicted = evictedUnreferencedKeys(for: newCost) + evictedReferencedKeys(for: newCost)
        add(newKey, cost: newCost)
        assert(totalCost <= maxCost)
        return evicted
    }

    override func add(_ key: KeyType, cost: Int) {
        unreferencedItems.insert(key, priority: age, cost: cost)
        age += 1
    }

    private func evictedUnreferencedKeys(for newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while unreferencedItems.shouldDequeueForAdding(cost: newCost) {
            let (evictedKey, _, _) = unreferencedItems.dequeue()
            evicted.append(evictedKey)
        }
        return evicted
    }

    private func evictedReferencedKeys(for newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while totalCost + newCost > maxCost && !referencedItems.isEmpty {
            let (evictedKey, _, _) = referencedItems.dequeue()
            evicted.append(evictedKey)
        }
        return evicted
    }

    override func cacheHit(for key: KeyType) {
        if let (hitKey, hitCost) = unreferencedItems.remove(key) {
            moveLeastRecentReferencedKeysToUnreferencedSegmentForReplacement(with: hitKey, cost: hitCost)
            referencedItems.insert(hitKey, priority: age, cost: hitCost)
            assert(totalCost <= maxCost)
        } else {
            referencedItems.updatePriority(for: key, to: age)
        }
        age += 1
    }

    private func moveLeastRecentReferencedKeysToUnreferencedSegmentForReplacement(with hitKey: KeyType, cost hitCost: Int) {
        while referencedItems.shouldDequeueForAdding(cost: hitCost) {
            let (key, priority, cost) = referencedItems.dequeue()
            unreferencedItems.insert(key, priority: priority, cost: cost)
        }
    }

    override func remove(key: KeyType) {
        if unreferencedItems.contains(key) {
            let _ = unreferencedItems.remove(key)
        } else if referencedItems.contains(key) {
            let _ = referencedItems.remove(key)
        }
    }

}
