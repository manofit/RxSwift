//
//  CustomBindablePropertyViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CustomBindablePropertyViewController: UIViewController {
    
    lazy var label:UILabel? = {
        let label = UILabel(frame:CGRect(x:0, y:0, width:200, height:25))
        return label
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "观察者2： 自定义可绑定属性"
        view.backgroundColor = UIColor.white
        
        view.addSubview(label!)
        //如何让创建出的UI控件默认就有一些观察者
        //比如让UILabel都有个fontSize可绑定属性，会根据事件值自动改变标签的字体大小
        //1.对UI类进行扩展
        let observable1 = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable1.map{ CGFloat($0) }.bind(to: label?.fontSize).disposed(by:disposeBag)
    }


}

extension UILabel {
    public var fontSize:Binder<CGFloat> {
        return Binder(self) {label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
