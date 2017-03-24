//
//  InstantCacheDelegate.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

class InstantCacheDelegate<KeyType, ValueType>: CacheDelegate {

    var evictionPolicy = UnlimitedPolicy<KeyType, ValueType>()

    func createValue(for key: KeyType, completion: @escaping (ValueType?) -> Void) {
        completion(nil)
    }

}
