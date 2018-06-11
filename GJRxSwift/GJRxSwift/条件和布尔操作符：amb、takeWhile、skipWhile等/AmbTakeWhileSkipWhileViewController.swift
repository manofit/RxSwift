//
//  AmbTakeWhileSkipWhileViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/11.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AmbTakeWhileSkipWhileViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "条件和布尔操作符：amb、takeWhile、skipWhile等"
        view.backgroundColor = UIColor.white
        
        
        //amb
        //当传入多个Observable到amb操作符，他将取第一个发出元素或者产生事件的Observable，然后只发出这个Observable的事件，忽略其他Observable。
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        subject1.amb(subject2).amb(subject3).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
        
        
        //takeWhile
        //一次判断Observable序列的每一个值是否满足给定的条件，当第一个不满足条件的事件出现时，订阅事件自动结束。
        Observable.of(2,3,4,5,6).takeWhile {$0 < 4}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //takeUntil
        //除了订阅源Observable外，通过takeUntil方法可以监听另一个Observable，即notifier。如果notifier发出值或completed通知，那么源Observable便自动完成，停止发送事件。
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source.takeUntil(notifier).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        //停止接收消息
        notifier.onCompleted()
        
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
        
        
        //skipWhile
        //跳过前面所有满足条件的事件，一旦遇到不满足条件的，就不会再跳过
        Observable.of(2,3,4,5,6).skipWhile{$0 < 4}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //skipUntil
        //同上面的 takeUntil 一样，skipUntil 除了订阅源 Observable 外，通过 skipUntil 方法我们还可以监视另外一个 Observable， 即 notifier 。与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，直到 notifier 发出值或 complete 通知。
        let source1 = PublishSubject<Int>()
        let notifier1 = PublishSubject<Int>()
        
        source1.skipUntil(notifier1).subscribe(onNext: { print($0) }).disposed(by: disposeBag)
        
        source1.onNext(1)
        source1.onNext(2)
        source1.onNext(3)
        source1.onNext(4)
        source1.onNext(5)
        
        //开始接收消息
        notifier1.onNext(0)
        
        source1.onNext(6)
        source1.onNext(7)
        source1.onNext(8)
        
        //仍然接收消息
        notifier1.onNext(0)
        
        source1.onNext(9)
        
    }


}
