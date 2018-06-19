//
//  UIViewController+RxSwift.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/19.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

//我们对 UIViewController 进行扩展：1.将 viewDidLoad、viewDidAppear、viewDidLayoutSubviews 等各种 ViewController 生命周期的方法转成 ControlEvent 方便在 RxSwift 项目中使用。2.增加 isVisible 序列属性，方便对视图的显示状态进行订阅。3.增加 isDismissing 序列属性，方便对视图的释放进行订阅。

public extension Reactive where Base : UIViewController {
    
    public var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewWillAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
    
    public var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
    
    public var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLayoutSubviews))
            .map { _ in }
        return ControlEvent(events: source)
    }
    
    public var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.willMove))
            .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    public var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = self.methodInvoked(#selector(Base.didMove))
            .map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    
    public var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.didReceiveMemoryWarning))
            .map { _ in }
        return ControlEvent(events: source)
    }
    
    //表示视图是否显示的可观察序列，当VC显示状态变化时会触发
    public var isVisible: Observable<Bool> {
        let viewDidAppearObserable = self.base.rx.viewDidAppear.map { _ in true}
        let viewWillDisappearObserable = self.base.rx.viewWillDisappear.map { _ in false}
        return Observable<Bool>.merge(viewDidAppearObserable, viewWillDisappearObserable)
    }
    
    //表示页面被释放的可观察序列，当VC被dismiss时会触发
    public var isDismissing: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(Base.dismiss)).map {$0.first as? Bool ?? false}
        return ControlEvent(events: source)
    }
}
