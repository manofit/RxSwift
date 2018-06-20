//
//  ViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/6/7.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    struct Project {
        let title:String
        
        init(title:String) {
            self.title = title
        }
    }
    
    struct ProjectListModel {
        let data = Observable.just([
            Project(title:"Observable介绍、创建可观察序列"),
            Project(title:"Observable订阅、事件监听、订阅销毁"),
            Project(title:"观察者1： AnyObserver、Binder"),
            Project(title:"观察者2： 自定义可绑定属性"),
            Project(title:"Subjects、Variables"),
            Project(title:"变换操作符：buffer、map、flatMap、scan等"),
            Project(title:"过滤操作符：filter、take、skip等"),
            Project(title:"条件和布尔操作符：amb、takeWhile、skipWhile等"),
            Project(title:"结合操作符：startWith、merge、zip等"),
            Project(title:"算数&聚合操作符：toArray、reduce、concat"),
            Project(title:"连接操作符：connect、publish、replay、multicast"),
            Project(title:"其他操作符：delay、materialize、timeout等"),
            Project(title:"错误处理"),
            Project(title:"调试操作"),
            Project(title:"特征序列1：Single、Completable、Maybe"),
            Project(title:"特征序列2：Driver"),
            Project(title:"特征序列3：ControlProperty、 ControlEvent"),
            Project(title:"给 UIViewController 添加 RxSwift 扩展"),
            Project(title:"调度器、subscribeOn、observeOn"),
            Project(title:"UI控件扩展1：UILabel"),
            Project(title:"UI控件扩展2：UITextField、UITextView"),
            Project(title:"UI控件扩展3：UIButton、UIBarButtonItem"),
        ])
    }
    
    lazy var tableView:UITableView? = {
        let tableView = UITableView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height), style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "projectCell")
        return tableView
    }()
    
    let projectListModel = ProjectListModel()
    
    //负责销毁对象
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "RxSwift"
        
        view.addSubview(tableView!)
        //将数据源绑定到tableview上
        projectListModel.data.bind(to: (tableView?.rx.items(cellIdentifier: "projectCell"))!) {_, project, cell in
            cell.textLabel?.text = project.title
        }.disposed(by: disposeBag)
        
        //tableView点击响应
        tableView?.rx.itemSelected.subscribe(onNext : {indexPath in
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(ObservableIntroduceCreateViewController(), animated: true)
            }else if indexPath.row == 1 {
                self.navigationController?.pushViewController(ObservableSubscribeDoonDisposeViewController(), animated: true)
            }else if indexPath.row == 2 {
                self.navigationController?.pushViewController(AnyObserverBinderViewController(), animated: true)
            }else if indexPath.row == 3 {
                self.navigationController?.pushViewController(CustomBindablePropertyViewController(), animated: true)
            }else if indexPath.row == 4 {
                self.navigationController?.pushViewController(SubjectsVariablesViewController(), animated: true)
            }else if indexPath.row == 5 {
                self.navigationController?.pushViewController(BufferMapFlatMapScanViewController(), animated: true)
            }else if indexPath.row == 6 {
                self.navigationController?.pushViewController(FilterTakeSkipViewController(), animated: true)
            }else if indexPath.row == 7 {
                self.navigationController?.pushViewController(AmbTakeWhileSkipWhileViewController(), animated: true)
            }else if indexPath.row == 8 {
                self.navigationController?.pushViewController(StartWithMergeZipViewController(), animated: true)
            }else if indexPath.row == 9 {
                self.navigationController?.pushViewController(ToArrayReduceConcatViewController(), animated: true)
            }else if indexPath.row == 10 {
                self.navigationController?.pushViewController(ConnectPublishReplayMulticastViewController(), animated: true)
            }else if indexPath.row == 11 {
                self.navigationController?.pushViewController(DelayMaterializeTimeoutViewController(), animated: true)
            }else if indexPath.row == 12 {
                self.navigationController?.pushViewController(ErrorHandlerViewController(), animated: true)
            }else if indexPath.row == 13 {
                self.navigationController?.pushViewController(DebuggingViewController(), animated: true)
            }else if indexPath.row == 14 {
                self.navigationController?.pushViewController(SingleCompletableMaybeViewController(), animated: true)
            }else if indexPath.row == 15 {
                self.navigationController?.pushViewController(DriverViewController(), animated: true)
            }else if indexPath.row == 16 {
                self.navigationController?.pushViewController(ControlPropetyControlEventViewController(), animated: true)
            }else if indexPath.row == 17 {
                self.navigationController?.pushViewController(UIViewControllerRxExtendViewController(coder: NSCoder())!, animated: true)
            }else if indexPath.row == 18 {
                self.navigationController?.pushViewController(SubscribeOnObserveOnViewController(), animated: true)
            }else if indexPath.row == 19 {
                self.navigationController?.pushViewController(UILabelViewController(), animated: true)
            }else if indexPath.row == 20 {
                self.navigationController?.pushViewController(UITextFieldUITextViewViewController(), animated: true)
            }else if indexPath.row == 21 {
                self.navigationController?.pushViewController(UIButtonUIBarButtonItemViewController(), animated: true)
            }
        }).disposed(by: disposeBag)
    }

}

