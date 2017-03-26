//
//  LRUReplacementPolicyTests.swift
//  Cache
//
//  Created by Dmitry Bespalov on 25/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import XCTest
@testable import Cache

class LRUReplacementPolicyTests: XCTestCase {

    // least recently used 
    // each entry has aging counter
    // on each use, we update list of keys
    // and then pop the one with the oldest age -- with the minimum age
    
}
