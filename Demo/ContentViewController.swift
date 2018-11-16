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
    
    
    @objc private func push() {
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        controller.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(controller, animated: true)
    }

}

extension ContentViewController: DNSPageReloadable {
    func titleViewDidSelectedSameTitle() {
        print("重复点击了标题")
    }

    func contentViewDidEndScroll() {
        print("contentView滑动结束")
    }
}
