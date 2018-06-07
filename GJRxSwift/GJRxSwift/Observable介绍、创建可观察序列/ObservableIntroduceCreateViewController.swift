//
//  ObservableIntroduceCreateViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ObservableIntroduceCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "Observable介绍、创建可观察序列"
        view.backgroundColor = UIColor.white
        
        //just()
        let observable1 = Observable.just(5)
        
        //of()
        //该方法接收可变的参数，但是参数的类型必须相同
        //虽然没显示地说明类型，但是swift也会自动推断类型
        let observable2 = Observable.of("A", "B", "C")
        
        //from()
        //改方法需要接收一个数组类型的参数
        //效果和上面的of相同
        let observable3 = Observable.from(["A", "B", "C"])
        
        //empty()
        //创建一个空的observable序列
        let observable4 = Observable<Int>.empty()
        
        //never()
        //创建一个永远不会停止发出Event的observable序列
        let observable5 = Observable<Int>.never()
        
        //error()
        //创建一个不会做任何操作，而是直接发送一个错误的observable序列
        enum MyError: Error {
            case A
            case B
        }
        let observable6 = Observable<Int>.error(MyError.A)
        
        //range()
        //下面两个样例的结果相同
        let observable7 = Observable.range(start: 1, count: 5)
        let observable8 = Observable.of(1,2,3,4,5)
        
        //repeatElement()
        //创建一个可以无限发出给定元素的observable序列
        let observable9 = Observable.repeatElement(1)
        
        //generate()
        //创建一个只有当所有条件都为true的时候才会给出动作的observable序列
        //下面两个样例的结果相同
        let observable10 = Observable.generate(initialState: 0, condition: {$0<=10}, iterate: {$0+2})
        let observable11 = Observable.of(0,2,4,6,8,10)
        
        //create()
        //该方法接收一个block形式的参数，对每一个过来的订阅者进行处理
        let observable12 = Observable<String>.create {observer in
            //对订阅者发出next事件，且携带一个数据hello world
            observer.onNext("hello world")
            //对订阅者发出.complated事件
            observer.onCompleted()
            //一个订阅者会有一个Disposable类型的返回值，所以结尾要return一个Disposable
            return Disposables.create()
        }
        //测试订阅
        observable12.subscribe {
            print($0)
        }
        
        //deferred()
        //创建一个observable工厂，通过传入一个block来执行延迟observable序列的创建行为，而这个block里就是真正的实例化序列的对象的地方。
        var isOdd = true
        
        let factory = Observable<Int>.deferred {
            isOdd = !isOdd
            
            if isOdd {
                return Observable.of(1,3,5,7)
            }else {
                return Observable.of(2,4,6,8)
            }
        }
        //第一次订阅测试
        factory.subscribe { (event) in
            print("\(isOdd)", event)
        }
        //第二次订阅测试
        factory.subscribe { (event) in
            print("\(isOdd)", event)
        }
        
        //interval()
        //创建的observable序列每隔一段时间会发出一个索引数的元素，而且会一直发送下去
        //下面方法每隔1秒发送一次，并且在主线程
        let observable13 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable13.subscribe { (event) in
            print(event)
        }
        
        //timer()
        //5秒后发出唯一一个元素0
        let observable14 = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
        observable14.subscribe { (event) in
            print(event)
        }
        //5秒后创建一个序列，每隔1秒产生一个元素
        let observable15 = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
        observable15.subscribe { (event) in
            print(event)
        }
        
    }


}
