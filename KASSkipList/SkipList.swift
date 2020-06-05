//
//  SkipList.swift
//  KASSkipList
//
//  Created by Erwin on 2020/6/3.
//  Copyright © 2020 Kuratasx. All rights reserved.
//

import Cocoa

//breakpoint set -p return 在控制台输入后断点到return

//MARK: - SkipList
open class SkipList<Key: Comparable, T> {
    typealias Node = DataNode<Key, T>
    fileprivate(set) var head: Node?
    public init() {}
    private var showTime = false
}

extension SkipList {
    
    /// 找到指定key的前一个节点
    /// - Parameter key: 需要查询的键
    /// - Returns: 指定key的前一个节点
    func findPreviousNode(key: Key) -> Node? {
        var current = self.head
        var found = false
        var stop = false
        while !found && !stop {
            if self.showTime{
                debugPrint("---------->>\(#function)<<---------")
            }
            if current == nil {
                stop = true
            }else{
                if let next = current?.next{
                    if next.key == key {
                        found = true
                    }else{
                        if  key < next.key! {
                            current = current?.down
                        }else{
                            current = next
                        }
                    }
                }else{
                    current = current?.down
                }
            }
        }
        self.showTime = false
        if found {
            return current
        }else{
            return nil
        }
    }
    
    /// 返回key的值
    /// - Parameter key: 需要查询的键
    /// - Returns: 输入键的值或空
    func search(key: Key) -> T? {
        guard let node = self.findPreviousNode(key: key) else {
            return nil
        }
        return node.next?.data
    }
}

extension SkipList {
    
    /// 插入新元素
    /// - Parameters:
    ///   - key: 要插入的键
    ///   - data: 要插入的值
    public func insert(key: Key, data: T) {
        if self.head != nil {
            if let node = self.findPreviousNode(key: key) {
                // 发现已存在key，找到对应的前一个节点，替换掉对应塔中的所有元素的值
                var currentNode = node.next
                while currentNode != nil && currentNode!.key == key {
                    currentNode!.data = data
                    currentNode       = currentNode!.down
                }
            } else {
                //key不存在，采用新插入的方式
                insertItem(key: key, data: data)
            }
            
        } else {
            // 头节点不存在，开始初始化头节点流程
            bootstrapBaseLayer(key: key, data: data)
        }
    }
    
    
    private func insertItem(key: Key, data: T) {
        // 生成一个塔栈
        var stack              = Stack<Node>()
        var currentNode: Node? = head
        
        while currentNode != nil {
            //  从高到低，逐层检查
            //  和每层的节点比较，如果小于该节点的下个节点的key，说明当前层该节点是目标符合插入要求
            //  如果目标下一个节点不存在，说明当前该层节点也符合
            //  上面描述其实是一个判断规则 整个横轴是这样的 -∞->head->key_a->key_c->+∞
            //  也就是说如果next不存在，代表的意义是无穷大，即检查标准只有一个 key < next.key
            
            //  将符合要求的节点入栈
            //  next不存在，表明找到该层的插入节点的塔，开始下塔重复检查过程,直到完成
            
            //  完成时，最下层的完整链表层节点就在栈顶
            if let nextNode = currentNode?.next {
                if nextNode.key! > key {
                    stack.push(currentNode!)
                    currentNode = currentNode!.down
                } else {
                    currentNode = nextNode
                }
            } else {
                stack.push(currentNode!)
                currentNode = currentNode!.down
            }
        }
        
        // 从栈顶取出底层(完整层)的节点开始必须基本链接工作
        let itemAtLayer    = stack.pop()
        var node           = Node(key: key, data: data)
        node.next          = itemAtLayer!.next
        itemAtLayer!.next  = node
        var currentTopNode = node
        
        // 利用随机函数开始从塔栈中取出元素构建新的插入塔
        while flip() {
            if stack.isEmpty {
                // 如果塔栈耗尽，说明已经超过了所有塔高，需要新的head节点直接链接
                // 这种写法的关键就是最大塔高可以由随机函数控制
                let newHead    = Node(asHead: true)
                node           = Node(key: key, data: data)
                node.down      = currentTopNode
                newHead.next   = node
                newHead.down   = head
                head           = newHead
                currentTopNode = node
                
            } else {
                let nextNode  = stack.pop()
                node           = Node(key: key, data: data)
                node.down      = currentTopNode
                node.next      = nextNode!.next
                nextNode!.next = node
                currentTopNode = node
            }
        }
    }
    
    /// 构建基础头节点塔和插入新数据
    /// - Parameters:
    ///   - key: 要插入的键
    ///   - data: 要插入的值
    private func bootstrapBaseLayer(key: Key, data: T) {
        self.head = Node(asHead: true)
        var node = Node(key: key, data: data)
        self.head!.next = node
        var currentTopNode = node
        while flip() {
            let newHead = Node(asHead: true)
            node = Node(key: key, data: data)
            node.down = currentTopNode
            newHead.next = node
            newHead.down = head
            head = newHead
            currentTopNode = node
        }
    }
}

extension SkipList {
    func pop(key: Key) -> T? {
        var current = self.findPreviousNode(key: key)
        let value = current?.next?.data
        while current != nil  {
            current?.next = current?.next?.next
            current = self.findPreviousNode(key: key)
        }
        return value
    }
    
    func remove(key:Key) {
        _ = self.pop(key: key)
    }
}

extension SkipList {
    public func get(key: Key, show: Bool = false) -> T? {
        if show {
            debugPrint("开始获取------------->")
            self.showTime = show
        }
        return search(key: key)
    }
}

extension SkipList:CustomDebugStringConvertible{
    public var debugDescription: String {
        
        var current = self.head
        var stack = Stack<Node>()
        var str = "x"
        var list = [String]()
        
        while current != nil {
            stack.push(current!)
            current = current?.down
        }
        while !stack.isEmpty {
            current = stack.pop()
            while current != nil  {
                if current?.key != nil {
                    let t = current!.key.debugDescription
                    str = str + "->" + t
                } else {
                    str = str + "->" + "x"
                }
                current = current?.next
            }
            list.append(str)
            str = "x"
        }
        str = ""
        for l in list.reversed(){
            str += l + "\n"
        }
        return str
    }
}

// MARK: - DataNode
extension SkipList {
    class DataNode<Key: Comparable, T> {
        public typealias Node = DataNode<Key, T>
        var data: T?
        fileprivate var key: Key?
        var next: Node?
        var down: Node?
        
        public init(key: Key, data: T) {
            //如果不修改父类参数，不需要显式调用super.init()
            self.key  = key
            self.data = data
            
        }
        /// 生成头节点,参数无实际意义，仅提高可读性
        /// - Parameter head: 是否头节点
        public init(asHead head: Bool) {}
    }
}
// MARK: - Other

// 随机函数，决定要不要往塔中添加
private func flip() -> Bool {
    return Bool.random()
}

