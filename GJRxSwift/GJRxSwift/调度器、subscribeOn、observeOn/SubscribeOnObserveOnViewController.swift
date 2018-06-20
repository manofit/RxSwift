//
//  SubscribeOnObserveOnViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit

class SubscribeOnObserveOnViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "调度器、subscribeOn、observeOn"
        view.backgroundColor = UIColor.white
        
        
        //调度器是RxSwift实现多线程的核心模块，它主要控制任务在哪个线程或者队列运行。
        //RxSwift内置如下几种线程：
        /*
         1.CurrentThreadScheduler：表示当前线程 Scheduler。（默认使用这个）
         2.MainScheduler：表示主线程。如果我们需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler 运行。
         3.SerialDispatchQueueScheduler：封装了 GCD 的串行队列。如果我们需要执行一些串行任务，可以切换到这个 Scheduler 运行。
         4.ConcurrentDispatchQueueScheduler：封装了 GCD 的并行队列。如果我们需要执行一些并发任务，可以切换到这个 Scheduler 运行。
         5.OperationQueueScheduler：封装了 NSOperationQueue。
         **/
        
        //以一个在后台进行网络请求，然后主线程更换UI的例子：
        /*
         let rxData = Observable<Data> = ...
         
         rxData.subscribOn(ConcurrentDispatchQueueScheduler(qos: .userInitialted)) //后台构建序列
         .observeOn(MainScheduler.instance) //主线程监听并处理序列结果
         .subscribe(onNext: {[weak self] data in
                self?.data = data
         }).dispose(by: DisposeBag())
         **/
        
        //subscribeOn与observeOn的区别：
        //subscribeOn():该方法决定数据序列的构建函数在哪个scheduler上运行。比如上面样例，由于获取数据、解析数据需要花费一段时间的时间，所以通过 subscribeOn 将其切换到后台 Scheduler 来执行。这样可以避免主线程被阻塞。
        //observeOn():该方法决定在哪个scheduler上监听这个数据序列。比如上面样例，我们获取并解析完毕数据后又通过 observeOn 方法切换到主线程来监听并且处理结果。
    }


}
