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

    var recentItems = PriorityQueue<KeyType>()
    var frequentItems = PriorityQueue<KeyType>()
    var age = 0
    var maxRecentCost = 0
    var maxFrequentCost = 0
    var totalRecentCost = 0
    var totalFrequentCost = 0
    override var totalCost: Int {
        get { return totalRecentCost + totalFrequentCost }
        set { fatalError("Setting totalCost is prohibited") }
    }

    override init(maxCost: Int) {
        maxFrequentCost = maxCost / 2
        maxRecentCost = maxCost - maxFrequentCost
        super.init(maxCost: maxCost)
    }

    override func evictedKeysForAdded(key newKey: KeyType, cost newCost: Int) -> [KeyType] {
        var evicted = [KeyType]()
        while totalRecentCost + newCost > maxRecentCost && !recentItems.isEmpty {
            let item = recentItems.dequeue()
            let cost = self.cost(of: item)
            totalRecentCost -= cost
            evicted.append(item)
        }
        while totalCost + newCost > maxCost && !frequentItems.isEmpty {
            let item = frequentItems.dequeue()
            let cost = self.cost(of: item)
            totalFrequentCost -= cost
            evicted.append(item)
        }

        totalRecentCost += newCost
        costs[newKey] = newCost
        recentItems.insert(newKey, priority: age)
        age += 1
        assert(totalCost <= maxCost)
        return evicted
    }

    override func cacheHit(for key: KeyType) {
        let grandTotal = totalCost
        if let item = recentItems.remove(key) {
            totalRecentCost -= cost(of: item)
            while totalFrequentCost + cost(of: item) > maxFrequentCost && !frequentItems.isEmpty{
                let (degraded, prio) = frequentItems.dequeueWithPriority()
                totalFrequentCost -= cost(of: degraded)
                recentItems.insert(degraded, priority: prio)
                totalRecentCost += cost(of: degraded)
            }
            frequentItems.insert(item, priority: age)
            totalFrequentCost += cost(of: item)
        } else {
            frequentItems.updatePriority(for: key, to: age)
        }
        age += 1
        assert(totalCost == grandTotal, "Costs are messed up")
    }

}
