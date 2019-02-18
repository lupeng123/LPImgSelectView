//
//  LPImgSelectView.swift
//  MaiYa
//
//  Created by 路鹏 on 2018/10/18.
//  Copyright © 2018年 LP. All rights reserved.
//

import UIKit

public let isiPhoneX: Bool = UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height < 0.5 || UIScreen.main.bounds.size.width / UIScreen.main.bounds.size.height > 2.0

class LPImgSelectView: UIView {

    var contentScrollView:UIScrollView!;
    var imgArr:[Any?]!;
    var imgScrollArr:[LPImgScrollView]! = [];
    var currentImgScro:LPImgScrollView!;
    var lastImgScro:LPImgScrollView!;
    var titleLab:UILabel!;
    var isToWindow:Bool = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = UIColor.black;
        self.clipsToBounds = true;
    }
    
    public static func showToView(imgArr:[Any?], selectCount:Int, toView:UIView)->LPImgSelectView {
        let imgView = LPImgSelectView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height:  UIScreen.main.bounds.size.height));
        imgView.imgArr = imgArr;
        imgView.createSubView();
        imgView.setSelectCount(count: selectCount);
        toView.addSubview(imgView);
        return imgView;
    }
    
    public static func showToWindow(imgArr:[Any?],selectCount:Int)->LPImgSelectView {
        let imgView = LPImgSelectView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width , height:  UIScreen.main.bounds.size.height));
        imgView.imgArr = imgArr;
        imgView.createSubView();
        imgView.setSelectCount(count: selectCount);
        imgView.isToWindow = true;
        imgView.alpha = 0;
        let rootVC = UIApplication.shared.delegate as! AppDelegate
        rootVC.window?.addSubview(imgView)
        UIView.animate(withDuration: 0.3, animations: {
            imgView.alpha = 1;
        }) { (_) in
        }
        return imgView;
    }
    
    func createSubView() {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width+20, height: self.frame.size.height));
        scrollView.backgroundColor = UIColor.clear;
        scrollView.isScrollEnabled = true;
        scrollView.isPagingEnabled = true;
        scrollView.delegate = self;
        scrollView.clipsToBounds = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.contentSize = CGSize.init(width: (self.frame.size.width+20)*CGFloat(self.imgArr.count), height: 0);
        self.insertSubview(scrollView, at: 0);
        self.contentScrollView = scrollView;

        for (i,item) in self.imgArr.enumerated() {
            let s = LPImgScrollView.init(frame: CGRect.init(x: (self.frame.size.width+20)*CGFloat(i), y: 0, width: self.frame.size.width, height: self.frame.size.height), gesture: UITapGestureRecognizer());
            s.showsVerticalScrollIndicator = false;
            s.showsHorizontalScrollIndicator = false;
//            if let itemS = item as? String{
//                s.contentImg.setImageWith(URL.init(string: itemS), placeholder: nil);
//            }
            
            if let itemI = item as? UIImage{
                s.contentImg.image = itemI
            }
            
            s.contentSize = CGSize.init(width: self.frame.size.width, height: s.frame.size.height);
            s.bounces = true;
            s.backgroundColor = UIColor.clear;
            s.delegate = self;
            s.minimumZoomScale = 1.0;
            s.maximumZoomScale = 3.0;
            s.setZoomScale(1.0, animated: false);
            self.contentScrollView.addSubview(s);
            self.imgScrollArr.append(s);
            
            if (i == 0) {
                self.currentImgScro = s;
            }
            
            s.dismissCb = {() in
                if self.isToWindow {
                    self.disMiss();
                }
            }
        }
        
        let title = UILabel();
        title.textColor = UIColor.white;
        title.font = UIFont.systemFont(ofSize: 14);
        title.text = "1 / \(self.imgArr.count)";
        title.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6);
        title.bounds = CGRect.init(x: 0, y: 0, width: 80, height: 30);
        title.center = CGPoint.init(x: self.center.x, y: isiPhoneX ? 54 : 30)
        title.layer.cornerRadius = 15;
        title.layer.masksToBounds = true;
        title.textAlignment = .center;
        self.addSubview(title);
        self.titleLab = title;
        
        let saveBtn = UIButton.init(type: .custom);
        saveBtn.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8);
        saveBtn.layer.cornerRadius = 5;
        saveBtn.setTitle("保存相册", for: .normal);
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12);
        saveBtn.setTitleColor(UIColor.white, for: .normal);
        saveBtn.addTarget(self, action: #selector(self.saveClick), for: .touchUpInside);
        saveBtn.frame = CGRect.init(x: self.frame.size.width-100, y: self.frame.size.height - (isiPhoneX ? 84 : 60), width: 80, height: 30);
        self.addSubview(saveBtn);
    }
    
    func setSelectCount(count:Int) {
        self.contentScrollView.setContentOffset(CGPoint.init(x: self.contentScrollView.frame.size.width*CGFloat(count), y: 0), animated: false);
        self.titleLab.text = "\(count+1) / \(self.imgArr.count)";
    }
    
    @objc func saveClick() {
        if let img = self.currentImgScro.contentImg.image {
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(saveImage(image:didFinishSavingWithError:contextInfo:)), nil);
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if (error != nil) {
//            self.makeToast(message: "保存失败");
        }else {
//            self.makeToast(message: "保存成功");
        }
    }
    
    func disMiss() {
        weak var wself = self
        UIView.animate(withDuration: 0.3, animations: {
            wself?.alpha = 0;
        }) { (_) in
            wself?.removeFromSuperview();
        }
    }

}

