//
//  UISliderUIStepperViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/21.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UISliderUIStepperViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UI控件扩展6：UISlider、UIStepper"
        view.backgroundColor = UIColor.white
        
        
        
        //UISlider
        let slider = UISlider(frame:CGRect(x:10, y:20, width:100, height:30))
        view.addSubview(slider)
        
        slider.rx.value.asObservable().subscribe(onNext: {print("当前值：\($0)")}).disposed(by: disposeBag)
        
        
        
        //UIStepper
        let stepper = UIStepper(frame:CGRect(x:10, y:70, width:80, height:30))
        view.addSubview(stepper)
        
        stepper.rx.value.asObservable().subscribe(onNext: {print("当前值：\($0)")}).disposed(by: disposeBag)
        
        
        //slider控制stepper步长
        slider.rx.value.map {Double($0)}.bind(to: stepper.rx.stepValue).disposed(by: disposeBag)
    }


}
