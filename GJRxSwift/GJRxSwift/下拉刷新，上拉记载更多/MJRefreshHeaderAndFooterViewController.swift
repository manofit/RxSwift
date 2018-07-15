//
//  MJRefreshHeaderAndFooterViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

class MJRefreshHeaderAndFooterViewController: UIViewController {
    
    //表格
    var tableView:UITableView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "下拉刷新，上拉记载更多"
        view.backgroundColor = UIColor.white
        
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                 forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //设置头部刷新控件
        self.tableView.mj_header = MJRefreshNormalHeader()
        //设置尾部刷新控件
        self.tableView.mj_footer = MJRefreshBackNormalFooter()
        
        //初始化ViewModel
        let viewModel = MJRefreshHeaderAndFooterViewModel.init(input: (headerRefresh:self.tableView.mj_header.rx.refreshing.asObservable(), footerRefresh: self.tableView.mj_footer.rx.refreshing.asObservable()), dependency: (disposeBag: self.disposeBag, networkService: MJRefreshHeaderAndFooterNetworkService()))
        
        //单元格数据的绑定
        viewModel.tableData.bind(to: tableView.rx.items) {(tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            cell?.textLabel?.text = "\(row+1),\(element)"
            return cell!
        }.disposed(by: disposeBag)
        
        //下拉刷新状态结束的绑定
        viewModel.endHeaderRefreshing.bind(to: self.tableView.mj_header.rx.endRefreshing).disposed(by: disposeBag)
        
        //上拉刷新状态结束的绑定
        viewModel.endFooterRefreshing.bind(to: self
        .tableView.mj_footer.rx.endRefreshing).disposed(by: disposeBag)
    }


}
