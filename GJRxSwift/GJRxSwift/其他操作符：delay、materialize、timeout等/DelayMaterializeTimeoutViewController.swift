//
//  DelayMaterializeTimeoutViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/13.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DelayMaterializeTimeoutViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "其他操作符：delay、materialize、timeout等"
        view.backgroundColor = UIColor.white
        
        
        //delay
        //将Observable的所有元素都先延迟一段设定好的时间，然后将它们发送出去，是延迟发送
        Observable.of(1,2,3).delay(3, scheduler: MainScheduler.instance).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //delaySubscription
        //延迟订阅
        Observable.of(4,5,6).delaySubscription(3, scheduler: MainScheduler.instance).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //materialize
        //将序列产生的事件转换成元素发送出来
        Observable.of(7,8,9).materialize().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //dematerialize
        //将materialize转换后元素还原成一个Observable
        Observable.of(1,2,1).materialize().dematerialize().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //timeout
        //设置一个超时时间，在规定的时间内没有事件发出就会产生一个error事件。
        let times = [
            [ "value": 1, "time": 0 ],
            [ "value": 2, "time": 0.5 ],
            [ "value": 3, "time": 1.5 ],
            [ "value": 4, "time": 4 ],
            [ "value": 5, "time": 5 ]
        ]
        
        Observable.from(times).flatMap { item in
            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!),
                                       scheduler: MainScheduler.instance)
        }.timeout(2, scheduler: MainScheduler.instance) //超过两秒没发出元素，则产生error事件
            .subscribe(onNext: { element in
            print(element)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)

    }


}
