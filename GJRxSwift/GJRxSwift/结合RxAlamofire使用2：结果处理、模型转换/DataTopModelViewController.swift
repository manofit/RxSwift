//
//  DataTopModelViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import RxAlamofire

//豆瓣接口模型
class Douban: Mappable {
    //频道列表
    var channels: [Channel]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        channels <- map["channels"]
    }
}

//频道模型
class Channel: Mappable {
    var name: String?
    var nameEn:String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?
    
    init() {
    
    }
    
    required init?(map:Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}

class DataTopModelViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "将结果转换成自定义对象"
        view.backgroundColor = UIColor.white
        
        
        //创建URL对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //创建并发起请求
        requestJSON(.get, url).map{$1}.mapObject(type: Douban.self).subscribe(onNext: {(douban:Douban) in
            if let channels = douban.channels {
                print("共有\(channels.count)个频道")
                for channel in channels {
                    if let name = channel.name, let channelId = channel.channelId {
                        print("\(name) (id:\(channelId))")
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        
        //创建表格视图
        self.tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        
        //获取列表数据
        let data = requestJSON(.get, url).map{$1}.mapObject(type: Douban.self).map{$0.channels ?? []}
        
        //将数据绑定到表格
        data.bind(to: tableView.rx.items) {tb, row, element in
            let cell = tb.dequeueReusableCell(withIdentifier: "cell")!
            cell.textLabel?.text  = "\(row):\(element.name!)"
            return cell
        }.disposed(by: disposeBag)
    }


}
