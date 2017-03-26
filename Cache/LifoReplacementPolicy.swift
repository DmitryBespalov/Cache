//
//  LifoReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 25/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

public class LifoReplacementPolicy<KeyType>: FifoReplacementPolicy<KeyType> where KeyType: Hashable {

    override func pushKey(key: KeyType) {
        keys.append(key)
    }

    override func popKey() -> KeyType {
        return keys.removeLast()
    }
    
}
