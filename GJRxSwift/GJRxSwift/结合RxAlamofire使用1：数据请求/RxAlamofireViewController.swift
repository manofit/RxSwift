//
//  RxAlamofireViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxAlamofire
import RxCocoa
import RxSwift

class RxAlamofireViewController: UIViewController {
    
    //“发起请求”按钮
    @IBOutlet weak var startBtn: UIButton!
    
    //“取消请求”按钮
    @IBOutlet weak var cancelBtn: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "结合RxAlamofire使用1：数据请求"
        view.backgroundColor = UIColor.white
        
        
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string:urlString)!
        
        //使用request请求数据
        request(.get, url).data().subscribe(onNext: {data in
            //处理数据
            let str = String(data:data, encoding:String.Encoding.utf8)
            print(str ?? "")
        }, onError: {error in
            print("请求失败：",error)
        }).disposed(by: disposeBag)
        
        //使用requestData请求数据
        requestData(.get, url).subscribe(onNext: {
            response, data in
            if 200..<300 ~= response.statusCode {
                let str = String(data:data, encoding:String.Encoding.utf8)
                print(str ?? "")
            }else{
                print("请求失败")
            }
        }).disposed(by: disposeBag)
        
        //如果请求的数据是字符串类型，可以在request请求时直接使用responseString()方法自动实现
        request(.get, url).responseString().subscribe(onNext:{
            response, data in
            print("返回数据：",data)
        }).disposed(by: disposeBag)
        
        //也可以直接使用requestString去获取数据
        requestString(.get, url).subscribe(onNext:{
            response, data in
            print("返回数据是：",data)
        }).disposed(by: disposeBag)
        
        //发起请求按钮点击
        startBtn.rx.tap.asObservable().flatMap {
            request(.get, url).responseString().takeUntil(self.cancelBtn.rx.tap) //如果取消按钮点击则停止请求
        }.subscribe(onNext:{
            response, data in
            print("请求数据：",data)
        }, onError:{error in
            print("失败：",error)
        }).disposed(by: disposeBag)
    }


}
