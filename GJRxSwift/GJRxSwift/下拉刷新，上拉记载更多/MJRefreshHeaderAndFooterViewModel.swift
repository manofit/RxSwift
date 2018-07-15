//
//  MJRefreshHeaderAndFooterViewModel.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/15.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class MJRefreshHeaderAndFooterViewModel {
    
    //列表数据序列
    let tableData = BehaviorRelay<[String]>(value: [])
    
    //停止头部刷新状态
    let endHeaderRefreshing: Observable<Bool>
    
    //停止尾部刷新状态
    let endFooterRefreshing: Observable<Bool>
    
    //viewModel初始化
    init(input: (headerRefresh: Observable<Void>, footerRefresh: Observable<Void>), dependency: (disposeBag: DisposeBag, networkService: MJRefreshHeaderAndFooterNetworkService)) {
        
        //下拉结果序列
        let headerRefreshData = input.headerRefresh.startWith(()).flatMapLatest { _ in
            dependency.networkService.getRandomResult().takeUntil(input.footerRefresh)
        }.share(replay: 1)
        
        //上拉结果序列
        let footerRefreshData = input.footerRefresh.flatMapLatest { _ in
            dependency.networkService.getRandomResult().takeUntil(input.headerRefresh)
        }.share(replay: 1)
        
        //生成停止头部刷新状态序列
        self.endHeaderRefreshing = Observable.merge(
            headerRefreshData.map { _ in true},
            input.headerRefresh.map { _ in true}
        )
        
        //生成停止尾部刷新状态序列
        self.endFooterRefreshing = Observable.merge(
            footerRefreshData.map {_ in true},
            input.headerRefresh.map { _ in true}
        )
        
        //下拉刷新时，直接将查询到的结果替换原数据
        headerRefreshData.subscribe(onNext: { items in
            self.tableData.accept(items)
        }).disposed(by: dependency.disposeBag)
        
        //上拉加载时，将查询到的结果拼接到原数据底部
        footerRefreshData.subscribe(onNext: { items in
            self.tableData.accept(self.tableData.value + items)
        }).disposed(by: dependency.disposeBag)
    }
}
