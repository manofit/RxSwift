//
//  AnyObserverBinderViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnyObserverBinderViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        title = "观察者1： AnyObserver、Binder"
        view.backgroundColor = UIColor.white
        
        
        //观察者的作用就是监听event事件，然后对这个event事件做出自己响应，或者说任何响应event事件的行为都是观察者。如：
        //1.点击按钮弹出提示框，“弹出提示框”就是观察者observer<Void>
        //2.请求json数据后，打印出json数据，“打印json数据”就是观察者observer<JSON>
        
        //直接在subscribe、bind方法中创建观察者
        //1.在subscribe方法中创建，当事件发生时，应该做出什么样的反应
        let observable1 = Observable.of("A", "B", "C")
        observable1.subscribe(onNext: {element in
            print(element)
        }, onError: {error in
            print(error)
        }, onCompleted: {
            print("completed")
        }).disposed(by: disposeBag)
        //2.在bind方法中创建
        let observable2 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable2.map {"当前索引数：\($0)"}.bind {(text) in
            print(text)
        }.disposed(by: disposeBag)
        
        //使用AnyObserver创建观察者
        //AnyObserver可以用来描述任意一种观察者
        //1.配合subscribe方法使用
        //观察者
        let observer1:AnyObserver<String> = AnyObserver {event in
            switch event {
            case .next(let data):
                print(data)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        let observable3 = Observable.of("A", "B", "C")
        observable3.subscribe(observer1)
        //2.配合bindTo方法使用
        let observer2:AnyObserver<String> = AnyObserver {event in
            switch event {
            case .next(let text):
                print(text)
            default:
                break
            }
        }
        let observable4 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable4.map{"当前索引数：\($0)"}.bind(to:observer2).disposed(by: disposeBag)
        
        //使用Binder创建观察者
        //Binder更专注于特定的场景，Binder有两个特征：1.不会处理错误事件2.确保绑定执行在给定的Scheduler，默认是MainScheduler。
        //一旦产生错误事件，在调试环境下将执行fatalError，在发布环境下将打印错误消息
        //上面产生序列数的样例，在响应事件时候，只会处理next事件，而且在主线程上，这种情况最好使用Binder
        let label = UILabel(frame:CGRect(x:0, y:0, width:200, height:25))
        view.addSubview(label)
        let observer3:Binder<String> = Binder(label) {(view, text) in
            view.text = text
        }
        let observable5 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable5.map{"当前索引数：\($0)"}.bind(to: observer3).disposed(by: disposeBag)
        
        
    }


}
