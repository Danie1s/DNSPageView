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
        
        view.addSubview(button)
        button.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
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
