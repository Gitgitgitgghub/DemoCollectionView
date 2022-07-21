//
//  SectionOneCollectionViewCell.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/16.
//

import UIKit

class SquareCollectionViewCell: UICollectionViewCell {
    
    var cellData: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 5
    }

}

struct SquareCellModel {
    
    let shape = "Square"
    
}
