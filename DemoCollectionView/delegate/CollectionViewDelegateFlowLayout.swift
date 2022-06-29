//
//  CollectionViewDelegateFlowLayout.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/27.
//

import Foundation
import UIKit
import RxDataSources
import RxCocoa
import RxSwift

enum CollectionViewSection :CaseIterable {
    case Square
    case Circle
}

extension RxCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    /// 指的是“整個”section在collectionView的距離
    /// 例如左上方的item與header和collectionView左側的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    ///item的大小
    ///這邊定義水平item數量
    ///Square：４
    ///Circle：３
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.section < sections.value.count else { return CGSize.zero }
        let section = sections.value[indexPath.section]
        switch section {
        case .Square:
            let size = ((UIScreen.main.bounds.width - 15 * 2 - 5 * 3) / 4) - 1
            return CGSize(width: size, height: size)
        case .Circle:
            let size = ((UIScreen.main.bounds.width - 15 * 2 - 5 * 2) / 3) - 1
            return CGSize(width: size, height: size)
        }
    }
    
    /// item“之間”的最小距離
    /// minimumLineSpacingForSectionAt
    /// 在collectionView滾動方向為垂直時，指的是上下兩個item“之間最小”的距離，反之亦然，如果你的cell大小不夠是會大於這個距離的。
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /// item“之間”的最小距離
    /// minimumInteritemSpacingForSectionAt
    /// 在collectionView滾動方向為垂直時，指的是左右兩個item“之間最小”的距離，反之亦然
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    /// header大小
    /// 目前測試垂直滾動只有height會生效，水平滾動只有width生效
    /// 設定大小要滾動方向決定設定width或height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    
    ///footer大小
    ///用法跟referenceSizeForHeaderInSection一樣
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    
    
}
