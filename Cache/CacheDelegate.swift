//
//  CacheDelegate.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

public protocol CacheDelegate: class {
    associatedtype KeyType
    associatedtype ValueType
    associatedtype Policy: EvictionPolicy
    var evictionPolicy: Policy { get }
    func createValue(for key: KeyType, completion: @escaping (ValueType?) -> Void)
}
