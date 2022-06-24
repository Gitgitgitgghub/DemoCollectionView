//
//  HeaderCollectionReusableView.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/24.
//

import UIKit

class BlackHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var sectionLabel :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(sectionNumber: Int) {
        sectionLabel.text = "第\(sectionNumber + 1)組Section"
    }
    
}
