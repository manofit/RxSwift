//
//  UserRegisterService.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/11.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


//将用户名，密码的各种验证封装起来，返回ValidationResult，里面需要用到上面封装的UserRegisterNetworkService
class UserRegisterService {
    
    //密码最少位数
    let minPasswordCount = 5
    
    //网路请求服务
    lazy var networkService = {
        return UserRegisterNetworkService()
    }()
    
    //验证用户名
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        //判断用户名是否为空
        if username.isEmpty {
            return .just(.empty)
        }
        
        //判断用户名是否只有数字和字母
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "用户名只能包含数字和字母"))
        }
        
        //发起网络请求检查用户名是否已经存在
        return networkService.userNameAvailable(username).map {
            available in
            //根据查询情况返回不同的验证结果
            if available {
                return .ok(message: "用户名可用")
            }else{
                return .failed(message: "用户名已存在")
            }
        }.startWith(.validating) //在发起网络请求前，先返回一个“正在检查”的验证结果
    }
    
    //验证密码
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        
        //判断密码是否为空
        if numberOfCharacters == 0 {
            return .empty
        }
        
        //判断密码位数
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "密码至少需要 \(minPasswordCount) 个字符")
        }
        
        //返回验证成功的结果
        return .ok(message: "密码有效")
    }
    
    //验证二次密码输入的结果
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        //判断密码是否为空
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        //判断两个输入的密码是否一致
        if password == repeatedPassword {
            return .ok(message: "密码有效")
        }else{
            return .failed(message: "两次输入的密码不一致")
        }
    }
    
    
}
