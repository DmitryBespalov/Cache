//
//  UnlimitedPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Never evicts any key
class UnlimitedPolicy<KeyType, ValueType>: EvictionPolicy {

    func evictedKeys(for key: KeyType, value: ValueType) -> [KeyType] {
        return []
    }

}
