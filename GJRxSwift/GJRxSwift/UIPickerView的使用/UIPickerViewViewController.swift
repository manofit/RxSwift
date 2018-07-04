//
//  UIPickerViewViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class UIPickerViewViewController: UIViewController {
    
    var pickerView:UIPickerView!
    
    let disposeBag = DisposeBag()
    
    private let stringPickerAdapter = RxPickerViewStringAdapter<[String]>.init(components: [], numberOfComponents: {_,_,_ in 1}, numberOfRowsInComponent: {(_,_,items,_) -> Int in
        return items.count
    }, titleForRow: {(_,_,items,row,_) -> String? in
        return items[row]
    })

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UIPickerView的使用（单列）"
        view.backgroundColor = UIColor.white
        
        
        pickerView = UIPickerView()
        view.addSubview(pickerView)
        
        Observable.just(["one","two","three"]).bind(to: pickerView.rx.items(adapter: stringPickerAdapter)).disposed(by: disposeBag)
        
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
        let message = String(pickerView.selectedRow(inComponent: 0))
        let alertController = UIAlertController(title: "被选中的索引为",
                                                message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
