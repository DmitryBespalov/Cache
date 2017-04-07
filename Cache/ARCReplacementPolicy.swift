//
//  ARCReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 28/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Adaptive replacement cache policy.
///
/// Uses 4 LRU lists: 1 for recent entries, 1 for frequent entries, 1 for ghost list of 1st list, and 1 for ghost list
/// of 2nd list.

class ARCReplacementPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

    var recentItems = CostPriorityQueue<KeyType>()
    var ghostRecentItems = CostPriorityQueue<KeyType>()
    var frequentItems = CostPriorityQueue<KeyType>()
    var ghostFrequentItems = CostPriorityQueue<KeyType>()

    var age = 0

    override var totalCost: Int {
        get { return recentItems.totalCost + frequentItems.totalCost }
        set { fatalError("Setting totalCost is prohibited") }
    }

    override init(maxCost: Int) {
        frequentItems.maxCost = maxCost / 2
        ghostFrequentItems.maxCost = frequentItems.maxCost
        recentItems.maxCost = maxCost - frequentItems.maxCost
        ghostRecentItems.maxCost = recentItems.maxCost
        super.init(maxCost: maxCost)
    }

    override func evictedKeysForAdded(key newKey: KeyType, cost newCost: Int) -> [KeyType] {
        if ghostRecentItems.contains(newKey) {
            recentItems.maxCost += newCost
            frequentItems.maxCost -= newCost
        }
        let evicted = evictedRecentItems(forCost: newCost) + evictedFrequentItems(forCost: newCost)
        recentItems.insert(newKey, priority: age, cost: newCost)
        age += 1
        assert(totalCost <= maxCost)
        return evicted
    }

    private func evictedRecentItems(forCost newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while recentItems.shouldDequeueForAdding(cost: newCost) {
            let (item, prio, cost) = recentItems.dequeue()
            insert(into: &ghostRecentItems, item: item, priority: prio, cost: cost)
            evicted.append(item)
        }
        return evicted
    }

    private func evictedFrequentItems(forCost newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while totalCost + newCost > maxCost && !frequentItems.isEmpty {
            let (item, prio, cost) = frequentItems.dequeue()
            insert(into: &ghostFrequentItems, item: item, priority: prio, cost: cost)
            evicted.append(item)
        }
        return evicted
    }

    private func insert(into queue: inout CostPriorityQueue<KeyType>, item: KeyType, priority: Int, cost: Int) {
        while queue.shouldDequeueForAdding(cost: cost) {
            let _ = queue.dequeue()
        }
        queue.insert(item, priority: priority, cost: cost)
    }

    override func cacheHit(for key: KeyType) {
        let grandTotal = totalCost
        if let (item, cost) = recentItems.remove(key) {
            if ghostFrequentItems.contains(item) {
                frequentItems.maxCost += cost
                recentItems.maxCost -= cost
            }
            moveFrequentItemsToRecentItems(forCost: cost)
            frequentItems.insert(item, priority: age, cost: cost)
        } else {
            frequentItems.updatePriority(for: key, to: age)
        }
        age += 1
        assert(totalCost == grandTotal, "Costs are messed up")
    }

    private func moveFrequentItemsToRecentItems(forCost cost: Int) {
        while frequentItems.shouldDequeueForAdding(cost: cost) {
            let (degraded, prio, degradedCost) = frequentItems.dequeue()
            insert(into: &ghostFrequentItems, item: degraded, priority: prio, cost: degradedCost)
            recentItems.insert(degraded, priority: prio, cost: degradedCost)
        }
    }

    override func remove(key: KeyType) {
        if frequentItems.contains(key) {
            let result = frequentItems.remove(key)!
            insert(into: &ghostRecentItems, item: result.0, priority: age, cost: result.1)
        } else if recentItems.contains(key) {
            let result = recentItems.remove(key)!
            insert(into: &ghostFrequentItems, item: result.0, priority: age, cost: result.1)
        }
        age += 1
    }

}
