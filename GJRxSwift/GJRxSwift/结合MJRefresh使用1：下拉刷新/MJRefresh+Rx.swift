//
//  MJRefresh+Rx.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/12.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshComponent {
    
    //正在刷新事件
    var refreshing: ControlEvent<Void> {
        let source:Observable<Void> = Observable.create {
            [weak control = self.base] observer in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) {
            refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}
