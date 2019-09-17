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

@objc public protocol PageTitleViewDelegate: class {
    
    /// DNSPageView的事件回调处理者
    @objc optional var eventHandler: PageEventHandleable? { get }
    
    func titleView(_ titleView: PageTitleView, didSelectAt index: Int)
}

/// DNSPageView的事件回调，如果有需要，请让对应的childViewController遵守这个协议
@objc public protocol PageEventHandleable: class {
    
    /// 重复点击pageTitleView后调用
    @objc optional func titleViewDidSelectSameTitle()
    
    /// pageContentView的上一页消失的时候，上一页对应的controller调用
    @objc optional func contentViewDidDisappear()
    
    /// pageContentView滚动停止的时候，当前页对应的controller调用
    @objc optional func contentViewDidEndScroll()
    
}


open class PageTitleView: UIView {
    
    public weak var delegate: PageTitleViewDelegate?
    
    /// 点击标题时调用
    public var clickHandler: TitleClickHandler?
    
    public var currentIndex: Int
    
    private (set) public lazy var titleLabels: [UILabel] = [UILabel]()
    
    public var style: PageStyle
    
    public var titles: [String]
    
    
    private lazy var normalRGB: ColorRGB = self.style.titleColor.getRGB()
    private lazy var selectRGB: ColorRGB = self.style.titleSelectedColor.getRGB()
    private lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.layer.cornerRadius = self.style.bottomLineRadius
        return bottomLine
    }()
    
    private (set) public lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewBackgroundColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    public init(frame: CGRect, style: PageStyle, titles: [String], currentIndex: Int) {
        self.style = style
        self.titles = titles
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = PageStyle()
        self.titles = [String]()
        self.currentIndex = 0
        super.init(coder: aDecoder)
        
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        
        setupLabelsLayout()
        setupBottomLineLayout()
        setupCoverViewLayout()
    }



    /// 通过代码实现点了某个位置的titleView
    ///
    /// - Parameter index: 需要点击的titleView的下标
    public func selectedTitle(at index: Int) {
        if index > titles.count || index < 0 {
            print("DNSPageTitleView -- selectedTitle: 数组越界了, index的值超出有效范围");
        }

        clickHandler?(self, index)

        if index == currentIndex {
            delegate?.eventHandler??.titleViewDidSelectSameTitle?()
            return
        }

        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]

        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor
        
        delegate?.eventHandler??.contentViewDidDisappear?()

        currentIndex = index

        delegate?.titleView(self, didSelectAt: currentIndex)
        
        adjustLabelPosition(targetLabel)

        if style.isTitleScaleEnabled {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.titleMaximumScaleFactor, y: self.style.titleMaximumScaleFactor)
            })
        }

        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.size.width = self.style.bottomLineWidth > 0 ? self.style.bottomLineWidth : targetLabel.frame.width
                self.bottomLine.center.x = targetLabel.center.x
            })
        }

        if style.isShowCoverView {
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.size.width = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.width + self.style.coverMargin * 2) : targetLabel.frame.width
                self.coverView.center.x = targetLabel.center.x
            })
        }

        sourceLabel.backgroundColor = UIColor.clear
        targetLabel.backgroundColor = style.titleViewSelectedColor
                
    }
    
}


// MARK: - 设置UI界面
extension PageTitleView {
    public func setupUI() {
        addSubview(scrollView)
        
        scrollView.backgroundColor = style.titleViewBackgroundColor
        
        setupTitleLabels()
        setupBottomLine()
        setupCoverView()
    }
    
    private func setupTitleLabels() {
        for (i, title) in titles.enumerated() {
            let label = UILabel()
            
            label.tag = i
            label.text = title
            label.textColor = i == currentIndex ? style.titleSelectedColor : style.titleColor
            label.backgroundColor = i == currentIndex ? style.titleViewSelectedColor : UIColor.clear;
            label.textAlignment = .center
            label.font = style.titleFont
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapedTitleLabel(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            
            scrollView.addSubview(label)
    
            titleLabels.append(label)
        }
    }
    
    private func setupBottomLine() {
        guard style.isShowBottomLine else { return }
        
        scrollView.addSubview(bottomLine)
    }
    
    
    private func setupCoverView() {
        
        guard style.isShowCoverView else { return }
        
        scrollView.insertSubview(coverView, at: 0)
        
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
    }
    
}


// MARK: - Layout
extension PageTitleView {
    private func setupLabelsLayout() {
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        var width: CGFloat = 0
        let height = frame.height
        
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isTitleViewScrollEnabled {
                width = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : style.titleFont], context: nil).width
                x = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i - 1].frame.maxX + style.titleMargin)
            } else {
                width = frame.width / CGFloat(count)
                x = width * CGFloat(i)
            }
            titleLabel.transform = CGAffineTransform.identity
            titleLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        if style.isTitleScaleEnabled {
            titleLabels[currentIndex].transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor, y: style.titleMaximumScaleFactor)
        }
        
        if style.isTitleViewScrollEnabled {
            guard let titleLabel = titleLabels.last else { return }
            scrollView.contentSize.width = titleLabel.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupCoverViewLayout() {
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
    
    private func setupBottomLineLayout() {
        guard currentIndex < titleLabels.count else { return }
        let label = titleLabels[currentIndex]
        
        bottomLine.frame.size.width = style.bottomLineWidth > 0 ? style.bottomLineWidth : label.frame.width
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.center.x = label.center.x
        bottomLine.frame.origin.y = frame.height - bottomLine.frame.height
    }
}

// MARK: - 监听label的点击
extension PageTitleView {
    @objc private func tapedTitleLabel(_ tapGes : UITapGestureRecognizer) {
        guard let index = tapGes.view?.tag else { return }
        selectedTitle(at: index)

    }


    
    private func adjustLabelPosition(_ targetLabel : UILabel) {
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
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}



extension PageTitleView: PageContentViewDelegate {
    public func contentView(_ contentView: PageContentView, didEndScrollAt index: Int) {
        
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[index]

        sourceLabel.backgroundColor = UIColor.clear
        targetLabel.backgroundColor = style.titleViewSelectedColor
        
        currentIndex = index
                
        adjustLabelPosition(targetLabel)
        
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
        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        if style.isTitleScaleEnabled {
            let deltaScale = style.titleMaximumScaleFactor - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.titleMaximumScaleFactor - progress * deltaScale, y: style.titleMaximumScaleFactor - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        if style.isShowBottomLine {
            if style.bottomLineWidth <= 0 {
                let deltaWidth = targetLabel.frame.width - sourceLabel.frame.width
                bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaWidth
            }
            let deltaCenterX = targetLabel.center.x - sourceLabel.center.x
            bottomLine.center.x = sourceLabel.center.x + progress * deltaCenterX
        }

        if style.isShowCoverView {
            let deltaWidth = targetLabel.frame.width - sourceLabel.frame.width
            coverView.frame.size.width = style.isTitleViewScrollEnabled ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaWidth * progress) : (sourceLabel.frame.width + deltaWidth * progress)
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
                    self.bottomLine.frame.size.width = targetLabel.frame.width
                }
                self.bottomLine.center.x = targetLabel.center.x
            }
            
            if self.style.isShowCoverView {
                self.coverView.frame.size.width = self.style.isTitleViewScrollEnabled ? (targetLabel.frame.width + 2 * self.style.coverMargin) : targetLabel.frame.width
                self.coverView.center.x = targetLabel.center.x
            }
        }
        
    }
    
}



