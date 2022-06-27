//
//  CircleCollectionViewCell.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/24.
//

import UIKit

class CircleCollectionViewCell: SquareCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.size.width * 0.5
    }

}
