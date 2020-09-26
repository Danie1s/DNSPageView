//
//  ContentViewController.swift
//  Demo
//
//  Created by Daniels on 2018/2/24.
//  Copyright © 2018 Daniels. All rights reserved.
//

import UIKit
import DNSPageView

class ContentViewController: UIViewController  {
    
    var index: Int = 0
    
    var isRTL: Bool = false {
        didSet {
            collectionView.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
            pageControl.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        }
    }

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        return pageControl
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: 200)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuseID")
        return collectionView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("点击我进行push", for: .normal)
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.random
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalTo(300)
        }
        
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-100)
        }
        
        let label = UILabel()
        label.text = "pageView 第 \(index) 页"
        label.textColor = UIColor.white
        view.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(100)
        }
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.frame.size
        
    }
    
    // pop 或者 cell 复用的时候调用
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        print("viewDidDisappear，index：\(index)")
    }
    
    // 出现的时候马上调用
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("viewDidAppear，index：\(index)")
    }
    
    
    @objc private func push() {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        controller.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension ContentViewController: PageEventHandleable {
    
    func titleViewDidSelectSameTitle() {
        print("重复点击了标题，index：\(index)")
    }

    // 当前 controller 滑动结束的时候调用
    func contentViewDidEndScroll() {
        print("contentView滑动结束，index：\(index)")
    }
    
    func contentViewDidDisappear() {
        print("我消失了，index：\(index)")
    }
}



extension ContentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseID", for: indexPath)
        cell.backgroundColor = UIColor.random
        let label = UILabel()
        label.text = "内部 collectionView 第 \(indexPath.item) 页"
        label.textColor = UIColor.white
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        pageControl.currentPage = isRTL ? pageControl.numberOfPages - index - 1 : index
    }
}
