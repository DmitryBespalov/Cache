//
//  MRUReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 27/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Replacement policy that discards Most Recently Used items first.
class MRUReplacementPolicy<KeyType>: LRUReplacementPolicy<KeyType> where KeyType: Hashable {

    override init(maxCost: Int) {
        super.init(maxCost: maxCost)
        recencies.type = PriorityQueueType.maximum
    }

}
