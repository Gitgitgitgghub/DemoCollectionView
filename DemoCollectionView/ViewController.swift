
import UIKit



class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    
    enum CollectionViewSection :CaseIterable {
        case Square
        case Circle
    }
    
    ///資料源
    let sections: [CollectionViewSection] = [.Square, .Circle, .Circle]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "BlackHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "WhiteHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WhiteHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
        collectionView.register(UINib(nibName: "CircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CircleCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }


}

extension ViewController :UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// 指的是collectionView有幾個section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    /// 指的是每個section有幾個item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .Square:
            return 12
        case .Circle:
            return 12
        }
    }
    
    /// 指的是在某一個section的某一個item要回傳哪一種cell
    /// 有點像Android裡面onCreateViewHolder + onBindViewHolder的合體，差別在Cell實例化並非我們控制
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .Square:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as? SquareCollectionViewCell{
                return cell
            }
        case .Circle:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionViewCell", for: indexPath) as? CircleCollectionViewCell{
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    /// 指的是“整個”section在collectionView的距離
    /// 例如想要第一個item距離螢幕邊框５必須在這邊設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    ///item的大小
    ///這邊定義水平item數量
    ///Square：４
    ///Circle：３
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        switch section {
        case .Square:
            let size = (UIScreen.main.bounds.width - 15 * 2 - 5 * 3) / 4
            return CGSize(width: size, height: size)
        case .Circle:
            let size = (UIScreen.main.bounds.width - 15 * 2 - 5 * 2) / 3
            return CGSize(width: size, height: size)
        }
    }
    
    /// item“之間”的最小距離
    /// minimumLineSpacingForSectionAt
    /// 在collectionView滾動方向為垂直時，指的是上下兩個item“之間最小”的距離，反之亦然
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
        return CGSize.zero
    }
    
    ///與cellForItemAt很相似
    ///多提供了一個kind給你判斷是header或footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            switch indexPath.section % 2 {
            case 0:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView", for: indexPath) as! BlackHeaderCollectionReusableView
                header.bind(sectionNumber: indexPath.section)
                return header
            case 1:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WhiteHeaderCollectionReusableView", for: indexPath) as! WhiteHeaderCollectionReusableView
                header.bind(sectionNumber: indexPath.section)
                return header
            default:
                fatalError("見鬼了！")
            }
        }else {
            return UICollectionReusableView()
        }
    }
    
}

