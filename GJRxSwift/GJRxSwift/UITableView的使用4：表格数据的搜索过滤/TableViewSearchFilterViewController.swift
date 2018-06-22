//
//  TableViewSearchFilterViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/22.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class TableViewSearchFilterViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var tableView:UITableView!
    var searchBar:UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UITableView的使用4：表格数据的搜索过滤"
        view.backgroundColor = UIColor.white
        
        
        //开始刷新按钮
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.frame = CGRect(x:10, y:84, width:30, height:20)
        refreshBtn.setTitle("刷新", for: .normal)
        view.addSubview(refreshBtn)
        //停止刷新按钮
        let stopRefreshBtn = UIButton(type: .custom)
        stopRefreshBtn.frame = CGRect(x:60, y:84, width:30, height:20)
        stopRefreshBtn.setTitle("停止", for: .normal)
        view.addSubview(stopRefreshBtn)
        //表格
        tableView = UITableView(frame: CGRect(x:10, y:114, width:200, height:300), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        view.addSubview(tableView)
        //搜索栏
        searchBar = UISearchBar(frame:CGRect(x:0, y:0, width:200, height:56))
        tableView.tableHeaderView = searchBar
        
        //随机的表格数据
        let randomResult = refreshBtn.rx.tap.asObservable().startWith(()) //加了这个为了让一开始就能自动请求一次
            .flatMapLatest{self.getRandomResult().takeUntil(stopRefreshBtn.rx.tap)}//连续请求时只取最后一次数据
            .flatMap(filterResult) //筛选数据
            .share(replay:1)
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: {
            (dataSource, tableView, indexPath, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")
            cell?.textLabel?.text = "条目\(indexPath.row)：\(element)"
            return cell!
        })
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据")
        
        let items = (0..<5).map { _ in
            Int(arc4random())
        }
        
        let obserable = Observable.just([SectionModel(model:"S", items:items)])
        
        return obserable.delay(2, scheduler: MainScheduler.instance)
    }
    
    func filterResult(data:[SectionModel<String,Int>]) -> Observable<[SectionModel<String,Int>]> {
        return searchBar.rx.text.orEmpty.flatMapLatest {
            query -> Observable<[SectionModel<String, Int>]> in
            print("正在筛选数据（条件为：\(query)）")
            //输入条件为空，则直接返回原始数据
            if query.isEmpty{
                return Observable.just(data)
            }
            //输入条件为不空，则只返回包含有该文字的数据
            else{
                var newData:[SectionModel<String, Int>] = []
                for sectionModel in data {
                    let items = sectionModel.items.filter{ "\($0)".contains(query) }
                    newData.append(SectionModel(model: sectionModel.model, items: items))
                }
                return Observable.just(newData)
            }
        }
    }


}
