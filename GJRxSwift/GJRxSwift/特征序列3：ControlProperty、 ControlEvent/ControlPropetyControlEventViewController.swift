//
//  ControlPropetyControlEventViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/19.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ControlPropetyControlEventViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "特征序列3：ControlProperty、 ControlEvent"
        view.backgroundColor = UIColor.white
        
        
        
        //ControlProperty
        //专门用来描述UI控件属性，拥有该类型的属性都是被观察者（Observable）。
        //具有以下特征：1.不会产生error事件。2.一定是在主线程监听。3.一定是在主线程订阅。4.共享状态变化。
        //其实在RxCocoa下许多UI控件都是被观察者（可观察序列），比如UITextField的rx.text属性类型便是ControlProperty<String?>
        //如果我们想让UITextField里输入的内容实时的显示在另一个label上面，可以：
        let label = UILabel(frame: CGRect(x:100, y:100, width:100, height:30))
        view.addSubview(label)
        
        let textField = UITextField(frame: CGRect(x:100, y:140, width:100, height:30))
        textField.borderStyle = .line
        view.addSubview(textField)
        
        textField.rx.text.bind(to: label.rx.text).disposed(by: disposeBag)
        
        
        //ControlEvent
        //专门用来描述UI所产生的事件，拥有该类型的属性都是被观察者（Observable）。
        //具有以下特征：1.不会产生error事件。2.一定是在主线程监听。3.一定是在主线程订阅。4.共享状态变化。
        //在RxCocoa下许多UI控件的事件方法都是被观察者（可观察序列），比如UIButton的rx.tap方法类型就是ControlEvent<Void>
        //如果我们想在button被点击的时候， 在控制台输出文字，可以：
        let button = UIButton(type: .custom)
        button.frame = CGRect(x:100 ,y:200, width:50, height:30)
        button.setTitle("点击", for: .normal)
        view.addSubview(button)
        
        button.rx.tap.subscribe(onNext: {print("点击了按钮")}).disposed(by: disposeBag)
        
        
        
    }


}
