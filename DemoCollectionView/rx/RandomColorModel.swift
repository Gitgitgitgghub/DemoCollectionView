//
//  RandomColorModel.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/4.
//

import Foundation
import UIKit
import Differentiator
import RxSwift


class RandomColorModel {
    
    var color :UIColor
    let id :String
    
    init(color :UIColor) {
        self.color = color
        self.id = color.description
    }
    
    func changeColor() {
        color = UIColor().randomColor()
    }
    
}

extension UIColor {
    
    func randomColor() -> UIColor {
        let r = CGFloat.random(in: 0...255) / 255
        let g = CGFloat.random(in: 0...255) / 255
        let b = CGFloat.random(in: 0...255) / 255
        return UIColor(red: r , green: g, blue: b, alpha: 1)
    }
}
