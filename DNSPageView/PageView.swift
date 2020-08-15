//
//  PageView.swift
//  DNSPageView
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018 Daniels. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit


/// 通过这个类创建的 pageView，默认 titleView 和 contentView 连在一起，效果类似于网易新闻
/// 只能用代码创建，不能在 xib 或者 storyboard 里面使用
public class PageView: UIView {
    
    private (set) public var style: PageStyle
    private (set) public var titles: [String]
    private (set) public var childViewControllers: [UIViewController]
    private (set) public var currentIndex: Int
    public let titleView: PageTitleView
    public let contentView: PageContentView

    public init(frame: CGRect,
                style: PageStyle,
                titles: [String],
                childViewControllers: [UIViewController],
                currentIndex: Int = 0) {
        assert(titles.count == childViewControllers.count,
               "titles.count != childViewControllers.count")
        assert(currentIndex >= 0 && currentIndex < titles.count,
               "currentIndex < 0 or currentIndex >= titles.count")
        self.style = style
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.currentIndex = currentIndex
        self.titleView = PageTitleView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: frame.width,
                                                     height: style.titleViewHeight),
                                       style: style,
                                       titles: titles,
                                       currentIndex: currentIndex)
        self.contentView = PageContentView(frame: CGRect(x: 0,
                                                         y: style.titleViewHeight,
                                                         width: frame.width,
                                                         height: frame.height - style.titleViewHeight),
                                           style: style,
                                           childViewControllers: childViewControllers,
                                           currentIndex: currentIndex)

        super.init(frame: frame)

        addSubview(titleView)
        addSubview(contentView)
        titleView.container = self
        contentView.container = self
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageView {
    public func configure(titles: [String]? = nil,
                          childViewControllers: [UIViewController]? = nil,
                          style: PageStyle? = nil) {
        if let titles = titles {
           self.titles = titles
        }
        if let childViewControllers = childViewControllers {
           self.childViewControllers = childViewControllers
        }
        if let style = style {
           self.style = style
        }
        assert(self.titles.count == self.childViewControllers.count,
               "titles.count != childViewControllers.count")
        assert(currentIndex >= 0 && currentIndex < self.titles.count,
                 "currentIndex < 0 or currentIndex >= titles.count")
        titleView.configure(titles: titles, style: style)
        contentView.configure(childViewControllers: childViewControllers, style: style)
    }
}


extension PageView: PageViewContainer {
    public func updateCurrentIndex(_ index: Int) {
        currentIndex = index
    }
}