extension LPImgSelectView:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        for v in scrollView.subviews {
            return v;
        }
        return nil;
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView == self.contentScrollView {
            return;
        }
        
        var xcenter:CGFloat = scrollView.frame.size.width/2;
        var ycenter:CGFloat = scrollView.frame.size.height/2;
        
        xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
        
        ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
        
        let imgView = scrollView.subviews[0];
        imgView.center = CGPoint.init(x: xcenter, y: ycenter);
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView == self.contentScrollView {
            return;
        }
        scrollView.setZoomScale(scale, animated: false);
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView != self.contentScrollView) {
            return;
        }
        if (self.lastImgScro == nil) {
            self.lastImgScro = self.imgScrollArr[0];
        }
        let count = Int(scrollView.contentOffset.x/scrollView.frame.size.width);
        
        self.currentImgScro = self.imgScrollArr[count];
        
        if (count == self.imgScrollArr.count) {
            lastImgScro.setZoomScale(1, animated: false);
        }else{
            let imgScro = self.imgScrollArr[count];
            if (self.lastImgScro != imgScro) {
                self.lastImgScro.setZoomScale(1, animated: false);
            }
            self.lastImgScro = imgScro;
        }
        self.titleLab.text = "\(count+1) / \(self.imgArr.count)";
    }
    
}

extension LPImgSelectView:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return false;
    }
}

class LPImgScrollView: UIScrollView {
    public var dismissCb:(() -> Void)?
    public var contentImg:UIImageView!;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    init(frame: CGRect, gesture:UITapGestureRecognizer) {
        super.init(frame: frame);
        
        self.createSubView(gesture: gesture);
    }
    
    func createSubView(gesture:UITapGestureRecognizer) {
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(self.handleDoubleTap));
        doubleTap.numberOfTapsRequired = 2;
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.handleTap));
        tap.numberOfTapsRequired = 1;
        
        tap.require(toFail: doubleTap);
        
        let imageview = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height));
        imageview.addGestureRecognizer(doubleTap);
        imageview.addGestureRecognizer(tap);
        imageview.isUserInteractionEnabled = true;
        imageview.contentMode = .scaleAspectFit;
        self.addSubview(imageview);
        self.contentImg = imageview;
        
    }
    
    @objc func handleTap(gesture:UIGestureRecognizer) {
        if let close = self.dismissCb {
            close();
        }
    }
    
    @objc func handleDoubleTap(gesture:UIGestureRecognizer) {
        guard let s = gesture.view?.superview as? UIScrollView else {
            return;
        }
        var newScale:CGFloat = s.zoomScale;
        newScale = newScale < 2.0 ? 3.0 : 1.0;
        let zoomRect = self.zoomRectForScale(scale: newScale, center: gesture.location(in: gesture.view));
        s.zoom(to: zoomRect, animated: true);
    }
    
    func zoomRectForScale(scale:CGFloat, center:CGPoint)->CGRect {
        var zoomRect:CGRect = CGRect();
        zoomRect.size.height = self.frame.size.height / scale;
        zoomRect.size.width  = self.frame.size.width  / scale;
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
        return zoomRect;
    }
}
