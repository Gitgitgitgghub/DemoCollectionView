//
//  RxDataSourceViewModel.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/4.
//

import Foundation
import RxRelay
import RxDataSources


class RxDataSourceViewModel {
    
    private let sectionModels = BehaviorRelay<SimpleCustomSectionModels>(value: [])
    ///暴露給viewControll的sections資料
    lazy var sectionModelsObservable = self.sectionModels.asObservable().share()
    
    ///創造資料源
    func fetchData() {
        var temp: SimpleCustomSectionModels = []
        for i in 0...5 {
            var items = [SimpleCustomSectionModelType]()
            for _ in 0...6 {
                if i % 2 == 0 {
                    items.append(SimpleCustomSectionModelType.colorType(RandomColorModel(color: UIColor().randomColor())))
                }else {
                    items.append(SimpleCustomSectionModelType.stringType(RandomStringModel()))
                }
            }
            temp.append(SimpleCustomSectionModel(header: "第\(i + 1)個header", footer: "第\(i + 1)個footer", items: items))
        }
        sectionModels.accept(temp)
    }
    
//    func changeColor(by indexPath: IndexPath) {
//        var value = sectionModels.value
//        let sectionModel = value[indexPath.section]
//        var item = sectionModel.items[indexPath.item]
//        var newItems = sectionModel.items
//        item.changeColor()
//        newItems[indexPath.item] = item
//        value[indexPath.section] = SimpleCustomSectionModel(header: sectionModel.header, footer: sectionModel.footer, items: newItems)
//        sectionModels.accept(value)
//    }
}
