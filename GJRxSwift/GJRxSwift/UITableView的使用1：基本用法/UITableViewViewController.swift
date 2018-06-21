//
//  UITableViewViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UITableViewViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UITableView的使用1：基本用法"
        view.backgroundColor = UIColor.white
        
        
        tableView = UITableView(frame:view.frame, style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        view.addSubview(tableView)
        
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法",
            ])
        
        //设置单元格数据，其实就是封装了cellForRowAt
        items.bind(to: tableView.rx.items) {(tableView, row, element) in
            let cell  = tableView.dequeueReusableCell(withIdentifier: "cellid")
            cell?.textLabel?.text = "\(row):\(element)"
            return cell!
        }.disposed(by: disposeBag)
        
        //单元格选中事件响应
        //获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: {indexPath in
            print("选中项索引为：\(indexPath)")
        }).disposed(by: disposeBag)
        //获取选中项的内容
        tableView.rx.modelSelected(String.self).subscribe(onNext: {item in
            print("选中项为：\(item)")
        }).disposed(by: disposeBag)
        //同时获取选中项的索引和内容
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)).subscribe(onNext: {indexPath, item in
            print("选中项索引为：\(indexPath)")
            print("选中项内容是：\(item)")
        }).disposed(by: disposeBag)
        
        //单元格取消选中事件响应
        Observable.zip(tableView.rx.itemDeselected, tableView.rx.modelDeselected(String.self)).subscribe(onNext: {indexPath, item in
            print("取消选中项索引为：\(indexPath)")
            print("取消选中项内容是：\(item)")
        }).disposed(by: disposeBag)
        
        //单元格删除事件响应
        Observable.zip(tableView.rx.itemDeleted, tableView.rx.modelDeleted(String.self)).subscribe(onNext: {indexPath, item in
            print("删除项索引为：\(indexPath)")
            print("删除项内容是：\(item)")
        }).disposed(by: disposeBag)
        
        //单元格移动事件
        tableView.rx.itemMoved.subscribe(onNext: {sourceIndexPath, destinationIndexPath in
            print("移动箱原来位置：\(sourceIndexPath)")
            print("移动箱目标位置：\(destinationIndexPath)")
        }).disposed(by: disposeBag)
        
        //单元格插入事件
        tableView.rx.itemInserted.subscribe(onNext: {indexPath in
            print("插入的位置为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //单元格尾部图标点击事件响应
        tableView.rx.itemAccessoryButtonTapped.subscribe(onNext: {indexPath in
            print("点击的尾部位置为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        //单元格将要显示出来的事件响应
        tableView.rx.willDisplayCell.subscribe(onNext: {cell, indexPath in
            print("将要显示单元格indexPath为：\(indexPath)")
            print("将要显示单元格cell为：\(cell)\n")
        }).disposed(by: disposeBag)
        
    }


}
