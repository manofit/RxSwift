//
//  MJRefreshHeaderAndFooterNetworkService.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class MJRefreshHeaderAndFooterNetworkService {
    func getRandomResult() -> Observable<[String]> {
        let items = (0..<15).map {_ in
            "随机数据\(Int(arc4random()))"
        }
        let observable = Observable.just(items)
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}
