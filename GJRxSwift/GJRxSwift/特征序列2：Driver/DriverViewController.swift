//
//  DriverViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class DriverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "特征序列2：Driver"
        view.backgroundColor = UIColor.white
        
        
        
        //Driver
        //只有满足如下特征才能使用Driver：1.不会产生error事件。2.一定在主线程监听。3.共享状态变化。
        //常用场景：1.使用CoreData模型驱动UI。2.使用一个UI元素来驱动另一个UI元素值。
        
        //样例大致的意思是根据一个输入框的关键字，来请求数据，然后将获取到的结果绑定到另一个 Label 和 TableView 中。
        /*
         let results = query.rx.text.asDriver()        // 将普通序列转换为 Driver
         .throttle(0.3, scheduler: MainScheduler.instance) //在主线程中操作，0.3秒内值若多次改变，取最后一次
         .flatMapLatest { query in //筛选出空值, 拍平序列
            fetchAutoCompleteItems(query) //向服务器请求一组结果
            .asDriver(onErrorJustReturn: [])  // 仅仅提供发生错误时的备选返回值
         }
         
         //将返回的结果绑定到显示结果数量的label上
         results.map { "\($0.count)" }
         .drive(resultCount.rx.text) // 这里使用 drive 而不是 bindTo
         .disposed(by: disposeBag)
         
         //将返回的结果绑定到tableView上
         results
        .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
            (_, result, cell) in
            cell.textLabel?.text = "\(result)"
         }.disposed(by: disposeBag)
         **/
        
        //首先使用asDriver将ControlPropety转换为Driver。接着我们可以用.asDriver(onErrorJustReturn:[])方法将任何Observable都转换为Driver。
        /*
         而 asDriver(onErrorJustReturn: []) 相当于以下代码：
         let safeSequence = xs
            .observeOn(MainScheduler.instance) // 主线程监听
            .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
            .share(replay: 1, scope: .whileConnected)// 共享状态变化
         return Driver(raw: safeSequence) // 封装
         **/
        
    }


}
