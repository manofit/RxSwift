//
//  GitHubAPI.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/6.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import Moya



//初始化github请求的provider
let GitHubProvider = MoyaProvider<GitHubAPI>()

//请求分类
public enum GitHubAPI {
    case repositories(String)
}

//请求配置
extension GitHubAPI: TargetType {
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String : String]? {
        return nil
    }
    
    //服务器地址
    public var baseURL: URL {
        return URL(string:"https://api.github.com")!
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        print("发起请求")
        switch self {
        case .repositories(let query):
            var params: [String:Any] = [:]
            params["q"] = query
            params["sort"] = "stars"
            params["order"] = "desc"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //是否执行Alamofire验证
    public var vilidate: Bool {
        return false
    }
    
    
}
