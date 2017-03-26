//
//  LRUReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 25/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Replacement policy that discards Least Recently Used items first.
class LRUReplacementPolicy<KeyType, ValueType>: ReplacementPolicy<KeyType, ValueType> where KeyType: Hashable {

    private let maxCost: Int

    init(maxCost: Int) {
        assert(maxCost >= 0)
        self.maxCost = maxCost
    }

}
