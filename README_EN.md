# DNSPageView

[![Version](https://img.shields.io/cocoapods/v/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![License](https://img.shields.io/cocoapods/l/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![Platform](https://img.shields.io/cocoapods/p/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)

DNSPageView is a light-weight and intuitive `PageView` framework. It could be initialized programmatically or by `storyboard` or `xib`, `titleView` and `contentView` are flexible to be layed out anywhere. It also provides some commonly used styles which could be easily configured.

__NOTE__: Please refer to [DNSPageView-ObjC](https://github.com/Danie1s/DNSPageView-ObjC) for Objective-C version

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)
  - [Initialize DNSPageView Programmatically](#直接使用dnspageview初始化)
  - [Initialize by xib or storyboard](#使用xib或者storyboard初始化)
  - [Initialize by DNSPageViewManager, then setup titleView and contentView's layout](#使用dnspageviewmanager初始化，再分别对titleview和contentview进行布局)
  - [Styles](#样式)
  - [Event Listener](#事件监听)
  - [FAQ](#常见问题)
- [License](#license)

## Features:

- [x] Easy to Use
- [x] Multiple Ways to Initialize 
- [x] Flexible Layout
- [x] Commonly Used Styles
- [x] Double Tap `titleView` Callback
- [x] `contentView` Scroll Listener

## Requirements

- iOS 8.0+

- Xcode 10.0+

- Swift 4.2+


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

### Initialize with DNSPageView

```swift
// Create DNSPageStyle
let style = DNSPageStyle()
style.isTitleViewScrollEnabled = true
style.isTitleScaleEnabled = true

// Setup titles
let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]

// Setup child controller for each title
let childViewControllers: [UIViewController] = titles.map { _ -> UIViewController in
    let controller = UIViewController()
    addChild(controller)
    return controller
}

let y = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
let size = UIScreen.main.bounds.size

// Setup DNSPageView and its frame
// titleView and contentView are connected
let pageView = DNSPageView(frame: CGRect(x: 0, y: 64, width: size.width, height: size.height), style: style, titles: titles, childViewControllers: childViewControllers)
view.addSubview(pageView)
```



### Initialize from xib or storyboard

Creat two `UIView` in `Xib` or `storyboard`, make them inherit from `DNSPageTitleView` and `DNSPageContentView`, drag them into controller class

```swift
@IBOutlet weak var titleView: DNSPageTitleView!

@IBOutlet weak var contentView: DNSPageContentView!
```

Setup `DNSPageTitleView` and `DNSPageContentView`

```swift
// Create DNSPageStyle
let style = DNSPageStyle()
style.titleViewBackgroundColor = UIColor.red
style.isShowCoverView = true

// Setup titles
let titles = ["头条", "视频", "娱乐", "要问", "体育"]

// Setup staring index
let startIndex = 2

// Setup titleView
titleView.titles = titles
titleView.style = style
titleView.currentIndex = startIndex

// At last, `setupUI()`
titleView.setupUI()


// Create child controller for each title
let childViewControllers: [UIViewController] = titles.map { _ -> UIViewController in
    let controller = UIViewController()
    addChild(controller)
    return controller
}

// Setup contentView
contentView.childViewControllers = childViewControllers
contentView.startIndex = startIndex
contentView.style = style

// Call `setupUI()`
contentView.setupUI()

// Setup delegate
titleView.delegate = contentView
contentView.delegate = titleView
```



### Initialize from DNSPageViewManager，then setup `titleView` and `contentView` layout

Create `DNSPageViewManager`

```swift
private lazy var pageViewManager: DNSPageViewManager = {
    // Create DNSPageStyle
    let style = DNSPageStyle()
    style.isShowBottomLine = true
    style.isTitleViewScrollEnabled = true
    style.titleViewBackgroundColor = UIColor.clear

    // Setup titles
    let titles = ["头条", "视频", "娱乐", "要问", "体育"]

    // Setup child controller for each title
    let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
        let controller = UIViewController()
        addChild(controller)
        return controller
    }

    return DNSPageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
}()
```

Setup layout of `titleView` and `contentView`

```swift
// Setup titleView's frame
navigationItem.titleView = pageViewManager.titleView
pageViewManager.titleView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)

// Setup contentView's size and position with either autolayout or frame
let contentView = pageViewManager.contentView
view.addSubview(pageViewManager.contentView)
contentView.snp.makeConstraints { (maker) in
    maker.edges.equalToSuperview()
}
```



### Styles

`DNSPageStyle` provides some commonly used styles. You can also configure it as your needs, e.g. setup starting index.



### Event Listener

DNSPageView提供了常见事件监听的代理，它属于`DNSPageTitleViewDelegate`的中的可选属性

```swift
/// DNSPageView的事件回调，如果有需要，请让对应的childViewController遵守这个协议
@objc public protocol DNSPageEventHandleable: class {
    
    /// 重复点击pageTitleView后调用
    @objc optional func titleViewDidSelectSameTitle()
    
    /// pageContentView的上一页消失的时候，上一页对应的controller调用
    @objc optional func contentViewDidDisappear()
    
    /// pageContentView滚动停止的时候，当前页对应的controller调用
    @objc optional func contentViewDidEndScroll()

}
```



### FAQ

- `style.isTitleViewScrollEnabled`

  如果标签比较少，建议设置`style.isTitleViewScrollEnabled = false`，`titleView`会固定，`style.titleMargin`不起作用，每个标签平分整个`titleView`的宽度，下划线的宽度等于标签的宽度。

  如果标签比较多，建议设置`style.isTitleViewScrollEnabled = true`，`titleView`会滑动，下划线的宽度随着标签文字的宽度变化而变化

- 标签下划线的宽度跟随文字的宽度

  设置`style.isTitleViewScrollEnabled = true`，可以参考demo中的第四种样式。

- 由于`DNSPageView`是基于`UIScrollView`实现，那么就无法避免它的一些特性：

  - 当控制器被`UINavigationController`管理，且`navigationBar.isTranslucent = true`的时候，当前控制器的`view`是从`y = 0`开始布局的，所以为了防止部分内容被`navigationBar`遮挡，系统默认会给`UIScrollView`添加offset。如果想取消这个特性：
    - iOS 11 以前，在控制器中设置`automaticallyAdjustsScrollViewInsets = false `
    - iOS 11 以后引入`SafeArea`概念，设置`UIScrollView`的属性`contentInsetAdjustmentBehavior = .never`
    - 其实这个效果还与`UIViewController`的其他属性有关系，但因为各种组合的情景过于复杂，所以不在此一一描述
  - `DNSPageContentView`用`UICollectionView`实现，所以这个特性有机会造成`UICollectionView`的高度小于它的`item`的高度，造成奇怪的Bug。
  - 以上只是可能出现的Bug之一，由于`Demo`不能覆盖所有的场景，不同的布局需求可能会引起不同的Bug，开发者需要明确了解自己的布局需求，注意细节，了解iOS布局特性，并且作出对应的调整，不能完全参照`Demo`。


## License

DNSPageView is available under the MIT license. See the LICENSE file for more info.


