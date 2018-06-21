//
//  BindViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BindViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    struct UserViewModel {
        let username = Variable("guest")
        
        lazy var userinfo = {
            return self.username.asObservable().map {$0 == "gaojun" ? "是你啊" : "你是访客"}.share(replay: 1)
        }()
    }
    
    var userVM = UserViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "双向绑定：<->"
        view.backgroundColor = UIColor.white
        
        
        //简单的双向绑定
        let textField = UITextField(frame: CGRect(x:20, y:84, width:200, height:30))
        textField.borderStyle = UITextBorderStyle.roundedRect
        view.addSubview(textField)
        
        let label = UILabel(frame:CGRect(x:20, y:124, width:220, height:30))
        view.addSubview(label)
        
        //将username与textField双向绑定
        userVM.username.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)
        textField.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
        
        //将userinfo绑定到Label上
        userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
        
    }


}
