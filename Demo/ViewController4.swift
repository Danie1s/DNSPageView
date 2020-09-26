//
//  ViewController4.swift
//  Demo
//
//  Created by Daniels on 2018/9/16.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import DNSPageView

class ViewController4: UIViewController {

    private lazy var pageViewManager: PageViewManager = {
        // 创建 PageStyle，设置样式
        let style = PageStyle()
        style.isShowBottomLine = true
        style.isTitleViewScrollEnabled = true
        style.titleViewBackgroundColor = UIColor.clear
        style.userInterfaceLayoutDirection = .forceRightToLeft
        // 适配 dark mode
        if #available(iOS 13.0, *) {
            style.titleSelectedColor = UIColor.dns.dynamic(UIColor.red, dark: UIColor.blue)
            style.titleColor = UIColor.dns.dynamic(UIColor.green, dark: UIColor.orange)
        } else {
            style.titleSelectedColor = UIColor.black
            style.titleColor = UIColor.gray
        }
        style.bottomLineColor = UIColor(red: 0 / 255, green: 143 / 255, blue: 223 / 255, alpha: 1.0)
        style.bottomLineWidth = 20

        let titles = ["微信支付", "支付宝"]
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
        if #available(iOS 11, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        let titleView = pageViewManager.titleView
        view.addSubview(titleView)


        // 单独设置 titleView 的大小和位置，可以使用 autolayout 或者 frame
        titleView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                maker.top.equalTo(topLayoutGuide.snp.bottom)
            }
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(44)
        }

        // 单独设置 contentView 的大小和位置，可以使用 autolayout 或者 frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }

}
