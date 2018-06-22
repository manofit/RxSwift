//
//  RxDataSourcesViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/22.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

//自定义section
struct MySection {
    var header:String
    var items:[Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original:MySection, items:[Item]) {
        self = original
        self.items = items
    }
}

class RxDataSourcesViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UITableView的使用2：RxDataSources"
        view.backgroundColor = UIColor.white
        
        
        //单分区tabelView
        tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        view.addSubview(tableView)
        
        //方法一：自带的section
        //初始化数据
        let items = Observable.just([
            SectionModel(model:"", items:[
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
            ])
        ])
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: { (dataSource, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            cell?.textLabel?.text = "\(indexPath.row):\(element)"
            return cell!
        })
        //绑定单元格数据
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //方法二：自定义的section
        let sections = Observable.just([
            MySection(header:"", items:[
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
            ])
        ])
        
        let dataSource_2 = RxTableViewSectionedReloadDataSource<MySection>(configureCell: {(dataSource, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            cell?.textLabel?.text = "\(indexPath.row):\(element)"
            return cell!
        })
        
        sections.bind(to: tableView.rx.items(dataSource: dataSource_2)).disposed(by: disposeBag)
        
        
        
        
        //多分区tableView
        //方法一：自带的section
        let items_3 = Observable.just([
            SectionModel(model:"基本控件", items:[
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
            ]),
            SectionModel(model:"高级控件", items:[
                "UITableView的用法",
                "UICollectionViews的用法"
            ])
        ])
        
        let dataSource_3 = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: {
            (dataSource, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            cell?.textLabel?.text = "\(indexPath.row):\(element)"
            return cell!
        })
        
        //设置分头标题
        dataSource_3.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        items_3.bind(to: tableView.rx.items(dataSource: dataSource_3)).disposed(by: disposeBag)
        

    }
    
}
