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

    private lazy var pageViewManager: DNSPageViewManager = {
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isShowBottomLine = true
        style.isTitleViewScrollEnabled = true
        style.titleViewBackgroundColor = UIColor.clear

        // 设置标题内容
        let titles = ["头条", "视频", "娱乐", "要问", "体育"]

        // 创建每一页对应的controller
        let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
            let controller = ContentViewController()
            controller.view.backgroundColor = UIColor.randomColor
            return controller
        }

        return DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        

        // 单独设置titleView的frame
        navigationItem.titleView = pageViewManager.titleView
        pageViewManager.titleView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)

        // 单独设置contentView的大小和位置，可以使用autolayout或者frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

    }


}
