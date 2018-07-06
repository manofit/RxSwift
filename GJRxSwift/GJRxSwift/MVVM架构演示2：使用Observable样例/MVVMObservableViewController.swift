//
//  MVVMObservableViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/5.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MVVMObservableViewController: UIViewController {
    
    var tableView:UITableView!
    
    var searchBar:UISearchBar!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "MVVM架构演示2：使用Observable样例"
        view.backgroundColor = UIColor.white
        
        
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.view.addSubview(self.tableView!)
        
        //创建表头的搜索栏
        self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
                                                   width: self.view.bounds.size.width, height: 56))
        self.tableView.tableHeaderView =  self.searchBar
        
        
        //查询条件输入
        let searchAction = searchBar.rx.text.orEmpty.throttle(0.5, scheduler: MainScheduler.instance) //只有超过0.5s才会发送
        .distinctUntilChanged().asObservable()
        
        //初始化viewmodel
        let viewModel = ViewModel(searchAction:searchAction)
        
        //绑定导航栏标题数据
        viewModel.navigationTitle.bind(to: self.navigationItem.rx.title).disposed(by: disposeBag)
        
        //将数据绑定到表格
        viewModel.repositories.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.htmlUrl
            return cell
        }.disposed(by: disposeBag)
        
        //单元格点击
        tableView.rx.modelSelected(GitHubRepository.self).subscribe(onNext: {[weak self] item in
            self?.showAlert(title: item.fullName, message: item.description)
        }).disposed(by: disposeBag)
        
    }
    
    //显示消息
    func showAlert(title:String, message:String){
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }


}
