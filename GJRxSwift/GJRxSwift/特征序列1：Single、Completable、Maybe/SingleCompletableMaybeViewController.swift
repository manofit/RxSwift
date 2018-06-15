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
        //asSingle()可以将Observable转化为single
        Observable.of("1").asSingle().subscribe({print($0)}).disposed(by: disposeBag)
        
        
        
        //Completable
        //Completable是Observable的另一个版本，但是不能不发出多个元素，他要么只能产生一个completed事件要么产生一个error事件。
        //即：不会发出任何元素，只能发出completed或者error事件，不会共享状态变化。
        //适用于只关心任务是否完成，而不需要在意任务返回值的情况，例如程序退出的时候将一些数据缓存在本地，供下次启动时候使用，这种情况我们只关心缓存是否成功。
        //RxSwift为Completable提供了一个枚举：.completed用于产生完成事件，.error产生一个错误事件。
        /*
         enum CompletableEvent {
             case error(Swift.Error)
             case completed
         }
         **/
        //模拟一个将数据缓存在本地的操作
        enum CacheError: Error {
            case failedCaching
        }
        
        func cacheLocally() -> Completable {
            return Completable.create { completable in
                let success = (arc4random() % 2 == 0)
                
                guard success else {
                    completable(.error(CacheError.failedCaching))
                    return Disposables.create {}
                }
                
                completable(.completed)
                
                return Disposables.create {}
            }
        }
        
        //使用
        cacheLocally().subscribe {completable in
            switch completable {
            case .completed:
                print("保存成功")
            case .error(let error):
                print("失败：",error.localizedDescription)
            }
        }.disposed(by: disposeBag)
        
        //也可以这样使用
        cacheLocally().subscribe(onCompleted: {
            print("保存成功")
        }) { (error) in
            print("失败：",error.localizedDescription)
        }.disposed(by: disposeBag)
        
        
        
        //Maybe
        //介于Single和Completable之间，要么只能发出一个元素，要么产生一个completed事件，要么产生一个error事件。
        //适用于：可能需要发出一个元素，也可能不需要发出的情况。
        //MaybeEvent是一个枚举：
        /*
         enum MaybeEvent<Element> {
             case success<Element>
             case error(Swift.Error)
             case completed
         }
         **/
        enum StringError: Error {
            case failedGenerate
        }
        
        func generateString() -> Maybe<String> {
            return Maybe<String>.create { maybe in
                //成功并发出一个元素
                maybe(.success("manofit"))
                //成功但是不发出元素
                maybe(.completed)
                //失败
                maybe(.error(StringError.failedGenerate))
                
                return Disposables.create {
                }
            }
        }
        //使用
        generateString().subscribe {maybe in
            switch maybe {
            case .success(let element):
                print("\(element)")
            case .completed:
                print("执行完成，但是没有任何元素")
            case .error(let error):
                print("\(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
        //也可以
        generateString().subscribe(onSuccess: { (element) in
            print("\(element)")
        }, onError: { (error) in
            print("\(error.localizedDescription)")
        }) {
            print("执行完成，但是没有任何元素")
        }.disposed(by: disposeBag)
        
        //可以使用asMaybe将Observable转换为Maybe
        Observable.of("1").asMaybe().subscribe({print($0)}).disposed(by: disposeBag)
        
        
    }


}
