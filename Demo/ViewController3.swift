//
//  ViewController3.swift
//  Demo
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import DNSPageView

class ViewController3: UIViewController {

    private lazy var pageViewManager: PageViewManager = {
        // 创建 PageStyle，设置样式
        let style = PageStyle()
        style.isShowBottomLine = true
        style.isTitleViewScrollEnabled = true
        style.titleViewBackgroundColor = UIColor.clear

        // 设置标题内容
        let titles = ["头条", "视频", "娱乐", "要问", "体育"]

        for i in 0..<titles.count {
            let controller = ContentViewController()
            controller.index = i
            controller.isRTL = style.isRTL
            addChild(controller)
        }

        return PageViewManager(style: style, titles: titles, childViewControllers: children)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // 单独设置 titleView 的 frame
        navigationItem.titleView = pageViewManager.titleView
        pageViewManager.titleView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)

        // 单独设置 contentView 的大小和位置，可以使用 autolayout 或者 frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        
        if #available(iOS 11, *) {
            contentView.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

    }


}
