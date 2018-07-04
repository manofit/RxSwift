//
//  DifferentKindCellViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

//单元格类型
enum SectionItem {
    case TitleImageSectionItem(title:String, image:UIImage)
    case TitleSwitchSectionItem(title:String, enabled:Bool)
}

//自定义section
struct MySection_2 {
    var header: String
    var items: [SectionItem]
}

extension MySection_2 : SectionModelType {
    typealias Item = SectionItem
    
    init(original: MySection_2, items: [Item]) {
        self = original
        self.items = items
    }
}

class DifferentKindCellViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UITableView的使用6：不同类型的单元格混用"
        view.backgroundColor = UIColor.white
        
        
        //初始化数据
        let sections = Observable.just([
            MySection_2(header: "我是第一个分区", items: [
                .TitleImageSectionItem(title: "图片数据1", image: UIImage(named: "php")!),
                .TitleImageSectionItem(title: "图片数据2", image: UIImage(named: "react")!),
                .TitleSwitchSectionItem(title: "开关数据1", enabled: true)
            ]),
            MySection_2(header: "我是第二个分区", items: [
                .TitleSwitchSectionItem(title: "开关数据2", enabled: false),
                .TitleSwitchSectionItem(title: "开关数据3", enabled: false),
                .TitleImageSectionItem(title: "图片数据3", image: UIImage(named: "swift")!)
            ])
        ])
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection_2>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath] {
                case let .TitleImageSectionItem(title, image):
                    let  cell = tableView.dequeueReusableCell(withIdentifier: "titleImageCell", for: indexPath)
                    (cell.viewWithTag(1) as! UILabel).text = title
                    (cell.viewWithTag(2) as! UIImageView).image = image
                    return cell
                case let .TitleSwitchSectionItem(title, enabled):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "titleSwitchCell",
                                                             for: indexPath)
                    (cell.viewWithTag(1) as! UILabel).text = title
                    (cell.viewWithTag(2) as! UISwitch).isOn = enabled
                    return cell
                }
        },
            //设置头部标题
        titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
        )
        
        //绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }


}
