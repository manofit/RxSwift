//
//  UITextFieldUITextViewViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UITextFieldUITextViewViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UI控件扩展2：UITextField、UITextView"
        view.backgroundColor = UIColor.white
        
        
        //监听单个textfield内容变化(textView同理)
        //.orEmpty可以将String?类型的ControlProperty转换成String，省得我们解包
        let textField = UITextField(frame:CGRect(x:10, y:80, width:200, height:30))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        textField.rx.text.orEmpty.asObservable().subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        //直接使用changed事件也是一样
        textField.rx.text.orEmpty.changed.subscribe(onNext: {print($0)}).disposed(by: disposeBag)
        
        
        
        //将内容绑定到其他UI控件上
        //创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:120, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        //创建文本输出框
        let outputField = UITextField(frame: CGRect(x:10, y:180, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        //创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:190, width:220, height:30))
        self.view.addSubview(label)
        
        //创建按钮
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:270, width:40, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        
        //当文本内容改变
        let input = inputField.rx.text.orEmpty.asDriver()//将普通序列转换成Driver
        .throttle(0.3) //在主线程操作，0.3秒内值若多次改变，取最后一次
        
        //内容绑定到另一个输入框
        input.drive(outputField.rx.text).disposed(by: disposeBag)
        
        //内容绑定到文本标签中
        input.map {"当前字数：\($0.count)"}.drive(label.rx.text).disposed(by: disposeBag)
        
        //根据内容字数决定按钮是否可用
        input.map {$0.count>5}.drive(button.rx.isEnabled).disposed(by: disposeBag)
        
        
        
        //同时监听多个textfield的变化
        let textField_1 = UITextField(frame: CGRect(x:10, y:320, width:200, height:30))
        textField_1.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(textField_1)

        let textField_2 = UITextField(frame: CGRect(x:10, y:360, width:200, height:30))
        textField_2.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(textField_2)
        
        let label_1 = UILabel(frame:CGRect(x:20, y:400, width:220, height:30))
        self.view.addSubview(label_1)
        
        Observable.combineLatest(textField_1.rx.text.orEmpty, textField_2.rx.text.orEmpty) { textValue1, textValue2 -> String in
            return "输入的号码是：\(textValue1)-\(textValue2)"
            }.map {$0}.bind(to: label_1.rx.text).disposed(by: disposeBag)
        
        
        
        //事件监听
        //通过rx.ControlEvent可以监听输入框的各种事件，且多个事件状态可以自由组合。除了UI控件都有的touch事件外，还有如下几个事件：
        /*
         
         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件
         
         **/
        textField.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: {print("开始编辑")
        }).disposed(by: disposeBag)
        
        //下面代码我们在界面上添加两个输入框分别用于输入用户名和密码：如果当前焦点在用户名输入框时，按下 return 键时焦点自动转移到密码输入框上。如果当前焦点在密码输入框时，按下 return 键时自动移除焦点。
        let nameTF = UITextField(frame: CGRect(x:10, y:320, width:200, height:30))
        nameTF.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(nameTF)
        
        let passTF = UITextField(frame: CGRect(x:10, y:360, width:200, height:30))
        passTF.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(passTF)
        
        nameTF.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {passTF.becomeFirstResponder()}).disposed(by: disposeBag)
        passTF.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext:{passTF.resignFirstResponder()}).disposed(by: disposeBag)
        
        
    }


}
