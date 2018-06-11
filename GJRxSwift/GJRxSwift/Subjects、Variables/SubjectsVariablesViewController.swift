//
//  SubjectsVariablesViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/8.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectsVariablesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Subjects、Variables"
        view.backgroundColor = UIColor.white
        
        
        /*
         * Subjects 既是订阅者，也是 Observable：既能动态的接收新的值，又能在有了新值之后，通过event将新值发出给他的订阅者。
         * 一共4中subjects：PublishSubject、BehaviorSubject、ReplaySubject、Variable，他们都是Observable，他们的订阅者都能接收到他们发出的event。直到subject发出.completed或者.error后，该subject才会终结，同时不会再发出.next事件。对于那些在subject终结后还订阅的订阅者，也能收到subject发出的一条.completed或.error的event，告诉订阅者他已经终结了。他们的最大区别就是：当一个新的订阅者刚订阅他的时候，能不能收到subject以前发出的旧的event，如果能的话又能接收到多少。
         * subject几个常用方法：onNext()、onError()、onCompleted()。
         */
        
        //PublishSubject
        //最普通的subject，不需要初始值就能创建，只能接收到订阅后的新event，不能接收订阅前发出的event。
        let disposeBag = DisposeBag()
        //创建subject
        let subject = PublishSubject<String>()
        //当前没有订阅者，这个不会输出控制台
        subject.onNext("111")
        //第一次订阅
        subject.subscribe(onNext: {string in
            print("第一次订阅：",string)
        }, onCompleted: {
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        //当前有一个订阅者，信息会被输出控制台
        subject.onNext("222")
        //第二次订阅
        subject.subscribe(onNext: {string in
            print("第二次订阅：",string)
        }, onCompleted: {
            print("第二次订阅：onCompleted")
        }).disposed(by: disposeBag)
        //当前两个订阅者，信息会被输出控制台
        subject.onNext("333")
        //让subject结束
        subject.onCompleted()
        //结束后，不会再发出.next事件
        subject.onNext("444")
        //subject终结后再次订阅，会收到.completed事件
        subject.subscribe(onNext: {string in
            print("第三次订阅：",string)
        }, onCompleted: {
            print("第三次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        
        //BehaviorSubject
        //需要通过一个默认值来创建，订阅者订阅后，可以立即收到BehaviorSubject上一个发出的Event，然后接收到后面正常发出的event。
        let subject2 = BehaviorSubject(value: "111")
        subject2.subscribe {event in
            print("第一次订阅：",event)
        }.disposed(by: disposeBag)
        subject2.onNext("222")
        subject2.onError(NSError(domain:"local", code:0, userInfo:nil))
        subject2.subscribe {event in
            print("第二次订阅：",event)
        }.disposed(by: disposeBag)
        
        
        //ReplaySubject
        //创建时候需要一个bufferSize，指定他的event缓存个数。缓存最后发出的几个event。如果一个订阅者订阅了这个subject，这个订阅者会立即收到之前的几个event，然后接收到后面正常发出的event。如果订阅者订阅了已经终结的subject，除了收到缓存的.next event之外，还会收到那个终结的.error或.completed event。
        let subject3 = ReplaySubject<String>.create(bufferSize: 2)
        //连续发出三个next事件
        subject3.onNext("111")
        subject3.onNext("222")
        subject3.onNext("333")
        //第一次订阅subject
        subject3.subscribe {event in
            print("第一次订阅：",event)
        }.disposed(by: disposeBag)
        //再次发送一个next事件
        subject3.onNext("444")
        //第二次订阅
        subject3.subscribe {event in
            print("第二次订阅：",event)
        }.disposed(by: disposeBag)
        //结束subject
        subject3.onCompleted()
        //第三次订阅
        subject3.subscribe {event in
            print("第三次订阅：",event)
        }.disposed(by: disposeBag)
        
        
        //Variable
        //对BehaviorSubject的封装，所以需要一个初始值进行创建。具有BehaviorSubject的功能，能向订阅者发出上一个event和之后的event。不同的是，Variable会把当前发出的值保存为自己的状态，同时他会在销毁的时候自动向订阅者发出.completed的event，不需要也不能手动给Variable发送completed或error事件来结束他。简单的说，Variable有一个value的属性，我们改变这个value的属性的值就相当于给订阅者发送一次onNext()方法，而这个最新的onNext()值就保存在value的属性里。
        //Variable本身没有subscribe方法，但是所有的subjects都有一个asObservable()的方法，返回这个Variable的Observable类型，可以用来订阅。
        let variable = Variable("111")
        variable.value = "222"
        variable.asObservable().subscribe {
            print("第一次订阅：",$0)
        }.disposed(by: disposeBag)
        variable.value = "333"
        variable.asObservable().subscribe {
            print("第二次订阅：",$0)
        }.disposed(by: disposeBag)
        variable.value = "444"
        //由于 Variable 对象在 viewDidLoad() 方法内初始化，所以它的生命周期就被限制在该方法内。当这个方法执行完毕后，这个 Variable 对象就会被销毁，同时它也就自动地向它的所有订阅者发出 .completed 事件
    }


}
