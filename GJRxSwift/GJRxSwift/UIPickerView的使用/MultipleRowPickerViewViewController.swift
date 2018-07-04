//
//  MultipleRowPickerViewViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class MultipleRowPickerViewViewController: UIViewController {
    
    var pickerView:UIPickerView!
    
    let disposeBag = DisposeBag()
    
    private let stringPickerAdapter = RxPickerViewStringAdapter<[[String]]>.init(components: [], numberOfComponents: {dataSource, pickerView, components in components.count}, numberOfRowsInComponent: {(_,_, components, component) -> Int in
        return components[component].count
    }, titleForRow: {(_,_,components, row, component) -> String? in
        return components[component][row]
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        title = "UIPickerView的使用（多列）"
        view.backgroundColor = UIColor.white
        
        
        pickerView = UIPickerView()
        view.addSubview(pickerView)
        
        Observable.just([["one","two","three"],["A","B","C"]]).bind(to: pickerView.rx.items(adapter: stringPickerAdapter)).disposed(by: disposeBag)
        
        let button = UIButton(frame:CGRect(x:0, y:0, width:100, height:30))
        button.center = view.center
        button.backgroundColor = UIColor.blue
        button.setTitle("获取信息", for: .normal)
        button.rx.tap.bind {[weak self] in
            self?.getPickerViewValue()
            }.disposed(by: disposeBag)
        view.addSubview(button)
        
    }
    
    //触摸按钮时，获得被选中的索引
    @objc func getPickerViewValue(){
        
    }
        
}
