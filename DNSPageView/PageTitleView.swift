//
//  PageTitleView.swift
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

public protocol PageTitleViewDelegate: class {
    
    /// DNSPageView 的事件回调处理者
    var eventHandler: PageEventHandleable? { get }
    
    func titleView(_ titleView: PageTitleView, didSelectAt index: Int)
}

/// DNSPageView 的事件回调，如果有需要，请让对应的 childViewController 遵守这个协议
public protocol PageEventHandleable: class {
    
    /// 重复点击 pageTitleView 后调用
    func titleViewDidSelectSameTitle()
    
    /// pageContentView 的上一页消失的时候，上一页对应的 controller 调用
    func contentViewDidDisappear()
    
    /// pageContentView 滚动停止的时候，当前页对应的 controller 调用
    func contentViewDidEndScroll()
    
}

extension PageEventHandleable {
    func titleViewDidSelectSameTitle() {}
    
    func contentViewDidDisappear() {}
    
    func contentViewDidEndScroll() {}
}

public typealias TitleClickHandler = (PageTitleView, Int) -> ()

public class PageTitleView: UIView {
    
    public weak var delegate: PageTitleViewDelegate?
    
    public weak var container: PageViewContainer?
    
    /// 点击标题时调用
    public var clickHandler: TitleClickHandler?
    
    private (set) public var currentIndex: Int = 0 {
        didSet {
            container?.updateCurrentIndex(currentIndex)
        }
    }
    
    private (set) public lazy var titleLabels: [UILabel] = [UILabel]()
    
    private (set) public var style: PageStyle = PageStyle()
    
    private (set) public var titles: [String] = [String]()
    
    
    private lazy var normalRGB: ColorRGB = style.titleColor.getRGB()
    private lazy var selectRGB: ColorRGB = style.titleSelectedColor.getRGB()
    private lazy var deltaRGB: ColorRGB = {
        let deltaR = selectRGB.red - normalRGB.red
        let deltaG = selectRGB.green - normalRGB.green
        let deltaB = selectRGB.blue - normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    private lazy var bottomLine: UIView = UIView()
    
    private (set) public lazy var coverView: UIView = UIView()
    
    public init(frame: CGRect, style: PageStyle, titles: [String], currentIndex: Int = 0) {
        assert(currentIndex >= 0 && currentIndex < titles.count,
               "currentIndex < 0 or currentIndex >= titles.count")
        super.init(frame: frame)
        addSubview(scrollView)
        configure(titles: titles, style: style, currentIndex: currentIndex)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(scrollView)
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(origin: CGPoint.zero, size: frame.size)
        guard titles.count > 0 else { return }
        layoutLabels()
        layoutBottomLine()
        layoutCoverView()
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateColors()
    }

    private func updateColors() {
        normalRGB = style.titleColor.getRGB()
        selectRGB = style.titleSelectedColor.getRGB()
        let deltaR = selectRGB.red - normalRGB.red
        let deltaG = selectRGB.green - normalRGB.green
        let deltaB = selectRGB.blue - normalRGB.blue
        deltaRGB = (deltaR, deltaG, deltaB)
    }

    /// 通过代码实现点了某个位置的 titleView
    ///
    /// - Parameter index: 需要点击的 titleView 的索引
    public func selectedTitle(at index: Int, animated: Bool = true) {
        if index > titles.count || index < 0 {
            print("PageTitleView -- selectedTitle: 数组越界了, index 的值超出有效范围");
            return;
        }

        clickHandler?(self, index)

        if index == currentIndex {
            delegate?.eventHandler?.titleViewDidSelectSameTitle()
            return
        }

        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]

        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor
        
        delegate?.eventHandler?.contentViewDidDisappear()

        currentIndex = index

        delegate?.titleView(self, didSelectAt: currentIndex)
        
        adjustLabelPosition(targetLabel, animated: animated)
        
        if let font = style.titleSelectedFont {
            sourceLabel.font = style.titleFont
            targetLabel.font = font
        }

        if style.isTitleScaleEnabled {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.titleMaximumScaleFactor, y: self.style.titleMaximumScaleFactor)
            })
        }

        if style.isShowBottomLine {
            let titleInset = style.isTitleViewScrollEnabled ? style.titleInset : 0
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.size.width = self.style.bottomLineWidth > 0 ?
                    self.style.bottomLineWidth : targetLabel.frame.width - titleInset
                self.bottomLine.center.x = targetLabel.center.x
            })
        }

        if style.isShowCoverView {
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.size.width = self.style.isTitleViewScrollEnabled ?
                    (targetLabel.frame.width + self.style.coverMargin * 2) : targetLabel.frame.width
                self.coverView.center.x = targetLabel.center.x
            })
        }

        sourceLabel.backgroundColor = UIColor.clear
        targetLabel.backgroundColor = style.titleViewSelectedColor
    }
    
    public func updateTitle(_ title: String, at index: Int) {
        if index > titles.count || index < 0 {
            print("PageTitleView -- updateTitle(_:at:): 数组越界了, index 的值超出有效范围");
            return;
        }
        titles[index] = title
        titleLabels[index].text = title
        setNeedsLayout()
    }
    
}


