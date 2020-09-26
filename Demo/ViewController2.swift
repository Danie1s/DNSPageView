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
    
    private var pageViewManager: PageViewManager?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // 创建 PageStyle，设置样式
        let style = PageStyle()
        style.titleViewBackgroundColor = UIColor.red
        style.isShowCoverView = true

        // 设置标题内容
        let titles = ["头条", "视频", "娱乐", "要问", "体育"]

        // 设置默认的起始位置
        let currentIndex = 2


        // 创建每一页对应的 controller
        for i in 0..<titles.count {
            let controller = ContentViewController()
            controller.index = i
            controller.isRTL = style.isRTL
            addChild(controller)
        }

        pageViewManager = PageViewManager(style: style,
                                          titles: titles,
                                          childViewControllers: children,
                                          currentIndex: currentIndex,
                                          titleView: titleView,
                                          contentView: contentView)
        
    }
}
