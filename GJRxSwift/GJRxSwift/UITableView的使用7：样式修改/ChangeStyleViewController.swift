//
//  ChangeStyleViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

struct MySection_3 {
    var header: String
    var items: [Item]
}

extension MySection_3 : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection_3, items: [Item]) {
        self = original
        self.items = items
    }
}

class ChangeStyleViewController: UIViewController {
    
    var tableView:UITableView!
    var dataSource:RxTableViewSectionedReloadDataSource<MySection_3>?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UITableView的使用7：样式修改"
        view.backgroundColor = UIColor.white
        
        
        
        tableView = UITableView(frame: self.view.frame, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        //初始化数据
        let sections = Observable.just([
            MySection_3(header:"基本控件", items:[
                "uilabel",
                "uitext",
                "uibutton"
            ]),
            MySection_3(header: "高级控件", items:[
                "tablkeView",
                "scrollview"
            ])
        ])
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection_3>(
            configureCell:{ ds, tableView, ip, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = "\(ip.row):\(item)"
                return cell
        },
            //设置头部
            titleForHeaderInSection: { ds, index in
                return ds.sectionModels[index].header
        }
        )
        
        self.dataSource = dataSource
        
        //绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        //设置代理
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }


}

extension ChangeStyleViewController : UITableViewDelegate {
    //修改单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = dataSource?[indexPath.row], let _ = dataSource?[indexPath.section] else {
            return 0.0
        }
        
        return 60
    }
    
    //设置头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        let titleLabel = UILabel()
        titleLabel.text = dataSource?[section].header
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x:view.frame.size.width/2, y:20)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    //设置头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
