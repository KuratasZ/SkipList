//
//  Stack.swift
//  KASSkipList
//
//  Created by Erwin on 2020/6/5.
//  Copyright © 2020 Kuratasx. All rights reserved.
//

import Cocoa

// MARK: - Stack
public struct Stack<T> {
    fileprivate var array: [T] = []
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public func peek() -> T? {
        return array.last
    }
}
// Sequence 迭代协议
extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var cur = self
        return AnyIterator { cur.pop() }
    }
}

