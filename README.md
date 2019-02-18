# LPImgSelectView
图片预览左右滑动展示，双击放大缩小，捏合放大缩小
### 使用方法

```objc
let imgArr = [
            UIImage.init(named: "1"),
            UIImage.init(named: "2"),
            UIImage.init(named: "3"),
            UIImage.init(named: "4"),
            UIImage.init(named: "5"),
            ]
let _ = LPImgSelectView.showToView(imgArr: imgArr, selectCount: 0, toView: self.view);
```

![image](https://github.com/lupeng123/LPImgUrlStore/blob/master/2.gif?raw=true)
