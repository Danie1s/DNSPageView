# DNSPageView

[![Version](https://img.shields.io/cocoapods/v/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![License](https://img.shields.io/cocoapods/l/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)
[![Platform](https://img.shields.io/cocoapods/p/DNSPageView.svg?style=flat)](http://cocoapods.org/pods/DNSPageView)

[中文说明](https://github.com/Danie1s/DNSPageView/blob/master/README.md)

DNSPageView is a light-weight and intuitive `PageView` framework. It could be initialized programmatically or by `storyboard` or `xib`, `titleView` and `contentView` are flexible to be layed out anywhere. It also provides some commonly used styles which could be easily configured.

__NOTE__: Please refer to [DNSPageView-ObjC](https://github.com/Danie1s/DNSPageView-ObjC) for Objective-C version

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)
  - [Initialize with PageView](#initialize-with-pageview)
  - [Initialize from xib or storyboard](#initialize-from-xib-or-storyboard)
  - [Initialize from PageViewManager](#initialize-from-pageviewmanager)
  - [Styles](#styles)
  - [Event Callbacks](#event-callbacks)
  - [FAQ](#faq)
- [License](#license)

## Features:

- [x] Easy to Use
- [x] Multiple Ways to Initialize 
- [x] Flexible Layout
- [x] Commonly Used Styles
- [x] Double Tap `titleView` Callback
- [x] `contentView` Scroll Listener
- [x] iOS 13 Dark Mode Support
- [x] Changing styles dynamically
- [x] RTL Layout

## Requirements

- iOS 9.0+

- Xcode 10.0+

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

### Initialize with PageView

```swift
// Create PageStyle
let style = PageStyle()
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

// Setup PageView and its frame
// titleView and contentView are connected
let pageView = PageView(frame: CGRect(x: 0, y: 64, width: size.width, height: size.height), style: style, titles: titles, childViewControllers: childViewControllers)
view.addSubview(pageView)
```



### Initialize from xib or storyboard

Creat two `UIView` in `Xib` or `storyboard`, make them inherit from `PageTitleView` and `PageContentView`, drag them into controller class

```swift
@IBOutlet weak var titleView: PageTitleView!

@IBOutlet weak var contentView: PageContentView!
```

Setup `PageTitleView` and `PageContentView`

```swift
// Create PageStyle
let style = PageStyle()
style.titleViewBackgroundColor = UIColor.red
style.isShowCoverView = true

// Setup titles
let titles = ["头条", "视频", "娱乐", "要问", "体育"]

// Setup staring index
let startIndex = 2


// Create child controller for each title
let childViewControllers: [ContentViewController] = titles.map { _ -> ContentViewController in
    let controller = ContentViewController()
    controller.view.backgroundColor = UIColor.randomColor
    return controller
}

// Create PageViewManager
let pageViewManager = PageViewManager(style: style,
                                  titles: titles,
                                  childViewControllers: children,
                                  currentIndex: currentIndex,
                                  titleView: titleView,
                                  contentView: contentView)
```



### Initialize from PageViewManager

Create `PageViewManager`

```swift
private lazy var pageViewManager: PageViewManager = {
    // Create PageStyle
    let style = PageStyle()
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

    return PageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
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

`PageStyle` provides some commonly used styles. You can also configure it as your needs, e.g. setup starting index.



### Event Callbacks

`DNSPageView` provides common optional delegate functions, which are optional property in `PageTitleViewDelegate`

```swift
/// DNSPageView event callback, if necessary, let the corresponding childViewController comply with this protocol
@objc public protocol PageEventHandleable: class {
    
    /// Call after repeatedly clicking pageTitleView
    @objc optional func titleViewDidSelectSameTitle()
    
    /// When the previous page of pageContentView disappears, the corresponding controller of the previous page call
    @objc optional func contentViewDidDisappear()
    
    /// When the page ContentView scroll stops, the corresponding controller of the current page call
    @objc optional func contentViewDidEndScroll()

}
```



### FAQ

- `style.isTitleViewScrollEnabled`
  
  If there are fewer `titles`, it is recommended to set `style. isTitleViewScrollEnabled = false`, `titleView` will be fixed, `style. titleMargin` will not work. Each title equals the width of the entire `titleView`, and the width of the underline equals the width of the `title`.
  If there are more labels, it is recommended to set `style. isTitleViewScrollEnabled = true`, `titleView` will slide, and the width of the underline will vary with the width of the `title` text.


- The width of the underline of the `title` follows the width of the text

  Setting `style. isTitleViewScrollEnabled = true` refers to the fourth style in `Demo`

- Since DNSPageView is based on `UIScrollView`, some of its features are unavoidable:

  - When the controller is managed by `UINavigationController` and `navigationBar. isTranslucent = true`, the view of the current controller is laid out from y = 0, so in order to prevent some content from being blocked by` navigationBar`, the system will add `offset` to UIScrollView by default. If you want to cancel this feature:
    - Prior to iOS 11, set `automaticallyAdjustsScrollViewInsets = false` in the controller
    - After iOS 11, the concept of `SafeArea` was introduced, set the `UIScrollView` property `contentInsetAdjustmentBehavior = never`
    - In fact, this effect is also related to other attributes of `UIViewController`, but because the scenarios of various combinations are too complex, they are not described here one by one
  
  - `PageContentView` is implemented with `UICollectionView`, so this feature has the opportunity to cause the classic warning of UICollectionView:
    
    > The behavior of the UICollectionViewFlowLayout is not defined because: 
  the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values.
    
  - The above is just one of the possible Bugs. Because `Demo` can not cover all scenarios, different layout requirements may lead to different Bugs. Developers need to clearly understand their layout requirements, pay attention to details, understand the layout characteristics of `iOS`, and make corresponding adjustments, so they can not refer to `Demo` completely.


## License

DNSPageView is available under the MIT license. See the LICENSE file for more info.


