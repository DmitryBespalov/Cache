//
//  Cache.swift
//  Cache
//
//  Created by Dmitry Bespalov on 24/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

class Cache<KeyType, ValueType> {

    private var value: ValueType?

    func add(key: KeyType, value: ValueType) {
        self.value = value
    }

    func value(for key: KeyType) -> ValueType? {
        return value
    }

    func remove(key: KeyType) {
        self.value = nil
    }

}
