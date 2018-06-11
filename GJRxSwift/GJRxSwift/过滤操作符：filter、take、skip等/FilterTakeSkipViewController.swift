//
//  FilterTakeSkipViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/11.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FilterTakeSkipViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "过滤操作符：filter、take、skip等"
        view.backgroundColor = UIColor.white
        
        
        //filter
        //过滤掉那些不符合要求的事件event
        Observable.of(2,30,22,50,34,3,2,67).filter {
            $0 > 10
        }.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //distinctUntilChange
        //过滤掉连续重复的事件
        Observable.of(1,2,3,4,4,5,5,6).distinctUntilChanged().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //single
        //限制只发送一次事件，或者是满足条件的第一个事件。如果存在多个事件或者没有事件都会发出一个error事件。如果只有一个事件，则不会发出error事件。
        Observable.of(1,2,3,4).single({$0 == 2}).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        Observable.of("A","B","C","D").single().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //elememtAt
        //该方法实现只处理在指定位置的事件。
        Observable.of(1,2,3,4).elementAt(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //ignoreElement
        //该操作符可以忽略掉所有的的元素，只发出error或completed事件。如果我们不关心Observable的所有元素，只关心Observable在什么时候终止，那就可以用ignoreElement。
        Observable.of(1,2,3,4).ignoreElements().subscribe {print($0)}.disposed(by: disposeBag)
        
        
        //take
        //实现仅发送Observable序列的前n个事件，在满足数量之后会自动.completed
        Observable.of(1,2,3,4).take(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //takeLast
        //仅发送Observable序列的后n个事件
        Observable.of(1,2,3,4,5).takeLast(3).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //skip
        //跳过Observable序列发出的前n个事件
        Observable.of(1,2,3,4,5).skip(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //sample
        //除了订阅源外，还可以监听另一个Observable，即notifier。每当收到notifier事件，就会从源序列取一个最新的事件并发送，而如果两次notifier事件之间没有源序列的事件，则不发送值。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source.sample(notifier).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        source.onNext(1)
        //让源序列接收消息
        notifier.onNext("A")
        
        source.onNext(2)
        //让源序列接收消息
        notifier.onNext("B")
        notifier.onNext("C")
        
        source.onNext(3)
        source.onNext(4)
        
        //让源序列接收消息
        notifier.onNext("D")
        
        source.onNext(5)
        
        //让源序列接收消息
        notifier.onCompleted()
        
        
        //debounce
        //debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生，换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 2.1 ]
        ]
        
        //生成对应的Observable序列并订阅
        Observable.from(times).flatMap {item in
            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
        }.debounce(0.5, scheduler: MainScheduler.instance).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
    }


}
