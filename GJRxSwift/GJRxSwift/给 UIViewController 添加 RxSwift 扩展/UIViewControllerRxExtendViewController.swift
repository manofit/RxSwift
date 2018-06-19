//
//  UIViewControllerRxExtendViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/19.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//通过扩展，我们可以对VC的各种方法进行订阅
class UIViewControllerRxExtendViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //页面显示状态完毕
        self.rx.isVisible.subscribe(onNext: {visible in
            print("当前页面显示状态：\(visible)")
        }).disposed(by: disposeBag)
        
        //页面加载完毕
        self.rx.viewDidLoad.subscribe(onNext: {
            self.title = "给 UIViewController 添加 RxSwift 扩展"
            self.view.backgroundColor = UIColor.white
        }).disposed(by: disposeBag)
        
        //页面将要显示
        self.rx.viewWillAppear
            .subscribe(onNext: { animated in
                print("viewWillAppear")
            }).disposed(by: disposeBag)
        
        //页面显示完毕
        self.rx.viewDidAppear
            .subscribe(onNext: { animated in
                print("viewDidAppear")
            }).disposed(by: disposeBag)
    }

}
