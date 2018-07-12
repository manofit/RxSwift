//
//  MJRefreshNetworkService.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/12.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


//网络请求服务
class MJRefreshNetworkService {
    
    //获取随机数据
    func getRandomResult() -> Driver<[String]> {
        let items = (0..<15).map {
            _ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable.delay(1, scheduler: MainScheduler.instance).asDriver(onErrorDriveWith: Driver.empty())
    }
}
