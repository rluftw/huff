//
//  Array.swift
//  huff
//
//  Created by Xing Hui Lu on 12/28/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

// MARK: - array extension

// This method allows the use of O(logn) insertion while maintaining a sorted array
// The underlying logic is a binary search
extension Array where Element:Comparable {
    fileprivate func findIndexToInsert(item: Element, lo: Int, hi: Int) -> Int {
        let mid = (hi+lo)/2
        // low must be less to hi
        guard lo <= hi else {
            return lo
        }
        // if there's an identical item in the array
        guard self[mid] != item else {
            return mid
        }
        return findIndexToInsert(item: item, lo: self[mid] > item ? mid+1: lo, hi: self[mid] < item ? mid-1: hi)
    }
    
    mutating func insertOrdered(_ item: Element) {
        let index = findIndexToInsert(item: item, lo: 0, hi: self.count-1)
        insert(item, at: index)
    }
}
