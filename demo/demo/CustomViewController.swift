//
//  CustomViewController.swift
//  aaaa
//
//  Created by 路鹏 on 2019/2/18.
//  Copyright © 2019 路鹏. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgArr = [
            UIImage.init(named: "1"),
            UIImage.init(named: "2"),
            UIImage.init(named: "3"),
            UIImage.init(named: "4"),
            UIImage.init(named: "5"),
            ]
        let _ = LPImgSelectView.showToView(imgArr: imgArr, selectCount: 0, toView: self.view);
    }

}
