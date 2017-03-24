//
//  EvictionPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

public protocol EvictionPolicy {
    associatedtype KeyType
    associatedtype ValueType
    func evictedKeys(for key: KeyType, value: ValueType) -> [KeyType]
}
