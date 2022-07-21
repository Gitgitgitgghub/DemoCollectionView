//
//  RandomStringCollectionViewCell.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/5.
//

import Foundation
import UIKit

class RandomStringCollectionViewCell: UICollectionViewCell {
    
    static let forCellWithReuseIdentifier = "RandomStringCollectionViewCell"
    private var label :UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        contentView.backgroundColor = .gray
        label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = NSTextAlignment.center
        label.textColor = .black
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    func bind(model: RandomStringModel) {
        label.text = model.value
    }
}
