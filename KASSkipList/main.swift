//
//  main.swift
//  KASSkipList
//
//  Created by Erwin on 2020/6/3.
//  Copyright © 2020 Kuratasx. All rights reserved.
//

import Foundation


var link = LinkList<Int>()

for index in 1...5 {
    
    link.addAtHead(val: index)
}

for (i,test) in link.enumerated() {
    print(i,test.data)
}



#if swift(>=5.0)
print("Hello, Swift 5!")
#endif


//#warning("t")
let k = SkipList<Int, String>()



k.remove(key: 10)

for i in 1...10{
    k.insert(key: i, data: "\(i)")
}
k.remove(key: 12)

//print(k)

if let value = k.get(key: 12,show: true) {
  print(value)
} else {
  print("not found!")
}

print(MemoryLayout<SkipList<Int,String>>.size)
print(MemoryLayout.size(ofValue: k))


debugPrint("new line -----------------")
let rBT = RedBlackBST<String,Int>()


for i in 1...10{
    rBT.put(key: "\(i)", data: i)
}

print(rBT.get("6")!)
