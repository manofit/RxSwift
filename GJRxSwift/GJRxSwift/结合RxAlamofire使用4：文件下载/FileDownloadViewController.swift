//
//  FileDownloadViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/5.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxAlamofire

class FileDownloadViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "结合RxAlamofire使用4：文件下载"
        view.backgroundColor = UIColor.white
        
        
        
    }


}
