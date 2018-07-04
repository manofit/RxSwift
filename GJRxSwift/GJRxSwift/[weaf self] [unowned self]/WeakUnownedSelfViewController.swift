//
//  WeakUnownedSelfViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeakUnownedSelfViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "[unowned self] 与 [weak self]"
        view.backgroundColor = UIColor.white
        
        //[weak self] 与 [unowned self] 介绍
        //我们只需将闭包捕获列表定义为弱引用（weak）、或者无主引用（unowned）即可解决问题，这二者的使用场景分别如下：
        //1.如果捕获（比如 self）可以被设置为 nil，也就是说它可能在闭包前被销毁，那么就要将捕获定义为 weak。
        //2.如果它们一直是相互引用，即同时销毁的，那么就可以将捕获定义为 unowned。
        
        
        textField.rx.text.orEmpty.asDriver().drive(onNext: {
            [weak self] text in
            DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
                self?.label.text = text
            })
        }).disposed(by: disposeBag)
        //如果我们不用 [weak self] 而改用 [unowned self]，返回主页面　4　秒钟后由于详情页早已被销毁，这时访问 label 将会导致异常抛出。
        //当然如果我们把延时去掉的话，使用 [unowned self] 是完全没有问题的。
    }
    
    deinit {
        print(#file, #function)
    }


}
