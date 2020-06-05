//
//  RedBlackBST.swift
//  KASSkipList
//
//  Created by Erwin on 2020/6/5.
//  Copyright © 2020 Kuratasx. All rights reserved.
//

import Cocoa



/// 红黑树
///
/// 原型是2-3树，红色链接的两个点组成一个3结点，黑的单点则是2结点
///
/// 红链接均为左链接
///
/// 没有任何一个结点同时和两条红链接相连
///
/// 完美黑色平衡，即任意空链到根结点的黑链数量相同
///
open class RedBlackBST<Key: Comparable, T> {
    public typealias Node = RBNode<Key, T>
    private var root: Node?
}

// MARK: - func list
extension RedBlackBST {
    func put(key:Key, data:T) {
        root = put(node: self.root, key: key, data: data)
        root?.color = .black
    }
    private func put(node:Node?, key:Key, data:T) -> Node{
        guard  var _node = node else {
            return Node(key: key, data: data, sum: 1, color: .red)
        }
        if key < _node.key {
            _node.left = self.put(node: _node.left, key: key, data: data)
        }else if key > _node.key{
            _node.right = self.put(node: _node.right, key: key, data: data)
        }else{
            _node.data = data
        }
        
        if self.isRed(_node.right) && !self.isRed(_node.left){
            _node = self.rotateLeft(_node)
        }
        if self.isRed(_node.left) && self.isRed(_node.left?.left){
            _node = self.rotateRight(_node)
        }
        if self.isRed(_node.left) && self.isRed(_node.right){
            self.flipColor(_node)
        }
        
        _node.sum = self.size(_node.left) + size(_node.right) + 1
        
        return _node
    }
    
    
    // 左旋右旋只有前三行代码不同，要把它想象成圆周上的一段边的移动,左旋即左结点向左离开12点方向
    // 红黑树的原型是2-3树，红色链接的两个点组成一个3结点，黑的单点则是2结点
    // 根据2-3的原理，红色连接的两个结点表示2-3树中的3结点，左为小于左结点，中为左右之间的值，右为大于右结点
    // 中结点在抽象图形表示中时，总是在低的结点的附近
    // 插入后结点都变为红色的原因是，红色的含义为连接
    // 红黑树的红链接平放后就是2-3树
    // 在2-3树的3结点加入新元素时会变成4结点表现在红黑树中就是连续两段红链接，在2结点中加入新元素会变成3结点，即一段红链接
    // 2-3树的4结点裂变在红黑树中变现为两段红链接的中点通过旋转到达12点方向，形成左右子树为红的状态，转黑
    
    private func rotateLeft(_ target: Node) -> Node {
        let upNode = target.right!
        target.right = upNode.left
        upNode.left = target
        
        upNode.color = target.color
        target.color = .red
        upNode.sum = target.sum
        target.sum = 1 + self.size(target.left) + self.size(target.right)
        return upNode
    }
    private  func rotateRight(_ target: Node) -> Node {
        let upNode = target.left!
        target.left = upNode.right
        upNode.right = target
        
        upNode.color = target.color
        target.color = .red
        upNode.sum = target.sum
        target.sum = 1 + self.size(target.left) + self.size(target.right)
        return target
    }
    
    private  func flipColor(_ target: Node) {
        target.color = .red
        target.left?.color = .black
        target.right?.color = .black
    }
    func isRed(_ node: Node?) -> Bool {
        return node?.color == .red
    }
    func size(_ node: Node?) -> Int {
        guard (node != nil) else {
            return 0
        }
        return node!.sum
    }
}
// MARK:  - Node
extension RedBlackBST{
    // 内置 形成命名空间 防止类名冲突
    enum RBNodeColor {
        case red
        case black
    }
    public class RBNode<Key: Comparable, T> {
        var key: Key
        var data: T
        var left,right: RBNode?
        var sum:Int = 0 // 这颗子树的结点总数
        /// 指连接到父结点的颜色
        var color: RBNodeColor = .black
        
        init(key:Key, data:T, sum:Int, color:RBNodeColor) {
            self.key = key
            self.data = data
            self.sum = sum
            self.color = color
        }
    }
}

// MARK: - BST general method
extension RedBlackBST {
    func get(_ key: Key) -> T? {
        return self.get(key, node: self.root)
    }
    private  func get(_ key:Key, node:Node?) -> T?{
        guard let _node = node else {
            return nil
        }
        if key < _node.key {
            return self.get(key, node: _node.left)
        }else if key > _node.key {
            return self.get(key, node: _node.right)
        }else{ return node?.data }
    }
}


// MARK: - shelve

extension RedBlackBST {
    
    enum RBBSTError: Error {
        case nullError
        case unknownError
        var localizedDescription: String {
            switch self {
            case .nullError:
                return "parameter is null!"
                
            case .unknownError:
                return "unknown error!"
            }
        }
    }
}
