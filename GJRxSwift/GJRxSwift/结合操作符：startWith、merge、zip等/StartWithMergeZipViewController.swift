//
//  StartWithMergeZipViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/11.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StartWithMergeZipViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "结合操作符：startWith、merge、zip等"
        view.backgroundColor = UIColor.white
        
        
        //结合操作指的是将多个Observable序列进行组合，拼装成一个新的Observable。
        
        //startWith
        //在Observable序列开始之前插入一些元素，即发出事件之前，会先发出这些预先插入的事件。
        Observable.of("2","3").startWith("1").subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        Observable.of("2","3").startWith("0").subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        Observable.of("2","3").startWith("a").subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //merge
        //合并多个Observable是为一个Observable
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        Observable.of(subject1, subject2).merge().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(1)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(1)
        
        
        //zip
        //该方法将多个Observable序列压缩成一个Observable序列，而且会等到每个Observable事件一一对应地凑齐之后再合并。
        let subject3 = PublishSubject<Int>()
        let subject4 = PublishSubject<String>()
        
        Observable.zip(subject3, subject4) {
            "\($0)\($1)"
        }.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject3.onNext(1)
        subject4.onNext("A")
        subject3.onNext(2)
        subject4.onNext("B")
        subject4.onNext("C")
        subject4.onNext("D")
        subject3.onNext(3)
        subject3.onNext(4)
        subject3.onNext(5)
        
        
        //combineLatest
        //整个多个Observable，不同的是：每当任意一个Observable有新的事件产生时候，就会将其他Observable序列最新的事件用来合并
        let subject5 = PublishSubject<Int>()
        let subject6 = PublishSubject<String>()
        
        Observable.combineLatest(subject5, subject6) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject5.onNext(1)
        subject6.onNext("A")
        subject5.onNext(2)
        subject6.onNext("B")
        subject6.onNext("C")
        subject6.onNext("D")
        subject5.onNext(3)
        subject5.onNext(4)
        subject5.onNext(5)
        
        
        //withLatestForm
        //将两个Observable合并成一个，每当self队列发射一个元素时候，便从第二个序列中取出一个新值并发送出去。
        let subject7 = PublishSubject<String>()
        let subject8 = PublishSubject<String>()
        
        subject7.withLatestFrom(subject8).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        subject7.onNext("A")
        subject8.onNext("1")
        subject7.onNext("B")
        subject7.onNext("C")
        subject8.onNext("2")
        subject7.onNext("D")
        
        
        //switchLatest
        //switchLatest像switch一样，可以对事件流进行转换。比如本来监听的subject1，可以通过更改里面的value更换事件源，变成监听subject2。
        let subject9 = BehaviorSubject(value: "A")
        let subject10 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject9)
        
        variable.asObservable().switchLatest().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        subject9.onNext("B")
        subject9.onNext("C")
        
        //变换事件源
        variable.value = subject10
        subject9.onNext("D")
        subject10.onNext("2")
        
        //变换事件源
        variable.value = subject9
        subject10.onNext("3")
        subject9.onNext("E")
    }

}
