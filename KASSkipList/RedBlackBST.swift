//
//  RedBlackBST.swift
//  KASSkipList
//
//  Created by Erwin on 2020/6/5.
//  Copyright © 2020 Kuratasx. All rights reserved.
//

import Cocoa



/// 红黑二叉查找树
///
/// 原型是2-3树，红色链接的两个点组成一个3结点，黑的单点则是2结点
///
/// 红链接均为左链接（没有该约束的红黑树的原型是2-3-4树）
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
            self.flipColors(_node)
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
    
    /// 将该树结点颜色取反
    /// - Parameter target: 树的根结点
    private func flipColors(_ target: Node) {
        
        target.color = !target.color
        if let left = target.left {
            left.color = !left.color
        }
        if let right = target.right {
            right.color = !right.color
        }
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
// MARK:  - remove
extension RedBlackBST{

    
    func deleteMin() {
        if !self.isRed(self.root?.left) && !self.isRed(self.root?.right){
            root?.color = .red
        }
        self.root = self.deleteMin(self.root)
        if !self.isEmpty() {
            self.root?.color = .black
        }
    }
    
    private func deleteMin(_ node: Node?) -> Node?{
        print("deleteMin")
        print(middleTraversal(node))

        guard var _node = node else {
            return nil
        }
        if _node.left == nil {
            return nil
        }
        if !self.isRed(_node.left) && !self.isRed(_node.left?.left) {
            _node = moveRedLeft(_node)
        }
        _node.left = deleteMin(_node.left)
        print("deleteMin _node")
        print(middleTraversal(_node))
        print("deleteMin end \n")
        return balance(_node)
    }
    
    private func moveRedLeft(_ node: Node) -> Node {
        var _node = node
        
        self.flipColors(_node)
        if self.isRed(_node.right?.left){
            _node.right = rotateRight(_node.right!)
            _node = rotateLeft(_node)
        }
        return _node
    }
    
    private func balance(_ node: Node) ->Node{
        var _node = node
        if self.isRed(_node.right) {
            _node = self.rotateLeft(_node)
        }
        if self.isRed(_node.left) && self.isRed(_node.left?.left) {
            _node = rotateRight(_node)
        }
        if self.isRed(_node.left) && self.isRed(_node.right){
            self.flipColors(_node)
        }
        _node.sum = self.size(_node.left) + self.size(_node.right) + 1
        return _node
    }
    
    
    //    func delete(key: Key) {
    //        if !self.isRed(root?.left) && !self.isRed(root?.right){
    //            self.root?.color = .red
    //        }
    //        root = delete
    //    }
    //    private func delete(h: Node, key: Key) -> Node{
    //
    //    }
    
    public func isEmpty() -> Bool{
        return self.root == nil
    }
}


extension RedBlackBST: CustomStringConvertible {
    public var description: String {
        self.middleTraversal(self.root)
        return "-----"
    }
    
    private func middleTraversal(_ root: Node?){
        if root != nil {
            print(root!.key,"=",root!.data,root!.color,root?.left?.data, root?.right?.data)
            middleTraversal(root?.left)
            middleTraversal(root?.right)
        }
    }
    
    //    private func middleTraversal(_ root: Node?)->T?{
    //        var r:T? = nil
    //        if root != nil {
    //            _ = middleTraversal(root?.left)
    //            r = root?.data
    //            _ = middleTraversal(root?.right)
    //            return r
    //        }
    //        return r
    //    }
    
}
// MARK:  - Node
extension RedBlackBST{
    // 内置 形成命名空间 防止类名冲突
    enum RBNodeColor {
        case red
        case black
        // 重载前缀运算符
        static prefix func !( color: inout RBNodeColor) -> RBNodeColor{
            return color == .red ? .black : .red
        }
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
    // 搁置的bool枚举
    enum _RBNodeColor_: RawRepresentable {
        case red
        case black
        //        typealias RawValue = Bool
        var rawValue: Bool {
            return self == .red ? true : false
        }
        init?(rawValue: Bool) {
            self = rawValue == true ? .red : .black
        }
    }
}
