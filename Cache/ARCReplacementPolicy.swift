//
//  ARCReplacementPolicy.swift
//  Cache
//
//  Created by Dmitry Bespalov on 28/03/17.
//  Copyright © 2017 Dmitry Bespalov. All rights reserved.
//

import Foundation

/// Adaptive replacement cache policy.
///
/// Uses 4 LRU lists: 1 for recent entries, 1 for frequent entries, 1 for ghost list of 1st list, and 1 for ghost list
/// of 2nd list.
class ARCReplacmenetPolicy<KeyType>: ReplacementPolicy<KeyType> where KeyType: Hashable {

}
