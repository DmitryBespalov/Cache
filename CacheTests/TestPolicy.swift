//
//  TestPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation
@testable import Cache

class TestPolicy: EvictionPolicy {

    typealias KeyType = String
    typealias ValueType = Int
    var evictedKeys: [String] = []

    func evictedKeys(for key: String, value: Int) -> [String] {
        return evictedKeys
    }
}
