//
//  MyTableViewCell.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift

class MyTableViewCell: UITableViewCell {
    
    var button:UIButton!
    
    var disposeBag = DisposeBag()
    
    //单元格重用时候调用
    //每次 prepareForReuse() 方法执行时都会初始化一个新的 disposeBag。这是因为 cell 是可以复用的，这样当 cell 每次重用的时候，便会自动释放之前的 disposeBag，从而保证 cell 被重用的时候不会被多次订阅，避免错误发生。
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.center = CGPoint(x:bounds.size.width-35, y:bounds.midY)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //添加按钮
        button = UIButton(frame:CGRect(x:0, y:0, width:40, height:25))
        button.setTitle("点击", for:.normal) //普通状态下的文字
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(button)
    }

}