// MARK: - 构建 UI
extension PageTitleView {
    internal func configure(titles: [String]? = nil, style: PageStyle? = nil, currentIndex: Int? = nil) {
        if let titles = titles {
            self.titles = titles
        }
        if let style = style {
            self.style = style
            updateColors()
        }
        if let currentIndex = currentIndex {
            self.currentIndex = currentIndex
        }
        configureSubViews()
        setNeedsLayout()
    }
    
    
    private func configureSubViews() {
        scrollView.backgroundColor = style.titleViewBackgroundColor
        guard titles.count > 0 else { return }
        configureLabels()
        configureBottomLine()
        configureCoverView()
    }
    

    private func configureLabels() {
        if titles.count == titleLabels.count {
            for (i, title) in titles.enumerated() {
                configureLabel(titleLabels[i], i, title)
            }
        } else {
            titleLabels.forEach { $0.removeFromSuperview() }
            titleLabels = []
            for (i, title) in titles.enumerated() {
                let label = UILabel()
                let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapedTitleLabel(_:)))
                label.addGestureRecognizer(tapGes)
                label.isUserInteractionEnabled = true
                configureLabel(label, i, title)
                scrollView.addSubview(label)
                titleLabels.append(label)
            }
        }
    }
    
    private func configureLabel(_ label: UILabel, _ i: Int, _ title: String) {
        label.tag = i
        label.text = title
        label.textColor = i == currentIndex ? style.titleSelectedColor : style.titleColor
        label.backgroundColor = i == currentIndex ? style.titleViewSelectedColor : UIColor.clear;
        label.textAlignment = .center
        label.font = style.titleFont
    }
    
    private func configureBottomLine() {
        guard style.isShowBottomLine else {
            bottomLine.removeFromSuperview()
            return
        }
        bottomLine.backgroundColor = style.bottomLineColor
        bottomLine.layer.cornerRadius = style.bottomLineRadius
        scrollView.addSubview(bottomLine)
    }
    
    private func configureCoverView() {
        guard style.isShowCoverView else {
            coverView.removeFromSuperview()
            return
        }
        coverView.backgroundColor = style.coverViewBackgroundColor
        coverView.alpha = style.coverViewAlpha
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
        scrollView.insertSubview(coverView, at: 0)
    }
}


// MARK: - Layout
extension PageTitleView {
    private func layoutLabels() {
        var x: CGFloat = 0
        let y: CGFloat = 0
        var width: CGFloat = 0
        let height = frame.height
        
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isTitleViewScrollEnabled {
                width = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0),
                                                             options: .usesLineFragmentOrigin,
                                                             attributes: [NSAttributedString.Key.font : style.titleFont],
                                                             context: nil).width + style.titleInset
                x = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i - 1].frame.maxX + style.titleMargin)
            } else {
                width = frame.width / CGFloat(count)
                x = width * CGFloat(i)
            }
            titleLabel.transform = CGAffineTransform.identity
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        if let font = style.titleSelectedFont {
            titleLabels[currentIndex].font = font
        }
        if style.isTitleScaleEnabled {
            titleLabels[currentIndex].transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor, y: style.titleMaximumScaleFactor)
        }
        if style.isTitleViewScrollEnabled {
            guard let titleLabel = titleLabels.last else { return }
            scrollView.contentSize.width = titleLabel.frame.maxX + style.titleMargin * 0.5
        }
        
        adjustLabelPosition(titleLabels[currentIndex], animated: false)
        fixUI(titleLabels[currentIndex])
    }
    
    private func layoutCoverView() {
        guard currentIndex < titleLabels.count else { return }
        let label = titleLabels[currentIndex]
        var width = label.frame.width
        let height = style.coverViewHeight
        if style.isTitleViewScrollEnabled {
            width += 2 * style.coverMargin
        }
        coverView.frame.size = CGSize(width: width, height: height)
        coverView.center = label.center
    }
    
    private func layoutBottomLine() {
        guard currentIndex < titleLabels.count else { return }
        let label = titleLabels[currentIndex]
        
        let titleInset = style.isTitleViewScrollEnabled ? style.titleInset : 0
        bottomLine.frame.size.width = style.bottomLineWidth > 0 ? style.bottomLineWidth : label.frame.width - titleInset
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.center.x = label.center.x
        bottomLine.frame.origin.y = frame.height - bottomLine.frame.height
    }
}

