//
//  SingleCompletableMaybeViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SingleCompletableMaybeViewController: UIViewController {
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "特征序列1：Single、Completable、Maybe"
        view.backgroundColor = UIColor.white
        
        
        //single
        //single是Observable的另一个版本，但是不像Observable可以发出多个元素，他要么只能发出一个元素，要么产生一个error事件。而且不会共享状态变化。
        //比较常见用于HTTP请求，然后返回一个应答或者一个错误。或者用来描述任何只有一个元素的序列。
        //RxSwift还为Single提供了一个枚举：.success里面包含single的一个元素值，.eeror用于包含错误。
        /*
        enum SingleEvent<Element> {
            case success(Element)
            case error(Swift.Error)
        }
        */
        //获取豆瓣某频道下的歌曲信息
        enum DataError:Error {
            case canParseJSON
        }
        //创建single和创建Observable十分相似，下面代码我们定义一个用于生成网络请求single的函数。
        func getPlaylist(_ channel:String) -> Single<[String:Any]> {
            return Single<[String:Any]>.create { single in
                let url = "https://douban.fm/j/mine/playlist?"
                    + "type=n&channel=\(channel)&from=mainsite"
                let task = URLSession.shared.dataTask(with: URL(string:url)!) { data, _, error in
                    
                    if let error = error {
                        single(.error(error))
                        return
                    }
                    
                    guard let data = data,let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),let result = json as? [String:Any] else {
                        single(.error(DataError.canParseJSON))
                        return
                    }
                    
                    single(.success(result))

                }
                
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
        }
        //使用single
        getPlaylist("0").subscribe {event in
            switch event {
            case .success(let json):
                print("json结果：",json)
            case .error(let error):
                print("发生错误：",error)
            }
        }.disposed(by: disposeBag)
        //也可以使用subscribe(onSuccess:onError:)这种方式
        getPlaylist("0").subscribe(onSuccess: { (json) in
            print("json结果：",json)
        }) { (error) in
            print("发生错误：",error)
        }.disposed(by: disposeBag)
        
        
        
    }


}
