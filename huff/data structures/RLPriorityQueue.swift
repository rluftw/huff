//
//  RLPriorityQueue.swift
//  huff
//
//  Created by Xing Hui Lu on 12/24/16.
//  Copyright © 2016 Xing Hui Lu. All rights reserved.
//

import Foundation

struct RLPriorityQueue<T: Comparable> {
    fileprivate var buffer = [T]()
    
    mutating func insert(item: T) {
        // add item to the last position of the container
        buffer.append(item)
        
        heapify(index: buffer.count-1)
        
        var outputString = ""
        for int in buffer {
            outputString += "\(int)\t"
        }
        
        print(outputString)
    }
    
    // insures that the structure stays as a heap
    // - parent node is less than the child nodes
    mutating func heapify(index: Int) {
        // termination condition
        guard index != 0 else {
            return
        }
        
        let parentIndex: Int = (index-1)/2
        let element = buffer[index]
        let parentElement = buffer[parentIndex]
        
        print("parent index: \(parentIndex)\telement index: \(index)")
        
        // if the element is greater dont do anything
        // if the element is less than swap
        guard element < parentElement else {
            swap(index1: index, index2: parentIndex)
            heapify(index: parentIndex)
            
            return
        }
    }
    
    fileprivate mutating func swap(index1: Int, index2: Int) {
        let element1 = buffer[index1]
        buffer[index1] = buffer[index2]
        buffer[index2] = element1
    }
    
    func isEmpty() -> Bool {
        return buffer.isEmpty
    }
    
    func size() -> Int {
        return buffer.count
    }
}
