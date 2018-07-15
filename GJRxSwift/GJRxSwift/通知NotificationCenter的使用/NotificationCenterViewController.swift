//
//  NotificationCenterViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class NotificationCenterViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "通知NotificationCenter的使用"
        view.backgroundColor = UIColor.white
        
        
        //监听应用进入后台的通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name.UIApplicationDidEnterBackground).takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
            .subscribe(onNext: {_ in
            print("程序进入后台")
        })
        
        
        //监听键盘的通知
        //添加文本输入框
        let textField = UITextField(frame: CGRect(x:20, y:100, width:200, height:30))
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.returnKeyType = .done
        self.view.addSubview(textField)
        
        //点击键盘上的完成按钮后，收起键盘
        textField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {_ in
            textField.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        //监听键盘弹出通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow).takeUntil(self.rx.deallocated).subscribe(onNext: {_ in
            print("键盘出现了")
        })
        
        //监听键盘隐藏通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide).takeUntil(self.rx.deallocated).subscribe(onNext: {_ in
            print("键盘消失了")
        })
    }


}
