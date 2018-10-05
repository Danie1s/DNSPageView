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

    private lazy var titles = ["头条", "视频"]

    private lazy var pageViewManager: DNSPageViewManager = {
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isShowBottomLine = true
        style.isTitleViewScrollEnabled = true
        style.titleViewBackgroundColor = UIColor.clear
        style.titleColor = UIColor.gray
        style.titleSelectedColor = UIColor.black
        style.bottomLineColor = UIColor(red: 0 / 255, green: 143 / 255, blue: 223 / 255, alpha: 1.0)

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


        let titleView = pageViewManager.titleView
        view.addSubview(titleView)
        let margin = pageViewManager.style.titleMargin

        // 计算titleView需要的宽度
        // 如果style.isTitleScrollEnable = false，则不需要计算宽度，但是titleView的下划线会平分titleView的宽度
        let width: CGFloat = titles.reduce(0) { (width, title) -> CGFloat in
            width + (title as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : pageViewManager.style.titleFont], context: nil).width + margin
        }

        // 单独设置titleView的大小和位置，可以使用autolayout或者frame
        titleView.snp.makeConstraints { (maker) in
            if #available(iOS 11.0, *) {
                maker.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                maker.top.equalTo(topLayoutGuide.snp.bottom)
            }
            maker.leading.equalToSuperview()
            maker.width.equalTo(width)
            maker.height.equalTo(44)
        }

        // 单独设置contentView的大小和位置，可以使用autolayout或者frame
        let contentView = pageViewManager.contentView
        view.addSubview(pageViewManager.contentView)
        contentView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }

    }

}