// MARK: - 监听 label 的点击
extension PageTitleView {
    @objc private func tapedTitleLabel(_ tapGes : UITapGestureRecognizer) {
        guard let index = tapGes.view?.tag else { return }
        selectedTitle(at: index)
    }


    private func adjustLabelPosition(_ targetLabel : UILabel, animated: Bool) {
        guard style.isTitleViewScrollEnabled,
            scrollView.contentSize.width > scrollView.frame.width
            else { return }
        
        var offsetX = targetLabel.center.x - frame.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.frame.width {
            offsetX = scrollView.contentSize.width - scrollView.frame.width
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
}



extension PageTitleView: PageContentViewDelegate {
    public func contentView(_ contentView: PageContentView, didEndScrollAt index: Int) {
        
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]
        
        if let font = style.titleSelectedFont {
            sourceLabel.font = style.titleFont
            targetLabel.font = font
        }

        sourceLabel.textColor = style.titleColor
        sourceLabel.backgroundColor = UIColor.clear
        targetLabel.backgroundColor = style.titleViewSelectedColor
        
        currentIndex = index
                
        adjustLabelPosition(targetLabel, animated: true)
        
        fixUI(targetLabel)
    }
    
    public func contentView(_ contentView: PageContentView, scrollingWith sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        if sourceIndex >= titleLabels.count || sourceIndex < 0 {
            return
        }
        if targetIndex >= titleLabels.count || targetIndex < 0 {
            return
        }
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        sourceLabel.textColor = UIColor((selectRGB.red - progress * deltaRGB.red,
                                         selectRGB.green - progress * deltaRGB.green,
                                         selectRGB.blue - progress * deltaRGB.blue))
        targetLabel.textColor = UIColor((normalRGB.red + progress * deltaRGB.red,
                                         normalRGB.green + progress * deltaRGB.green,
                                         normalRGB.blue + progress * deltaRGB.blue))
        if style.isTitleScaleEnabled {
            let deltaScale = style.titleMaximumScaleFactor - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor - progress * deltaScale,
                                                      y: style.titleMaximumScaleFactor - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale,
                                                      y: 1.0 + progress * deltaScale)
        }
        
        if style.isShowBottomLine {
            if style.bottomLineWidth <= 0 {
                let titleInset = style.isTitleViewScrollEnabled ? style.titleInset : 0
                let deltaWidth = targetLabel.frame.width - sourceLabel.frame.width
                bottomLine.frame.size.width = sourceLabel.frame.width - titleInset + progress * deltaWidth
            }
            let deltaCenterX = targetLabel.center.x - sourceLabel.center.x
            bottomLine.center.x = sourceLabel.center.x + progress * deltaCenterX
        }

        if style.isShowCoverView {
            let deltaWidth = targetLabel.frame.width - sourceLabel.frame.width
            coverView.frame.size.width = style.isTitleViewScrollEnabled ?
                (sourceLabel.frame.width + 2 * style.coverMargin + deltaWidth * progress) :
                (sourceLabel.frame.width + deltaWidth * progress)
            let deltaCenterX = targetLabel.center.x - sourceLabel.center.x
            coverView.center.x = sourceLabel.center.x + deltaCenterX * progress
        }
    }
    
    private func fixUI(_ targetLabel: UILabel) {
        UIView.animate(withDuration: 0.05) {
            targetLabel.textColor = self.style.titleSelectedColor
            
            if self.style.isTitleScaleEnabled {
                targetLabel.transform = CGAffineTransform(scaleX: self.style.titleMaximumScaleFactor, y: self.style.titleMaximumScaleFactor)
            }
            
            if self.style.isShowBottomLine {
                if self.style.bottomLineWidth <= 0 {
                    let titleInset = self.style.isTitleViewScrollEnabled ? self.style.titleInset : 0
                    self.bottomLine.frame.size.width = targetLabel.frame.width - titleInset
                }
                self.bottomLine.center.x = targetLabel.center.x
            }
            
            if self.style.isShowCoverView {
                self.coverView.frame.size.width = self.style.isTitleViewScrollEnabled ?
                    (targetLabel.frame.width + 2 * self.style.coverMargin) :
                    targetLabel.frame.width
                self.coverView.center.x = targetLabel.center.x
            }
        }
        
    }
    
}



