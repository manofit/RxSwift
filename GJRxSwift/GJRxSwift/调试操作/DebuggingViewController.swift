//
//  DebuggingViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/13.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DebuggingViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "调试操作"
        view.backgroundColor = UIColor.white
        
        
        //debug
        //将debug操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印 出来。
        Observable.of(1,2,3).startWith(0).debug().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        //还可以传入标记参数，用来区分是哪个debug
        Observable.of(4,5,6).startWith(3).debug("调试1").subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
    }


}
