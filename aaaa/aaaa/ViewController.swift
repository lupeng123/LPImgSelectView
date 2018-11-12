//
//  ViewController.swift
//  aaaa
//
//  Created by 路鹏 on 2018/11/9.
//  Copyright © 2018 路鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100));
        btn.backgroundColor = UIColor.red;
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside);
        self.view.addSubview(btn);
    }
    
    @objc func btnClick() {
        let imgArr = [
            UIImage.init(named: "1"),
            UIImage.init(named: "2"),
            UIImage.init(named: "3"),
            UIImage.init(named: "4"),
            UIImage.init(named: "5"),
            ]
        let _ = LPImgSelectView.show(imgArr: imgArr, selectCount: 0);
    }


}

