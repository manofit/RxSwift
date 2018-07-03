//
//  ObservableSubscribeDoonDisposeViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ObservableSubscribeDoonDisposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Observable订阅、事件监听、订阅销毁"
        view.backgroundColor = UIColor.white
        
        
        //有了Observable可观察序列，我们还要使用 subscribe() 方法来订阅它，接收它发出的 Event。
        let observable1 = Observable.of("A", "B", "C")
        observable1.subscribe { (event) in
            print(event)
        }
        
        let observable2 = Observable.of("A", "B" ,"C")
        observable2.subscribe { (event) in
            print(event.element)
        }
        
        let observable3 = Observable.of("A", "B", "C")
        observable3.subscribe(onNext: {element in
            print(element)
        }, onError: {error in
            print(error)
        }, onCompleted: {
            print("complated")
        }, onDisposed: {
            print("disposed")
        })
        //也可以只处理onNext
        observable3.subscribe(onNext: {element in
            print(element)
        })
        
        
        //监听事件的生命周期
        //doOn：会在每一次事件发送之前调用
        let observable4 = Observable.of("A", "B", "C")
        observable4.do(onNext: {element in
            print("next:",element)
        }, onError: {error in
            print("will error:", error)
        },onCompleted: {
            print("will completed")
        },onDispose: {
            print("will dispose")
        }).subscribe(onNext: {element in
            print(element)
        },onError: {error in
            print(error)
        },onCompleted: {
            print("completed")
        },onDisposed: {
            print("disposed")
        })
        
        
        //observable销毁
        //一个observable创建出来不会马上就开始激活从而发出event，而是等到他被订阅才会被激活
        //observable序列激活之后，一直要等到他发出error或者completed的event后才会被终结
        //1.dispose()，手动取消一个订阅
        let observable5 = Observable.of("A", "B", "C")
        let subscription = observable5.subscribe { (event) in
            print(event)
        }
        subscription.dispose()
        //2.DisposeBag，销毁多个订阅
        let disposeBag = DisposeBag()
        //第1个Observable，及其订阅
        let observable6 = Observable.of("A", "B", "C")
        observable6.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        
        //第2个Observable，及其订阅
        let observable7 = Observable.of(1, 2, 3)
        observable7.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
    }


}
