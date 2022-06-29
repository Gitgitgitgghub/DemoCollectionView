//
//  CellDataProtocol.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/29.
//

import Foundation
import UIKit

protocol CellDataProtocol: NSObject {
    var cellData: AnyObject? { get set }
}

extension CellDataProtocol where Self: UICollectionViewCell {
    
}
