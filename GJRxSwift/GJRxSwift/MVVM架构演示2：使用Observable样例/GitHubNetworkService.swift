//
//  GitHubNetworkService.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/6.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper


class GitHubNetworkService {
    
    //搜索资源数据
    func searchRepositories(query:String) -> Observable<GitHubRepositories> {
        return GitHubProvider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .mapObject(GitHubRepositories.self)
            .asObservable()
            .catchError({ error in
                print("发生错误：",error.localizedDescription)
                return Observable<GitHubRepositories>.empty()
            })
    }
}
