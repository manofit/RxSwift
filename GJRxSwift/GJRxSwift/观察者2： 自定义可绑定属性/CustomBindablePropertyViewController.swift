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
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "观察者2： 自定义可绑定属性"
        view.backgroundColor = UIColor.white
        
        let label = UILabel(frame:CGRect(x:0, y:0, width:200, height:25))
        view.addSubview(label)
        //如何让创建出的UI控件默认就有一些观察者
        //比如让UILabel都有个fontSize可绑定属性，会根据事件值自动改变标签的字体大小
        //1.对UI类进行扩展
        let observable1 = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable1.map{ CGFloat($0) }.bind(to: label.fontSize).disposed(by:disposeBag)
        //2.对Reactive类进行扩展
        let observable2 = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable2.map{ CGFloat($0) }.bind(to: label.rx.fontSize).disposed(by:disposeBag)
        
        
        //所以上面显示索引数的样例，可以直接使用RxSwift提供的绑定属性
        let observable3 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable3.map{"当前索引数：\($0)"}.bind(to: label.rx.text).disposed(by:disposeBag)
        
    }


}

//RxSwift自带的可绑定属性(UI观察者),例如UIlabel就有text和attributedText这两个可绑定属性
extension Reactive where Base: UILabel {
    
    public var text: Binder<String?> {
        return Binder(self.base) {label, text in
            label.text = text
        }
    }
    
    public var attributeText: Binder<NSAttributedString?> {
        return Binder(self.base) {label, text in
            label.attributedText = text
        }
    }
}


//1.对UI类进行扩展
extension UILabel {
    public var fontSize:Binder<CGFloat> {
        return Binder(self) {label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

//2.对Reactive类进行扩展
extension Reactive where Base: UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) {label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}


