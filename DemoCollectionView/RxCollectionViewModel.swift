//
//  RxCollectionViewModel.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/6/27.
//

import Foundation
import RxSwift
import RxDataSources
import RxRelay

class RxCollectionViewModel {
    
    private var dataRelay = PublishRelay<SectionModel<CollectionViewSection,Any>>()
    lazy var dataSource: Observable<SectionModel<CollectionViewSection,Any>> = dataRelay.asObservable()
    
    func fetchData(numberOfSections: Int) {
        
    }
}
