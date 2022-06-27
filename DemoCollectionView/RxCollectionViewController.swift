//
//  RxCollectionViewController.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/27.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var isSingleSection = false
    var bag = DisposeBag()
    var collectionViewDelegateFlowLayout = CollectionViewDelegateFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindData()
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "BlackHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "WhiteHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WhiteHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
        collectionView.register(UINib(nibName: "CircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CircleCollectionViewCell")
        ///使用RX綁定delegate方式與原來的不同
        collectionView.rx.setDelegate(collectionViewDelegateFlowLayout)
            .disposed(by: bag)
    }
    
    private func bindData() {
        _ = isSingleSection ? bindSingleSectionData() : bindSectionData()
    }
    

}

//MARK: - 單一section
extension RxCollectionViewController {
    
    var data: BehaviorRelay<[Int]> {
        get{
            return BehaviorRelay(value: Array.init(repeating: 0, count: 12))
        }
    }
    
    private func bindSingleSectionData() {
        data.bind(to: collectionView.rx.items){ collectionView, row ,element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: IndexPath(row: row, section: 0)) as! SquareCollectionViewCell
            return cell
        }
        .disposed(by: bag)
    }
}

//MARK: - 多section
extension RxCollectionViewController {
    
    private func bindSectionData() {
        let sectionModels = prepareSectionModels()
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<CollectionViewSection,Any>> { dataSource, collectionView, indexPath, item in
            let section = dataSource.sectionModels[indexPath.section].model
            switch section {
            case .Square:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath)
            case .Circle:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionViewCell", for: indexPath)
            }
        }
        dataSource.configureSupplementaryView = { _, collectionView, kind, indexPath in
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
        collectionViewDelegateFlowLayout.rxDataSource = dataSource
        sectionModels.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func prepareSectionModels() -> Observable<[SectionModel<CollectionViewSection,Any>]>{
        let sectionModel = SectionModel<CollectionViewSection,Any>(model: .Square, items: Array.init(repeating: true, count: 10))
        return Observable.just(Array.init(repeating: sectionModel, count: 5))
    }
}
