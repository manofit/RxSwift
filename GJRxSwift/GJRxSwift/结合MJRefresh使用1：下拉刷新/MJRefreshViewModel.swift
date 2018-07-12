//
//  MJRefreshViewModel.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/12.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


class MJRefreshViewModel {
    
    //表格数据列表
    let tableData: Driver<[String]>
    
    //停止刷新状态序列
    let endHeaderRefreshing: Driver<Bool>
    
    init(headerRefresh: Driver<Void>) {
        //网络请求服务
        let networkService = MJRefreshNetworkService()
        
        //生成查询结果序列
        self.tableData = headerRefresh.startWith(())//初始化完毕时候会自动加载一次数据
            .flatMapLatest{ _ in networkService.getRandomResult()}
        
        //停止刷新序列
        self.endHeaderRefreshing = self.tableData.map { _ in true}
    }
}
