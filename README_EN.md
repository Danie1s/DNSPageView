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
style.isTitleScrollEnable = true
style.isScaleEnable = true

// Setup titles
let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]

// Setup child controller for each title
let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
    let controller = ContentViewController()
    controller.view.backgroundColor = UIColor.randomColor
    return controller
}

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
let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
    let controller = ContentViewController()
    controller.view.backgroundColor = UIColor.randomColor
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
    style.isTitleScrollEnable = true
    style.titleViewBackgroundColor = UIColor.clear

    // Setup titles
    let titles = ["头条", "视频", "娱乐", "要问", "体育"]

    // Setup child controller for each title
    let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
        let controller = ContentViewController()
        controller.view.backgroundColor = UIColor.randomColor
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

`DNSPageView`提供了常见事件监听的代理，它属于DNSPageTitleViewDelegate的中的可选属性

```swift
/// If the `view` of `contentView` need to be refresed，please make its childViewController conform to the following protocol.
@objc public protocol DNSPageReloadable: class {
    
    /// If you want double tap to refresh feature
    @objc optional func titleViewDidSelectedSameTitle()
    
    /// 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
    @objc optional func contentViewDidEndScroll()
}
```



### FAQ

- When there's only a few titles，`titleView` would be scrollable.
  
  Recommend to set `style.isTitleViewScrollEnabled = false` when there's too many titles to avoid `titleView` scrolling.
  
  **In lastest version, even thought `style.isTitleViewScrollEnabled = true`, if there isn't too many titles, `titleView` won't be scrollable.**


- Make title bottom indicator line's width same as title text width

  when `style.isTitleViewScrollEnabled = false`, that indicates there isn't too many titles, by default each title's width shares `titleView`'s width, and bottom indicator line's width follows title text width, which is a commonly seen situation.

  If you want the title bottom indicator's with follow title text's, you need to set `style.isTitleViewScrollEnabled = true`, for more detail please refer to the forth style in the demo project.

- DNSPageView is built on `UIScrollView`, so it can't avoid inheriting some features from it:

  - When `navigationBar.isTranslucent = true`, layout starts from (0, 0), by default `iOS` will add offset for `UIScrollView`
  - Prior to iOS 11, `automaticallyAdjustsScrollViewInsets` would take effect
  - After iOS 11, we have `SafeArea`, `contentInsetAdjustmentBehavior` takes charge
  - `DNSPageContentView`用`UICollectionView`实现，所以这个特性有机会造成`UICollectionView`的高度小于`item`的高度，造成奇怪的bug
  - 开发者需要明确了解自己需要的布局是怎么样，并且作出对应的调整，注意相关的细节，不能完全参照`demo`


## License

DNSPageView is available under the MIT license. See the LICENSE file for more info.


