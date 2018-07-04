//
//  UICollectionViewViewController.swift
//  GJRxSwift
//
//  Created by 高军 on 2018/7/4.
//  Copyright © 2018年 Jun Gao. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UICollectionViewViewController: UIViewController {
    
    var collectionView:UICollectionView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "UICollectionView的使用1：基本用法"
        view.backgroundColor = UIColor.white
        
        
        let flowLauout = UICollectionViewFlowLayout()
        flowLauout.itemSize = CGSize(width:100, height:70)
        
        collectionView = UICollectionView.init(frame: view.frame, collectionViewLayout: flowLauout)
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        
        //初始化数据
        let items = Observable.just([
            "swift",
            "php",
            "js",
            "python",
            "c"
        ])
        
        //设置单元格数据
        items.bind(to: collectionView.rx.items) {(collectionView, row, element) in
            let indexPath = IndexPath(row:row, section:0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(row):\(element)"
            return cell
        }.disposed(by: disposeBag)
        
        //获取选中项的索引
        collectionView.rx.itemSelected.subscribe(onNext: {indexPath in
            print("\(indexPath)")
        }).disposed(by: disposeBag)
        
        //获取选中项的内容
        collectionView.rx.modelSelected(String.self).subscribe(onNext: {item in
            print("\(item)")
        }).disposed(by: disposeBag)
        
        //同时获取索引和内容
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(String.self)).bind {[weak self] indexPath, item in
            print("\(indexPath)")
            print("\(item)")
        }.disposed(by: disposeBag)
        
        //同时获取单元格取消选中索引和内容
        Observable.zip(collectionView.rx.itemDeselected, collectionView.rx.modelDeselected(String.self)).bind {[weak self] indexPath, item in
            print("\(indexPath)")
            print("\(item)")
        }
        
        //单元格将要显示出来的事件响应
        collectionView.rx.willDisplayCell.subscribe(onNext: {cell, indexPath in
            print("\(indexPath)")
            print("\(cell)")
        }).disposed(by: disposeBag)
        
        //分区头部或者尾部将要显示出来的事件响应
        collectionView.rx.willDisplaySupplementaryView.subscribe(onNext: {view, kind, indexPath in
            print("将要显示分区indexPath为：\(indexPath)")
            print("将要显示的是头部还是尾部：\(kind)")
            print("将要显示头部或尾部视图：\(view)\n")
        }).disposed(by: disposeBag)
        
    }


}
