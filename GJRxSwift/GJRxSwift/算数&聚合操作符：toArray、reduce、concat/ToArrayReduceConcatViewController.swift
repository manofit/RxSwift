//
//  ToArrayReduceConcatViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/11.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ToArrayReduceConcatViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "算数&聚合操作符：toArray、reduce、concat"
        view.backgroundColor = UIColor.white
        
        
        //toArray
        //将一个序列变成一个数组，并作为一个单一的序列发送
        Observable.of(1,2,3).toArray().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //reduce
        //接收一个初始值和一个操作符，将给定的初始值使用操作符累计运算，得到一个最终的结果，并将其作为单个值发出去。
        Observable.of(1,2,3,4,5).reduce(0, accumulator: +).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //concat
        //将多个序列合并串联起来为一个Observable序列，并且只有当前面一个Observable序列发出了completed事件，才会开始发送下一个Observable事件。
        let subject1 = BehaviorSubject(value:1)
        let subject2 = BehaviorSubject(value:2)
        
        let variable = Variable(subject1)
        variable.asObservable().concat().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        subject2.onNext(2)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.value = subject2
        subject2.onNext(2)
    }
}
