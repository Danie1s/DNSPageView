//
//  ViewController2.swift
//  Demo
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import DNSPageView

class ViewController2: UIViewController {

    @IBOutlet weak var titleView: PageTitleView!

    @IBOutlet weak var contentView: PageContentView!


    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // 创建PageStyle，设置样式
        let style = PageStyle()
        style.titleViewBackgroundColor = UIColor.red
        style.isShowCoverView = true

        // 设置标题内容
        let titles = ["头条", "视频", "娱乐", "要问", "体育"]

        // 设置默认的起始位置
        let startIndex = 2

        // 对titleView进行设置
        titleView.titles = titles
        titleView.style = style
        titleView.currentIndex = startIndex

        // 最后要调用setupUI方法
        titleView.setupUI()


        // 创建每一页对应的controller
        for i in 0..<titles.count {
            let controller = ContentViewController()
            controller.view.backgroundColor = UIColor.randomColor
            controller.index = i
            addChild(controller)
        }

        // 对contentView进行设置
        contentView.childViewControllers = children
        contentView.currentIndex = startIndex
        contentView.style = style

        // 最后要调用setupUI方法
        contentView.setupUI()

        // 让titleView和contentView进行联系起来
        titleView.delegate = contentView
        contentView.delegate = titleView
    }

}
