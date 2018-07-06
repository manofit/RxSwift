//
//  FileUploadViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/5.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxAlamofire
import RxSwift
import Alamofire

class FileUploadViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "结合RxAlamofire使用3：文件上传"
        view.backgroundColor = UIColor.white
        
        
        //需要上传的文件
        let fileURL = Bundle.main.url(forResource: "xxxx", withExtension: "txt")
        //服务器路径
        let uploadURL = URL(string:"http://www.xxx.com/upload.php")!
        
        //使用文件流形式上传
        upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL)).subscribe(onCompleted: {
            print("上传完毕")
        }).disposed(by: disposeBag)
        
        //获得上传进度
        upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL)).subscribe(onNext: {element in
            element.uploadProgress(closure: {progress in
                print("当前进度：",progress.fractionCompleted)
                print("已上传进度：\(progress.completedUnitCount/1024)kb")
                print("总大小：\(progress.totalUnitCount/1024)kb")
            })
        }, onError: {error in
            print("上传失败")
        }, onCompleted: {
            print("上传完毕")
        }).disposed(by:  disposeBag)
        
        //将进度绑定到进度条
        let progressView = UIProgressView()
        
        upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL)).map {request in
            //返回一个关于进度的可观察序列
            Observable<Float>.create{ observer in
                request.uploadProgress(closure: { (progress) in
                    observer.onNext(Float(progress.fractionCompleted))
                    if progress.isFinished {
                        observer.onCompleted()
                    }
                })
                return Disposables.create()
            }
        }.flatMap{$0}.bind(to: progressView.rx.progress).disposed(by: disposeBag)
        
        
        //上传multipartFormData类型的文件数据，类似于表单里的文件提交
        //需要上传的文件
        let fileURL1 = Bundle.main.url(forResource: "0", withExtension: "png")
        let fileURL2 = Bundle.main.url(forResource: "1", withExtension: "png")
        
        upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(fileURL1!, withName: "file1")
                multipartFormData.append(fileURL2!, withName: "file2")
        },
            to: uploadURL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
        //字符串
        let strData = "hangge.com".data(using: String.Encoding.utf8)
        //数字
        let intData = String(10).data(using: String.Encoding.utf8)
        //文件1
        let path = Bundle.main.url(forResource: "0", withExtension: "png")!
        let file1Data = try! Data(contentsOf: path)
        //文件2
        let file2URL = Bundle.main.url(forResource: "1", withExtension: "png")
        
//        //服务器路径
        let uploadURL2 = URL(string: "http://www.hangge.com/upload2.php")!

        //将文件上传到服务器
        upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(strData!, withName: "value1")
                multipartFormData.append(intData!, withName: "value2")
                multipartFormData.append(file1Data, withName: "file1",
                                         fileName: "php.png", mimeType: "image/png")
                multipartFormData.append(file2URL!, withName: "file2")
        },
            to: uploadURL2,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
        
    }


}
