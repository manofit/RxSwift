//
//  BindingExtensions.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/11.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

//扩展UILabel
extension Reactive where Base: UILabel {
    //让验证结果可以绑定到label上
    var validationResult: Binder<ValidationResult> {
        return Binder(base) {
            label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}
