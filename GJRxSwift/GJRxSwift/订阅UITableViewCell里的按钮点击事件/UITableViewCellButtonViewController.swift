//
//  UITableViewCellButtonViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UITableViewCellButtonViewController: UIViewController {
    
    var tableView:UITableView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "订阅UITableViewCell里的按钮点击事件"
        view.backgroundColor = UIColor.white
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(MyTableViewCell.self, forCellReuseIdentifier: "Cell")
        //单元格无法选中
        self.tableView.allowsSelection = false
        self.view.addSubview(self.tableView!)
        
        
        //初始化数据
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法",
        ])
        
        //设置单元格
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MyTableViewCell
            cell.textLabel?.text = "\(element)"
            
            //cell中按钮点击事件订阅
            cell.button.rx.tap.asDriver().drive(onNext: { [weak self] in
                self?.showAlert(title: "\(row)", message: element)
            }).disposed(by: cell.disposeBag)
            
            return cell
        }.disposed(by: disposeBag)
    }
    
    //显示弹出框信息
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        self.present(alert, animated: true)
    }


}
