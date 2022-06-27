
import UIKit



class NormalCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    ///資料源
    let sections: [CollectionViewSection] = [.Square, .Circle, .Circle]
    lazy var collectionViewDelegateFlowLayout: CollectionViewDelegateFlowLayout = {
        let obj = CollectionViewDelegateFlowLayout()
        obj.sections = self.sections
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "BlackHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "WhiteHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WhiteHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
        collectionView.register(UINib(nibName: "CircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CircleCollectionViewCell")
        collectionView.delegate = collectionViewDelegateFlowLayout
        collectionView.dataSource = self
    }


}


extension NormalCollectionViewController :UICollectionViewDataSource {
    
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
    
    ///指的是在某一個section的某一個item要回傳哪一種cell ＋ 綁定資料給cell
    ///有點像Android裡面getItemType + onCreateViewHolder + onBindViewHolder全部一起做的感覺。
    ///要同時決定某section的某位置要用哪種cell，也必須同時在這邊做cell資料的綁定…
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        var cell: UICollectionViewCell? = nil
        switch section {
        case .Square:
            if indexPath.item == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionViewCell", for: indexPath) as? CircleCollectionViewCell
            }else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as? SquareCollectionViewCell
            }
        case .Circle:
            if indexPath.item == 0 {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath) as? SquareCollectionViewCell
            }else {
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionViewCell", for: indexPath) as? CircleCollectionViewCell
            }
        }
        return cell ?? UICollectionViewCell()
    }
    
    ///與cellForItemAt很相似
    ///多提供了一個kind給你判斷是header或footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        print("viewForSupplementaryElementOfKind: \(kind)")
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section % 2 == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView", for: indexPath) as! BlackHeaderCollectionReusableView
                header.bind(sectionNumber: indexPath.section)
                return header
            }else {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WhiteHeaderCollectionReusableView", for: indexPath) as! WhiteHeaderCollectionReusableView
                header.bind(sectionNumber: indexPath.section)
                return header
            }
        case UICollectionView.elementKindSectionFooter:
            let footer =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView", for: indexPath)
            return footer
        default:
            return UICollectionReusableView()
        }
    }
    
}

