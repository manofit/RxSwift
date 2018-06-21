//
//  UIDatePickerViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UIDatePickerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    lazy var dateFormatter:DateFormatter = {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UI控件扩展8：UIDatePicker"
        view.backgroundColor = UIColor.white
        
        
        let datePicker = UIDatePicker(frame:CGRect(x:10, y:84, width:view.frame.size.width, height:100))
        view.addSubview(datePicker)
        
        let label = UILabel(frame:CGRect(x:10, y:200, width:100, height:30))
        view.addSubview(label)
        
        datePicker.rx.date.map {[weak self] in
            "当前时间" + self!.dateFormatter.string(from: $0)
        }.bind(to: label.rx.text).disposed(by: disposeBag)
        
    }


}
