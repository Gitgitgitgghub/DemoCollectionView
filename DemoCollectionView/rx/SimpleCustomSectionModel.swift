//
//  SimpleCustomSectionModel.swift
//  DemoCollectionView
//
//  Created by 吳俊諺 on 2022/7/5.
//

import Foundation
import RxDataSources

///不管多少個sectionModel最終都要返回一個陣列，寫這個只是方便閱讀而已
typealias SimpleCustomSectionModels = [SimpleCustomSectionModel]

///定義SimpleCustomSectionModel裏面Item的型別
///用enum做是因為可以直接對Item做swich省去轉型的麻煩
enum SimpleCustomSectionModelType {
    case colorType(RandomColorModel)
    case stringType(RandomStringModel)
}

struct SimpleCustomSectionModel {
    var header: String
    var footer: String
    var items:[Item]
}

///拓展SimpleCustomSectionModel
///定義Item型別為enum SimpleCustomSectionModelType
extension SimpleCustomSectionModel: SectionModelType {
    typealias Item = SimpleCustomSectionModelType
    typealias Identity = String
    var identity: String {
        return header
    }
    ///實作 protocol SectionModelType的init方法
    init(original: SimpleCustomSectionModel, items: [SimpleCustomSectionModelType]) {
        self = original
        self.items = items
    }
}
