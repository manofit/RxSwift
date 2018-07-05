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
import Alamofire

class FileDownloadViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "结合RxAlamofire使用4：文件下载"
        view.backgroundColor = UIColor.white
        
        
        /*
         *自定义下载文件的保存目录
         */
        //将文件下载下来，保存到用户文档目录下，文件名不变。
        //指定下载路径，文件名不变
        let destination: DownloadRequest.DownloadFileDestination = {_, response in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
            //两个参数表示如果有同名则覆盖，没有则新建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        //将文件下载下来，保存到用户文档目录下的file1子目录，文件名改为myLogo.png。
        //指定下载路径，改变文件名
        let destination2: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("file1/myLogo.png")
            //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let fileURL = URL(string:"http://www.xxx.com/download.php?")
        
        download(URLRequest(url:fileURL!), to: destination).subscribe(onNext: {element in
            print("开始下载")
        }, onError: {error in
            print("下载失败，失败原因：",error)
        }, onCompleted: {
            print("下载结束")
        }).disposed(by: disposeBag)
        
        
        /*
         * 使用默认提供的下载路径
         */
        let destination3 = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        
        
        //下载进度
        download(URLRequest(url:fileURL!), to: destination).subscribe(onNext: {element in
            print("下载开始")
            element.downloadProgress(closure: {progress in
                print("当前进度: \(progress.fractionCompleted)")
                print("  已下载：\(progress.completedUnitCount/1024)KB")
                print("  总大小：\(progress.totalUnitCount/1024)KB")
            })
        }, onError: {error in
            print("下载失败，失败原因：",error)
        }, onCompleted: {
            print("下载结束")
        }).disposed(by: disposeBag)
        
        
        
    }


}
