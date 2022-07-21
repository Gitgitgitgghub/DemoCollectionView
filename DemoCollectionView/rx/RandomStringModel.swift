//
//  RandomStringModel.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/5.
//

import Foundation

class RandomStringModel {
    var value: String
    let id: String
    
    init() {
        value = String.random(of: 5)
        id = value
    }
}

extension String {
   static func random(of n: Int) -> String {
      let digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
      return String(Array(0..<n).map { _ in digits.randomElement()! })
   }
}
