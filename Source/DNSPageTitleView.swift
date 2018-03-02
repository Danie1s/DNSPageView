//
//  DNSPageTitleView.swift
//  DNSPageView
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018年 Daniels. All rights reserved.
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

@objc public protocol DNSPageTitleViewDelegate: class {

    /// pageContentView的刷新代理
    @objc optional var reloader: DNSPageReloadable? { get }
    
    func titleView(_ titleView: DNSPageTitleView, currentIndex: Int)
}

/// 如果contentView中的view需要实现某些刷新的方法，请让对应的childViewController遵守这个协议
@objc public protocol DNSPageReloadable: class {
    
    /// 如果需要双击标题刷新或者作其他处理，请实现这个方法
    @objc optional func titleViewDidSelectedSameTitle()
    
    /// 如果pageContentView滚动到下一页停下来需要刷新或者作其他处理，请实现这个方法
    @objc optional func contentViewDidEndScroll()
}


open class DNSPageTitleView: UIView {
    
    public weak var delegate: DNSPageTitleViewDelegate?
    
    /// 点击标题时调用
    public var clickHandler: TitleClickHandler?
    
    public var currentIndex: Int = 0
    
    private (set) public lazy var titleLabels: [UILabel] = [UILabel]()
    
    public var style: DNSPageStyle
    
    public var titles: [String]
    
    
    private lazy var selectRGB: ColorRGB = self.style.titleSelectedColor.getRGB()
    private lazy var normalRGB: ColorRGB = self.style.titleColor.getRGB()
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
        return bottomLine
    }()
    
    public lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewBackgroundColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()
    
    public init(frame: CGRect, style: DNSPageStyle, titles: [String], currentIndex: Int = 0) {
        self.style = style
        self.titles = titles
        self.currentIndex = currentIndex
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = DNSPageStyle()
        self.titles = [String]()
        super.init(coder: aDecoder)
        
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        
        setupLabelsLayout()
        setupBottomLineLayout()
        setupCoverViewLayout()
    }
    
}


// MARK:- 设置UI界面
extension DNSPageTitleView {
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
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.titleFontSize)
            
            scrollView.addSubview(label)
            
            titleLabels.append(label)

            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            
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
extension DNSPageTitleView {
    private func setupLabelsLayout() {
        
        let labelH = frame.size.height
        let labelY: CGFloat = 0
        var labelW: CGFloat = 0
        var labelX: CGFloat = 0
        
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {
            if style.isTitleScrollEnable {
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : titleLabel.font], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            } else {
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            
        }
        
        if style.isScaleEnable {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maximumScaleFactor, y: style.maximumScaleFactor)
        }
        
        if style.isTitleScrollEnable {
            guard let titleLabel = titleLabels.last else { return }
            scrollView.contentSize.width = titleLabel.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setupCoverViewLayout() {
        guard titleLabels.count - 1 >= currentIndex  else { return }
        let label = titleLabels[currentIndex]
        var coverW = label.bounds.width
        let coverH = style.coverViewHeight
        var coverX = label.frame.origin.x
        let coverY = (label.frame.height - coverH) * 0.5
        if style.isTitleScrollEnable {
            coverX -= style.coverMargin
            coverW += 2 * style.coverMargin
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
    }
    
    private func setupBottomLineLayout() {
        guard titleLabels.count - 1 >= currentIndex  else { return }
        let label = titleLabels[currentIndex]
        
        bottomLine.frame.origin.x = label.frame.origin.x
        bottomLine.frame.size.width = label.frame.width
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
    }
}

// MARK:- 监听label的点击
extension DNSPageTitleView {
    @objc func titleLabelClick(_ tapGes : UITapGestureRecognizer) {
        guard let targetLabel = tapGes.view as? UILabel else { return }
        
        clickHandler?(self, targetLabel.tag)
        
        if targetLabel.tag == currentIndex {
            delegate?.reloader??.titleViewDidSelectedSameTitle?()
            return
        }
        
        let sourceLabel = titleLabels[currentIndex]
        
        sourceLabel.textColor = style.titleColor
        targetLabel.textColor = style.titleSelectedColor
        
        currentIndex = targetLabel.tag
        
        adjustLabelPosition(targetLabel)
        
        delegate?.titleView(self, currentIndex: currentIndex)
        

        if style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maximumScaleFactor, y: self.style.maximumScaleFactor)
            })
        }
        
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: { 
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
        if style.isShowCoverView {
            let coverX = style.isTitleScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : targetLabel.frame.origin.x
            let coverW = style.isTitleScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : targetLabel.frame.width
            UIView.animate(withDuration: 0.25, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
    
    private func adjustLabelPosition(_ targetLabel : UILabel) {
        guard style.isTitleScrollEnable else { return }
        
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)

    }
}



extension DNSPageTitleView : DNSPageContentViewDelegate {
    public func contentView(_ contentView: DNSPageContentView, inIndex: Int) {
        currentIndex = inIndex
        
        let targetLabel = titleLabels[currentIndex]
        
        // 2.让targetLabel居中显示
        adjustLabelPosition(targetLabel)
        
        
        fixUI(targetLabel)
                
    }
    
    public func contentView(_ contentView: DNSPageContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        if sourceIndex > titleLabels.count - 1 || sourceIndex < 0 {
            return
        }
        if targetIndex > titleLabels.count - 1 || targetIndex < 0 {
            return
        }
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        sourceLabel.textColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        if style.isScaleEnable {
            let deltaScale = style.maximumScaleFactor - 1.0
            sourceLabel.transform = CGAffineTransform(scaleX: style.maximumScaleFactor - progress * deltaScale, y: style.maximumScaleFactor - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }
        
        if style.isShowCoverView {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            coverView.frame.size.width = style.isTitleScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isTitleScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
        }
        
    }
    
    private func fixUI(_ targetLabel: UILabel) {
        UIView.animate(withDuration: 0.05) {
            targetLabel.textColor = self.style.titleSelectedColor
            
            if self.style.isScaleEnable {
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maximumScaleFactor, y: self.style.maximumScaleFactor)
            }
            
            if self.style.isShowBottomLine {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            }
            
            if self.style.isShowCoverView {
                
                self.coverView.frame.size.width = self.style.isTitleScrollEnable ? (targetLabel.frame.width + 2 * self.style.coverMargin) : targetLabel.frame.width
                self.coverView.frame.origin.x = self.style.isTitleScrollEnable ? (targetLabel.frame.origin.x - self.style.coverMargin) : targetLabel.frame.origin.x
            }
        }
        
    }
    
}



