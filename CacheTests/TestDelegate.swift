//
//  TestDelegate.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation
@testable import Cache

class TestDelegate: CacheDelegate {
    typealias KeyType = String
    typealias ValueType = Int
    typealias Policy = TestPolicy

    var evictionPolicy = TestPolicy()
    var createdValue: Int?

    func createValue(for key: String, completion: @escaping (Int?) -> Void) {
        completion(createdValue)
    }
}
