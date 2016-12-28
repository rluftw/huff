//
//  RLPriorityQueue.swift
//  huff
//
//  Created by Xing Hui Lu on 12/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

struct RLPriorityQueue<T: Comparable>: CustomStringConvertible {
    fileprivate var heap = [T]()
    
    var description: String {
        return "\(heap)"
    }
    
    // MARK: - basic operations
    
    var size: Int {
        return heap.count
    }
    
    mutating func push(item: T) {
        heap.append(item)
        swim(k: size-1)
    }
    
    mutating func pop() -> T? {
        if heap.count == 1 { return heap.removeFirst() }
        if heap.count == 0 { return nil }
        
        swap(&heap[0], &heap[size-1])
        let maxPriorityElement = heap.removeLast()
        sink(k: 0)
        return maxPriorityElement
    }
    
    mutating func removeAll() {
        heap.removeAll(keepingCapacity: false)
    }
    
    
    // MARK: - helper methods
    
    fileprivate mutating func swim(k: Int) {
        guard k > 0 && less(parent: (k-1)/2, child: k) else { return }
        swap(&heap[(k-1)/2], &heap[k])
        swim(k: (k-1)/2)
    }
    
    fileprivate mutating func sink(k: Int) {
        guard 2*k+1 < size && less(parent: k, child: 2*k+1) else { return }
        swap(&heap[2*k+1], &heap[k])
        sink(k: 2*k+1)
    }
    
    // if the parent is less than the child - true
    fileprivate func less(parent: Int, child: Int) -> Bool {
        return heap[parent] < heap[child]
    }
}
