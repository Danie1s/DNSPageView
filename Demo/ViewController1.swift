//
//  ViewController1.swift
//  Demo
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import DNSPageView

class ViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // 创建 PageStyle，设置样式
        let style = PageStyle()
        style.isTitleViewScrollEnabled = true
        style.titleMargin = 10
        style.titleInset = 20
        style.titleSelectedFont = UIFont.systemFont(ofSize: 20)
        style.userInterfaceLayoutDirection = .forceRightToLeft
//        style.isTitleScaleEnabled = true


        // 设置标题内容
        let titles = ["头条", "视频", "娱乐", "要问", "体育", "科技", "汽车", "时尚", "图片", "游戏", "房产"]

        // 创建每一页对应的 controller
        for i in 0..<titles.count {
            let controller = ContentViewController()
            controller.index = i
            controller.isRTL = style.isRTL
            addChild(controller)
        }

        let y = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        let size = UIScreen.main.bounds.size

        // 创建对应的 PageView，并设置它的 frame
        let pageView = PageView(frame: CGRect(x: 0, y: y, width: size.width, height: size.height - y),
                                style: style,
                                titles: titles,
                                childViewControllers: children,
                                currentIndex: 7)
        view.addSubview(pageView)
    }

}

