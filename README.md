# DNSPageView

[![Version](https://img.shields.io/cocoapods/v/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![License](https://img.shields.io/cocoapods/l/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![Platform](https://img.shields.io/cocoapods/p/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)

[English Introduction](https://github.com/Danie1s/DNSPageView/blob/master/README_EN.md)

DNSPageView 一个纯 Swift 的轻量级、灵活且易于使用的 `PageView` 框架，`titleView` 和 `contentView` 可以布局在任意地方，可以纯代码初始化，也可以使用 `xib` 或者 `storyboard` 初始化，并且提供了常见样式属性进行设置。

如果你使用的开发语言是 Objective-C，请使用 [DNSPageView-ObjC](https://github.com/Danie1s/DNSPageView-ObjC)

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)
  - [直接使用 PageView 初始化](#直接使用-pageview-初始化)
  - [使用 xib 或者 storyboard 初始化](#使用-xib-或者-storyboard-初始化)
  - [使用 PageViewManager 初始化](#使用-pageviewmanager-初始化)
  - [样式 ](#样式)
  - [事件回调](#事件回调)
  - [常见问题](#常见问题)
- [License](#license)

## Features:

- [x] 使用简单
- [x] 多种初始化方式
- [x] 灵活布局
- [x] 常见的样式
- [x] 双击 `titleView` 的回调
- [x] `contentView` 滑动监听
- [x] 适配 iOS 13 Dark Mode
- [x] 动态改变样式

## Requirements

- iOS 8.0+
- Xcode 10.2+
- Swift 5.0+


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build DNSPageView.

To integrate DNSPageView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'DNSPageView'
end
```

Then, run the following command:

```bash
$ pod install
```


### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate DNSPageView into your project manually.



## Example

To run the example project, clone the repo, and run `DNSPageView.xcodeproj` .

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/1.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/2.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/3.gif" width="30%" height="30%">

<img src="https://github.com/Danie1s/DNSPageView/blob/master/Images/4.gif" width="30%" height="30%">





## Usage

### 直接使用 PageView 初始化

```swift
// 创建 PageStyle，设置样式
let style = PageStyle()
style.isTitleViewScrollEnabled = true
style.isTitleScaleEnabled = true

// 设置标题内容
let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]

// 创建每一页对应的 controller
let childViewControllers: [UIViewController] = titles.map { _ -> UIViewController in
    let controller = UIViewController()
    addChild(controller)
    return controller
}

let y = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
let size = UIScreen.main.bounds.size

// 创建对应的 PageView，并设置它的 frame
// titleView 和 contentView 会连在一起
let pageView = PageView(frame: CGRect(x: 0, y: y, width: size.width, height: size.height - y), style: style, titles: titles, childViewControllers: childViewControllers)
view.addSubview(pageView)
```



### 使用 xib 或者 storyboard 初始化

 在 `xib` 或者 `storyboard` 中拖出 2 个 `UIView`，让它们分别继承 `PageTitleView` 和 `PageContentView`，拖线到代码中

```swift
@IBOutlet weak var titleView: PageTitleView!

@IBOutlet weak var contentView: PageContentView!
```

对 PageTitleView 和 PageContentView 进行设置

```swift
// 创建 PageStyle，设置样式
let style = PageStyle()
style.titleViewBackgroundColor = UIColor.red
style.isShowCoverView = true

// 设置标题内容
let titles = ["头条", "视频", "娱乐", "要问", "体育"]

// 设置默认的起始位置
let startIndex = 2


// 创建每一页对应的 controller
let childViewControllers: [UIViewController] = titles.map { _ -> UIViewController in
    let controller = UIViewController()
    addChild(controller)
    return controller
}

// 创建 PageViewManager 来设置它们的样式和布局
let pageViewManager = PageViewManager(style: style,
                                  titles: titles,
                                  childViewControllers: children,
                                  currentIndex: currentIndex,
                                  titleView: titleView,
                                  contentView: contentView)
```



### 使用 PageViewManager 初始化
创建 PageViewManager

```swift
private lazy var pageViewManager: PageViewManager = {
    // 创建 PageStyle，设置样式
    let style = PageStyle()
    style.isShowBottomLine = true
    style.isTitleViewScrollEnabled = true
    style.titleViewBackgroundColor = UIColor.clear

    // 设置标题内容
    let titles = ["头条", "视频", "娱乐", "要问", "体育"]

    // 创建每一页对应的 controller
    let childViewControllers: [UIViewController] = titles.map { _ -> UIViewController in
        let controller = UIViewController()
        addChild(controller)
        return controller
    }

    return PageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
}()
```

布局 titleView 和 contentView

```swift
// 单独设置 titleView 的 frame
navigationItem.titleView = pageViewManager.titleView
pageViewManager.titleView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)

// 单独设置 contentView 的大小和位置，可以使用 autolayout 或者 frame
let contentView = pageViewManager.contentView
view.addSubview(pageViewManager.contentView)
contentView.snp.makeConstraints { (maker) in
    maker.edges.equalToSuperview()
}
```



### 样式

`PageStyle` 中提供了常见样式的属性，可以按照不同的需求进行设置，包括可以设置初始显示的页面



### 事件回调

DNSPageView 提供了常见事件监听回调，它属于 `PageTitleViewDelegate` 的中的可选属性

```swift
/// DNSPageView 的事件回调，如果有需要，请让对应的 childViewController 遵守这个协议
@objc public protocol PageEventHandleable: class {
    
    /// 重复点击 pageTitleView 后调用
    @objc optional func titleViewDidSelectSameTitle()
    
    /// pageContentView 的上一页消失的时候，上一页对应的 controller 调用
    @objc optional func contentViewDidDisappear()
    
    /// pageContentView 滚动停止的时候，当前页对应的 controller 调用
    @objc optional func contentViewDidEndScroll()

}
```



### 常见问题

- `style.isTitleViewScrollEnabled`

  如果 `titles` 的数量比较少，建议设置 `style.isTitleViewScrollEnabled = false`，`titleView` 会固定，`style.titleMargin` 不起作用，每个 `title` 平分整个 `titleView` 的宽度，下划线的宽度等于`title` 的宽度。

  如果标签比较多，建议设置 `style.isTitleViewScrollEnabled = true`，`titleView` 会滑动，下划线的宽度随着 `title` 文字的宽度变化而变化

- 标签下划线的宽度跟随文字的宽度

  设置 `style.isTitleViewScrollEnabled = true`，可以参考 `Demo` 中的第四种样式。

- 由于 `DNSPageView` 是基于 `UIScrollView` 实现，那么就无法避免它的一些特性：

  - 当控制器被 `UINavigationController` 管理，且 `navigationBar.isTranslucent = true` 的时候，当前控制器的 `view` 是从 `y = 0` 开始布局的，所以为了防止部分内容被 `navigationBar` 遮挡，系统默认会给 `UIScrollView` 添加 offset。如果想取消这个特性：
    - iOS 11 以前，在控制器中设置 `automaticallyAdjustsScrollViewInsets = false `
    - iOS 11 以后引入 `SafeArea` 概念，设置 `UIScrollView` 的属性 `contentInsetAdjustmentBehavior = .never`
    - 其实这个效果还与 `UIViewController` 的其他属性有关系，但因为各种组合的情景过于复杂，所以不在此一一描述

  - `PageContentView` 用 `UICollectionView` 实现，所以这个特性有机会造成 `UICollectionView` 的经典警告：

    > The behavior of the UICollectionViewFlowLayout is not defined because:
    >
    > the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values

    从而引发一些 Bug

  - 以上只是可能出现的 Bug 之一，由于 `Demo` 不能覆盖所有的场景，不同的布局需求可能会引起不同的 Bug，开发者需要明确了解自己的布局需求，注意细节，了解 iOS 布局特性，并且作出对应的调整，不能完全参照 `Demo`。


## License

DNSPageView is available under the MIT license. See the LICENSE file for more info.


