//
//  RxAlamofireResultHandleViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class RxAlamofireResultHandleViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "结合RxAlamofire使用2：结果处理、模型转换"
        view.backgroundColor = UIColor.white
        
        
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //使用内置JSONSerilization将结果转为JSON对象
        request(.get, url).data().subscribe(onNext: {
            data in
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
            print(json!)
        }).disposed(by: disposeBag)
        
        //在订阅前使用responseJSON()转换
        request(.get, url).responseJSON().subscribe(onNext:{
            dataResponse in
            let json = dataResponse.value as! [String:Any]
            print(json)
        }).disposed(by:  disposeBag)
        
        //最简单的使用requestJSON方法获取json数据
        requestJSON(.get, url).subscribe(onNext: {
            response, data in
            let json = data as! [String:Any]
            print(json)
        }).disposed(by: disposeBag)
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        
        let data = requestJSON(.get, url).map {response, data -> [[String:Any]] in
            if let json = data as? [String:Any], let channels = json["channels"] as? [[String:Any]] {
                return channels
            }else{
                return []
            }
        }
        
        data.bind(to: tableView.rx.items) {tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(row):\(element["name"]!)"
            return cell!
        }.disposed(by: disposeBag)
        
        
    }


}
