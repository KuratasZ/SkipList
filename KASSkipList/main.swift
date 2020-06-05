//
//  main.swift
//  KASSkipList
//
//  Created by zhangwei on 2020/6/3.
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

// SkipList is ready for Swift 4.
// TODO: Add Test

let k = SkipList<Int, String>()



k.remove(key: 10)

for i in 1...13{
    k.insert(key: i, data: "\(i)")
}
k.remove(key: 12)

print(k)

if let value = k.get(key: 12,show: true) {
  print(value)
} else {
  print("not found!")
}

print(MemoryLayout<SkipList<Int,String>>.size)
print(MemoryLayout.size(ofValue: k))
