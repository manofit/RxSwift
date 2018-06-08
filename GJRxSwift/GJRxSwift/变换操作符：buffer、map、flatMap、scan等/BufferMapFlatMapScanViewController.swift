//
//  BufferMapFlatMapScanViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/8.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BufferMapFlatMapScanViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "变换操作符：buffer、map、flatMap、scan等"
        view.backgroundColor = UIColor.white
        
        
        //变换操作，就是对原始的Observable序列进行一系列转换。
        
        //buffer
        //缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程
        //缓冲observable中发出的新元素，当元素达到某个数量，或者经过特定时间，就会将这个元素集合发送出来
        let subject = PublishSubject<String>()
        //每缓存3个元素则组合起来发出一次。如果1秒钟内不够3个也会发出(有几个发几个，一个没有就发出空数组[])
        subject.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        
        //window
        //和buffer十分类似，不过buffer是周期性的将缓存的元素集合发出，而window周期性的将元素集合以Observable的形态发送出来。而且window可以实时发出元素序列，不需要等到元素搜索完毕后，才会发出序列。
        let subject2 = PublishSubject<String>()
        //每3个元素作为一个子Observable序列发出
        subject2.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext: {[weak self] in
            print("subscribe:\($0)")
            $0.asObservable().subscribe(onNext: {print($0)}).disposed(by: (self?.disposeBag)!)
        }).disposed(by: disposeBag)
        subject2.onNext("a")
        subject2.onNext("b")
        subject2.onNext("c")
        
        subject2.onNext("1")
        subject2.onNext("2")
        subject2.onNext("3")
        
        
        //map
        //通过传入一个闭包，把原来的observable序列转为一个新的observable序列
        Observable.of(1,2,3).map{$0*10}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //flatMap
        //map在做转换的时候容易出现“升维”的情况，就是从一个序列变成一个序列的序列，但是flatMap操作符会对源Observable的每一个元素应用一个转换方法，将他们变成Observables，然后将这些Observables的元素合并之后再发送出来。即又将其“拍扁”（降维）成一个Observable序列。
        //常用作：比如当Observable的元素本身就拥有其他的Observable时候，我们可以将所有子OBservables的元素发送出来。
        let subject3 = BehaviorSubject(value: "A")
        let subject4 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject3)
        variable.asObservable().flatMap {$0}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject3.onNext("B")
        variable.value = subject4
        subject4.onNext("2")
        subject3.onNext("C")
        
        
        //flatMapLatest
        //flatMapLatest与flatMap唯一的区别就是：flatMapLatest只会接收最新的value事件。
        let subject5 = BehaviorSubject(value: "A")
        let subject6 = BehaviorSubject(value: "1")
        
        let variable2 = Variable(subject5)
        variable2.asObservable().flatMap {$0}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject5.onNext("B")
        variable2.value = subject6
        subject6.onNext("2")
        subject5.onNext("C")
        
        
        //flatMapFirst
        //与flatMap唯一的区别就是：只会接收最初的value事件
        let subject7 = BehaviorSubject(value: "A")
        let subject8 = BehaviorSubject(value: "1")
        
        let variable3 = Variable(subject5)
        variable3.asObservable().flatMap {$0}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject7.onNext("B")
        variable3.value = subject8
        subject8.onNext("2")
        subject7.onNext("C")
        
        
        //concatMap
        //与flatMap唯一的区别就是：当前一个Observable元素发送完毕后，后一个Observable才可以开始发出元素，也就是等待前一个Observable产生完成事件，才对后一个Observable进行订阅。
        let subject9 = BehaviorSubject(value: "A")
        let subject10 = BehaviorSubject(value: "1")
        
        let variable4 = Variable(subject9)
        variable4.asObservable().flatMap {$0}.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        subject9.onNext("B")
        variable4.value = subject10
        subject10.onNext("2")
        subject9.onNext("C")
        subject9.onCompleted()//只有等前一个序列结束后，才能接收下一个序列。
        
        
        //scan
        //先给一个初始化的数，然后不断地拿前一个结果和最新的值进行处理操作。
        Observable.of(1,2,3,4,5).scan(0) {acum, elem in
            acum + elem
        }.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        //groupBy
        //groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来，也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
        //将奇偶数分成两组
        Observable.of(0,1,2,3,4,5).groupBy(keySelector: { element -> String in
            return element % 2 == 0 ? "偶数" : "奇数"
        }).subscribe { [weak self] event in
            switch event {
            case .next(let group):
                group.asObservable().subscribe({event in
                    print("key:\(group.key)  event:\(event)")
                }).disposed(by: (self?.disposeBag)!)
            default:
                print("")
            }
        }.disposed(by: disposeBag)
        
    }


}
