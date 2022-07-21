//
//  RxDataSourceViewController.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/4.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class SimpleRxDataSourceViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel = RxDataSourceViewModel()
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
        viewModel.fetchData()
    }
    
}

extension SimpleRxDataSourceViewController: UICollectionViewDelegateFlowLayout {
    
    ///collectionView相關初始化
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "BlackHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView")
        collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
        collectionView.register(RandomColorCollectionViewCell.self, forCellWithReuseIdentifier: RandomColorCollectionViewCell.forCellWithReuseIdentifier)
        collectionView.register(RandomStringCollectionViewCell.self, forCellWithReuseIdentifier: RandomStringCollectionViewCell.forCellWithReuseIdentifier)
        ///使用collectionView的rx拓展的話設定delegate要改成這樣，如果沒有用到delegate可以不用設定
        collectionView.rx.setDelegate(self)
            .disposed(by: bag)
        configureLayout()
    }
    
    ///配置collectionView外觀以及cell大小與距離
    private func configureLayout() {
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        let size = (UIScreen.main.bounds.width - 20 - 10 * 2) / 3 - 1
        collectionViewLayout.itemSize = CGSize(width: size, height: size)
    }
    
    private func bindViewModel() {
        ///與UICollectionViewDataSource的cellForItemAt有87%像一定要實作
        let dataSource = RxCollectionViewSectionedReloadDataSource<SimpleCustomSectionModel> { _, collectionView, indexPath, model in
            ///model型別為列舉SimpleCustomSectionModelType，做switch即可取得正確型別不用自己轉型，非常方便
            switch model {
            case .colorType(let value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomColorCollectionViewCell.forCellWithReuseIdentifier, for: indexPath) as! RandomColorCollectionViewCell
                cell.bind(model: value)
                return cell
            case .stringType(let value):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RandomStringCollectionViewCell.forCellWithReuseIdentifier, for: indexPath) as! RandomStringCollectionViewCell
                cell.bind(model: value)
                return cell
            }
        }
        ///配置header和footer與UICollectionViewDataSource的viewForSupplementaryElementOfKind一樣，不需要的話可以不用做
        dataSource.configureSupplementaryView = { sectionModel, collectionView, kind, indexPath in
            ///sectionModel.sectionModels[indexPath.section].header
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "BlackHeaderCollectionReusableView", for: indexPath) as! BlackHeaderCollectionReusableView
                header.bind(sectionNumber: indexPath.section)
                return header
            case UICollectionView.elementKindSectionFooter:
                let footer =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView", for: indexPath)
                return footer
            default:
                return UICollectionReusableView()
            }
        }
        viewModel.sectionModelsObservable
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    ///footer大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 44)
    }
    
    ///header大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 44)
    }
    
}
