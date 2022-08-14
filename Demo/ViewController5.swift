//
//  ViewController5.swift
//  Demo
//
//  Created by Daniels on 2020/8/15.
//  Copyright © 2020 Daniels. All rights reserved.
//

import UIKit
import DNSPageView

class ViewController5: UIViewController {

    var changed = false
    
    private lazy var pageViewManager: PageViewManager = {
        // 创建 PageStyle，设置样式
        let style = PageStyle()
        style.isShowBottomLine = true
        style.isTitleViewScrollEnabled = true
        style.titleViewBackgroundColor = UIColor.clear
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

        let titles = ["NBA", "CBA", "英雄联盟", "王者荣耀", "中国足球", "国际足球"]
        for i in 0..<titles.count {
            let controller = ContentViewController()
            controller.index = i
            controller.isRTL = style.isRTL
            addChild(controller)
        }

        return PageViewManager(style: style, titles: titles, childViewControllers: children, currentIndex: 3)
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
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "改变",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(change))
        
    }
    
    @objc func change() {
        changeTitle()
        
//        changeTitles()
        
//        changeAll()
    }
    
    func changeTitle() {
        if !changed {
            pageViewManager.titleView.updateTitle("JavaScript", at: 3)
        } else {
            pageViewManager.titleView.updateTitle("王者荣耀", at: 3)
        }
        changed.toggle()
    }
    
    func changeTitles() {
        if !changed {
            let titles = ["Swift", "Objective-C", "JavaScript", "Python", "C++", "Go"]
            pageViewManager.configure(titles: titles)
        } else {
            let titles = ["NBA", "CBA", "英雄联盟", "王者荣耀", "中国足球", "国际足球"]
            pageViewManager.configure(titles: titles)
        }
        changed.toggle()
    }
    
    func changeAll() {
        if !changed {
            let style = PageStyle()
            style.titleViewBackgroundColor = UIColor.red
            style.isShowCoverView = true
            style.isTitleViewScrollEnabled = true
            
            let titles = ["头条", "视频", "娱乐", "要问", "体育", "科技", "汽车", "时尚", "图片", "游戏", "房产"]
            children.forEach { $0.removeFromParent() }
            for i in 0..<titles.count {
                let controller = ContentViewController()
                controller.index = i
                controller.isRTL = style.isRTL
                addChild(controller)
            }
            pageViewManager.configure(titles: titles, childViewControllers: self.children, style: style)
        } else {
            let style = PageStyle()
            style.isShowBottomLine = true
            style.isTitleViewScrollEnabled = true
            style.titleViewBackgroundColor = UIColor.clear
            if #available(iOS 13.0, *) {
                style.titleSelectedColor = UIColor.dns.dynamic(UIColor.red, dark: UIColor.blue)
                style.titleColor = UIColor.dns.dynamic(UIColor.green, dark: UIColor.orange)
            } else {
                style.titleSelectedColor = UIColor.black
                style.titleColor = UIColor.gray
            }
            style.bottomLineColor = UIColor(red: 0 / 255, green: 143 / 255, blue: 223 / 255, alpha: 1.0)
            style.bottomLineWidth = 20

            let titles = ["NBA", "CBA", "英雄联盟", "王者荣耀", "中国足球", "国际足球"]
            children.forEach { $0.removeFromParent() }
            for i in 0..<titles.count {
                let controller = ContentViewController()
                controller.index = i
                controller.isRTL = style.isRTL
                addChild(controller)
            }
            pageViewManager.configure(titles: titles, childViewControllers: self.children, style: style)
        }
        changed.toggle()
    }

}
