//
//  LinkList.swift
//  KASSkipList
//
//  Created by Erwin on 2020/6/3.
//  Copyright © 2020 Kuratasx. All rights reserved.
//

import Cocoa

class LinkList<T>: Sequence {

    var head:Node<T>?
    
    func addAtHead(val: T) {
        if head == nil {
            head = Node(data: val)
        }else{
            let temp = Node(data: val)
            temp.next = head
            head = temp
        }
    }
    
    func makeIterator() -> LinkListIterator<T> {
        return LinkListIterator(self.head!)
    }

}

class LinkListIterator<T>: IteratorProtocol {
    
    private var data:Node<T>?
    init(_ node:Node<T>) {
        self.data = node
    }
    
    func next() -> Node<T>? {
        let temp = self.data
        self.data = self.data?.next
        return temp
    }
    
}

//MARK: - Node
class Node<T> {
    var next:Node?
    var data:T
    init(data: T) {
        self.data = data
    }
}
