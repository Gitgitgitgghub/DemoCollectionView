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

class RxCollectionViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var randomSectionBtn: UIButton!
    var isSingleSection = false
    var bag = DisposeBag()
    ///資料源
    let sections = BehaviorRelay<[CollectionViewSection]>(value: [.Square, .Circle, .Circle, .Square, .Square, .Circle])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindData()
        bindClickAction()
        randomSectionBtn.isHidden = isSingleSection
        randomSectionBtn.addTarget(self, action: #selector(randomSection), for: .touchUpInside)
    }

    @objc private func randomSection() {
        let newSections = sections.value.shuffled()
        sections.accept(newSections)
    }
}

//MARK: - collectionView
extension RxCollectionViewController {
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "BlackHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "WhiteHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WhiteHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
        collectionView.register(UINib(nibName: "SquareCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SquareCollectionViewCell")
        collectionView.register(UINib(nibName: "CircleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CircleCollectionViewCell")
        ///使用RX綁定delegate方式與原來的不同
        collectionView.rx.setDelegate(self)
            .disposed(by: bag)
    }
    
    private func bindData() {
        _ = isSingleSection ? bindSingleSectionData() : bindSectionModel()
    }
    
    ///響應collectionView被選中事件
    ///collectionView.rx.itemSelected會給你indexPath
    ///collectionView.rx.modelSelected會給你選中cell對應的model
    ///想要兩者都知道可以自己zip
    ///這邊是透過indexPath取得對應cell裡面的資料
    private func bindClickAction() {
        collectionView.rx.itemSelected
            .map({ indexPath in
                return self.collectionView.cellForItem(at: indexPath)
            })
            .subscribe { cell in
                guard let cell = cell.element as? CellDataProtocol else { return }
                switch cell.cellData {
                case is CircleCellModel:
                    print("itemSelected cellData: \(String(describing: cell.cellData as? CircleCellModel))")
                case is SquareCellModel:
                    print("itemSelected cellData: \(String(describing: cell.cellData as? SquareCellModel))")
                default:
                    print("itemSelected cellData: default")
                }
                
            }
            .disposed(by: bag)
    }
    
}

//MARK: - 單一section
extension RxCollectionViewController {
    
    var data: BehaviorRelay<[Int]> {
        get{
            let count = Int.random(in: 4...12)
            return BehaviorRelay(value: Array.init(repeating: 0, count: count))
        }
    }
    
    ///多種cell type可以用這個
    ///相當於配置UICollectionViewDataSource的cellForRowAt
    private func bindSingleSectionData() {
        data.bind(to: collectionView.rx.items){ collectionView, row ,element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: IndexPath(row: row, section: 0))
            if cell is CellDataProtocol {
                switch self.sections.value[0] {
                case .Square:
                    (cell as! CellDataProtocol).cellData = SquareCellModel() as AnyObject
                case .Circle:
                    (cell as! CellDataProtocol).cellData = CircleCellModel() as AnyObject
                }
                
            }
            return cell
        }
        .disposed(by: bag)
    }
    
    ///單一cell type也可以用這個
    ///相當於配置UICollectionViewDataSource的cellForRowAt
    private func bindSingleSectionDataSingleCellType() {
        data.bind(to: collectionView.rx.items(cellIdentifier: "SquareCollectionViewCell", cellType: SquareCollectionViewCell.self)){ row ,element, cell in
            
        }
        .disposed(by: bag)
    }
}

//MARK: - 用RxCollectionViewSectionedReloadDataSource綁定
extension RxCollectionViewController {
    
    ///SectionModel<T1,T2>比較難懂的地方
    ///T1指的是用來識別section的型別可以是任何你自訂的，現在例子是用自訂的CollectionViewSection
    ///T2指的是資料型別
    ///一個SectionModel代表一個section的資料，最終就是返回[SectionModel<T1,T2>]
    private var sectionModels: Observable<[SectionModel<CollectionViewSection,AnyObject>]> {
        get{
            ///跟sections做連動
            return sections.flatMap {
                Observable.just(
                    ///把CollectionViewSection陣列轉化為SectionModel
                    $0.map { section in
                        var item :AnyObject!
                        let count = Int.random(in: 4...12)
                        switch section {
                        case .Square:
                            item = SquareCellModel() as AnyObject
                        case .Circle:
                            item = CircleCellModel() as AnyObject
                        }
                        return SectionModel<CollectionViewSection,AnyObject>(model: section, items: Array.init(repeating: item, count: count))
                    })
            }
        }
    }
    
    private func bindSectionModel() {
        ///sectionModels轉換為RxCollectionViewSectionedReloadDataSource<T>才能實作UICollectionViewDataSource
        ///T是sectionModel的型別“注意不是陣列”
        ///init 最少要實作 configureCell
        ///相當於配置UICollectionViewDataSource的cellForRowAt
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<CollectionViewSection,AnyObject>> { dataSource, collectionView, indexPath, item in
            let sectionModel = dataSource.sectionModels[indexPath.section]
            let cell = self.configureCell(collectionView: collectionView, sectionModel: sectionModel, indexPath: indexPath)
            return cell
        }
        ///相當於配置UICollectionViewDataSource的viewForSupplementaryElementOfKind
        dataSource.configureSupplementaryView = { _, collectionView, kind, indexPath in
            self.configureSupplementaryView(collectionView: collectionView, kind: kind, indexPath: indexPath)
        }
        ///sectionModels與collectionView.rx.items綁定
        sectionModels.bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    ///配置cell的資料
    private func configureCell(collectionView: UICollectionView, sectionModel: SectionModel<CollectionViewSection, AnyObject>, indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        switch sectionModel.identity {
        case .Square:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SquareCollectionViewCell", for: indexPath)
        case .Circle:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleCollectionViewCell", for: indexPath)
        }
        if cell is CellDataProtocol {
            (cell as! CellDataProtocol).cellData = sectionModel.items[indexPath.row]
        }
        return cell ?? UICollectionViewCell()
    }
    
    ///配置header和footer
    private func configureSupplementaryView(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
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
