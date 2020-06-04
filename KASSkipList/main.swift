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
k.insert(key: 10, data: "10")
k.insert(key: 12, data: "12")
k.insert(key: 13, data: "13")
k.insert(key: 20, data: "20")
k.insert(key: 24, data: "24")


k.remove(key: 10)
k.remove(key: 12)

print(k)

if let value = k.get(key: 24) {
  print(value)
} else {
  print("not found!")
}

