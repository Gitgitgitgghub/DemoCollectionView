//
//  ViewController.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let sectionData :[Int] = [12]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "SectionOneCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SectionOneCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }


}

extension ViewController :UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// 指的是collectionView有幾個section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionData.count
    }
    
    /// 指的是每個section有幾個item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionData[section]
    }
    
    /// 指的是在某一個section的某一個item要回傳哪一種cell
    /// 有點像Android裡面onCreateViewHolder + onBindViewHolder的合體，差別在Cell實例化並非我們控制
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionOneCollectionViewCell", for: indexPath) as? SectionOneCollectionViewCell{
                return cell
            }
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    /// 指的是“整個”section在collectionView的距離
    /// 例如想要第一個item距離螢幕邊框５必須在這邊設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 103, height: 130)
        default:
            return CGSize.zero
        }
    }
    
    /// item“之間”的最小距離
    /// minimumLineSpacingForSectionAt
    /// 在collectionView滾動方向為垂直時，指的是上下兩個item“之間”的距離，反之亦然
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    /// item“之間”的最小距離
    /// minimumInteritemSpacingForSectionAt
    /// 在collectionView滾動方向為垂直時，指的是左右兩個item“之間”的距離，反之亦然
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    
}

