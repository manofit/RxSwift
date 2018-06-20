//
//  UIButtonUIBarButtonItemViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/20.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UIButtonUIBarButtonItemViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UI控件扩展3：UIButton、UIBarButtonItem"
        view.backgroundColor = UIColor.white
        
        
        //按钮点击响应
        let button = UIButton(type: .custom)
        button.frame = CGRect(x:100 ,y:200, width:50, height:30)
        button.setTitle("点击", for: .normal)
        view.addSubview(button)
        
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.showMessage("按钮被点击")
        }).disposed(by: disposeBag)
        //或者，其中 rx.title 为 setTitle(_:for:) 的封装。
        button.rx.tap.bind { [weak self] in
            self?.showMessage("按钮被点击")
        }.disposed(by: disposeBag)
        
        //按钮标题的绑定
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map {"\($0)s"}.bind(to: button.rx.title(for: .normal)).disposed(by: disposeBag)
        
        //按钮富文本标题的绑定
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map(formatTimeInterval).bind(to: button.rx.attributedTitle()).disposed(by: disposeBag)
        
        //按钮图标的绑定
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map({
            let name = $0 % 2 == 0 ? "back" : "fooward"
            return UIImage(named:name)!
        }).bind(to: button.rx.image()).disposed(by: disposeBag)
        
        //按钮背景图片的绑定
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map {UIImage(named:"\($0 % 2)")!}.bind(to: button.rx.backgroundImage()).disposed(by: disposeBag)
        
        //按钮是否可用的绑定
        Observable<Int>.interval(5, scheduler: MainScheduler.instance).map {$0 % 5 == 0}.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    func showMessage(_ text:String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedStringKey.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedStringKey.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }


}
