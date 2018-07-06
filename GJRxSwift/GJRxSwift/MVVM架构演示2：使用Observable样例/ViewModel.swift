//
//  ViewModel.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/6.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxSwift
import Result

class ViewModel {
    //数据请求服务
    let networkService = GitHubNetworkService()
    
    //输入部分
    //查询行为
    fileprivate let searchAction: Observable<String>
    
    //输出部分
    //所有的查询结果
    let searchResult: Observable<GitHubRepositories>
    
    //查询结果里的资源列表
    let repositories: Observable<[GitHubRepository]>
    
    //清空结果动作
    let cleanResult: Observable<Void>
    
    //导航栏标题
    let navigationTitle: Observable<String>
    
    //ViewModel初始化（根据输入实现对应的输出）
    init(searchAction: Observable<String>) {
        self.searchAction = searchAction
        
        //生成查询结果序列
        self.searchResult = searchAction.filter { !$0.isEmpty } //如果输入为空则不发送请求了
            .flatMapLatest {
                GitHubProvider.rx.request(.repositories($0))
                    .filterSuccessfulStatusCodes()
                    .mapObject(GitHubRepositories.self)
                    .asObservable()
                    .catchError({ error in
                        print("发生错误：",error.localizedDescription)
                        return Observable<GitHubRepositories>.empty()
                    })
        }
        
        //或者将网路请求和数据转换独立出来成一个Service，直接通过这个Service获取需要的数据
        self.searchResult = searchAction.filter {!$0.isEmpty}.flatMapLatest(networkService.searchRepositories).share(replay: 1)
        
        //生成清空结果动作序列
        self.cleanResult = searchAction.filter {$0.isEmpty}.map {_ in Void()}
        
        //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
        self.repositories = Observable.of(searchResult.map {$0.items}, cleanResult.map {[]}).merge()
        
        //生成导航栏标题序列（如果查询到结果则范湖数量，如果是清空数据则返回默认标题）
        self.navigationTitle = Observable.of(searchResult.map {"共有\($0.totalCount)个结果"},cleanResult.map {"xxx.com"}).merge()
    }
}
