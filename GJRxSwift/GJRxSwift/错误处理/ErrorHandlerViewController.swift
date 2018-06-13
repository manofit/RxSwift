//
//  ErrorHandlerViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/13.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum myError: Error {
    case A
    case B
}

class ErrorHandlerViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "错误处理"
        view.backgroundColor = UIColor.white
        
        
        //catchErrorJustReturn
        //当遇到error事件的时候，就返回指定的值，然后结束
        let subject1 = PublishSubject<String>()
        subject1.catchErrorJustReturn("错误").subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        subject1.onNext("A")
        subject1.onNext("B")
        subject1.onError(myError.A)
        subject1.onNext("C")
        
        
        //catchError
        //捕获error进行处理，还能返回另一个Observable序列进行订阅(切换到新的序列)
        let subject2 = PublishSubject<String>()
        let observable2 = Observable.of("1","2","3")
        
        subject2.catchError {
            print("Error:", $0)
            return observable2
        }.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        subject2.onNext("A")
        subject2.onNext("B")
        subject2.onError(myError.A)
        subject2.onNext("C")
        
        
        //retry
        //当遇到错误的时候，可以重新订阅该序列，比如遇到网络请求失败，可以进行重新连接，retry方法可以传入重试次数，不传的话只重试一次。
        var count = 1
        let observable3 = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
            
            if count == 1 {
                observer.onError(myError.A)
                print("Error le")
                count += 1
            }
            
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            
            return Disposables.create()
        }
        observable3.retry(2).subscribe(onNext: {print($0)}).disposed(by: disposeBag)
    }

}
