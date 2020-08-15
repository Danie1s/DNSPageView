//
//  PageViewManager.swift
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

public protocol PageViewContainer: class {
    
    func updateCurrentIndex(_ index: Int)
}


/// 通过这个类创建的 pageView，titleView 和 contentView 的 frame 是不确定的，适合于 titleView 和 contentView 分开布局的情况
/// 需要给 titleView 和 contentView 布局，可以使用 frame 或者 Autolayout
public class PageViewManager {
        
    private (set) public var style: PageStyle
    private (set) public var titles: [String]
    private (set) public var childViewControllers: [UIViewController]
    private (set) public var currentIndex: Int
    public let titleView: PageTitleView
    public let contentView: PageContentView

    public init(style: PageStyle,
                titles: [String],
                childViewControllers: [UIViewController],
                currentIndex: Int = 0,
                titleView: PageTitleView? = nil,
                contentView: PageContentView? = nil) {
        
        assert(titles.count == childViewControllers.count,
               "titles.count != childViewControllers.count")
        assert(currentIndex >= 0 && currentIndex < titles.count,
               "currentIndex < 0 or currentIndex >= titles.count")

        self.style = style
        self.titles = titles
        self.childViewControllers = childViewControllers
        self.currentIndex = currentIndex
        
        if let titleView = titleView {
            self.titleView = titleView
            self.titleView.configure(titles: titles, style: style, currentIndex: currentIndex)
        } else {
            self.titleView = PageTitleView(frame: .zero, style: style, titles: titles, currentIndex: currentIndex)
        }
        if let contentView = contentView {
            self.contentView = contentView
            self.contentView.configure(childViewControllers: childViewControllers, style: style, currentIndex: currentIndex)
        } else {
            self.contentView = PageContentView(frame: .zero, style: style, childViewControllers: childViewControllers, currentIndex: currentIndex)
        }
        self.titleView.container = self
        self.contentView.container = self
        self.titleView.delegate = self.contentView
        self.contentView.delegate = self.titleView
    }
    
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

extension PageViewManager: PageViewContainer {
    public func updateCurrentIndex(_ index: Int) {
        currentIndex = index
    }
}
