//
//  RandomColorCollectionViewCell.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/4.
//

import UIKit

class RandomColorCollectionViewCell: UICollectionViewCell {
    
    static let forCellWithReuseIdentifier = "RandomColorCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(model: RandomColorModel) {
        contentView.backgroundColor = model.color
    }
}
