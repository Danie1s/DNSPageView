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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
