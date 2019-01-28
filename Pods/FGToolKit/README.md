# FGToolKit

Swift便利工具集

## Contents

- [x] Timer + Block(iOS 10以下也可以直接将timer的事件回调到代码块里)
- [x] UIControl + Action(按钮事件直接回调到代码块里)
- [x] UIImage + Arrow(带箭头的图片有左边和右边)
- [x] Date + Format(格式化的时间字符串)
- [x] UIColor + Hex(16进制颜色、16进制字符串颜色)
- [x] UIImage + Circle(高性能圆形图片)
- [x] UIView + Action(像用UIButton一样去用UIView、UILabel等，直接将点击事件回调到代码块里)
- [x] String + Chinese(汉字转拼音、判断是否有汉字、汉字的首个大写字母)
- [x] FGWebImage Swift版轻量级的图片加载工具，功能类似SDWebImage，只有100多行代码
- [x] ImageCropView 可以设置任意比例裁剪图片
- [x] Maker 快速创建UI控件，快速生成属性字符串等，节约开发时间

后续会持续更新...


## Feture

- Timer + Block
```
timer = Timer.fg_scheduledTimer(interval: 1, repeats: true, block: { (sender) in

})
```
- UIControl + Action
```
btn.handleClick(events: .touchUpInside, click: { (sender) in

})
```
- UIImage + Arrow 带尖角的图片，效果如下:

![](/imgs/arrow.png)
```
imageView1.image = image?.arrowed(.left, resizeTo: .init(width: 200, height: 100))
view.addSubview(imageView1)
```
- Date + Format
```
lb.text = Date.init(timeIntervalSinceNow: -48 * 3600).formatedTime//星期三18:14
```
- UIColor + Hex
```
lb.textColor = hexcolor(0xa115c6)
lb.hex = 0xf4f4f4//设置16进制背景颜色的简写
lb.textColor = UIColor.init(hex: 0x333333)
```
- UIImage + Circle 高性能圆形图片
```
imageView.image = image?.cirled()
```
- UIView + Action 像用UIButton一样去用UIView、UILabel等，直接将点击事件回调到代码块里
```
lb.addTap(handler: { (sender) in

})
```
- String + Chinese 中文转拼音
```
"你好".pinyin//nihao
"你好".firstLetter//H
"abc哈1x".hasChinese//true
```
- 示例（10-20个汉字的正则）
```
let reg = "[\\u4e00-\\u9fa5]{10,20}"
let predicate = NSPredicate.init(format: "SELF MATCHES %@", reg)
let result = predicate.evaluate(with: text)
```

- FGWebImage
```swift
imageView.fg_setImageWithUrl(url, placeHolderImage)
```

- ImageCropView

```swift
let cropView = ImageCropView.init(frame: UIScreen.main.bounds, image: image, mode: 3.0/1.0, hanlder: { (cropedImage) in
	imageView.image = cropedImage
})
UIApplication.shared.keyWindow?.addSubview(cropView)
```

- Maker

attribute text
```swift
let op1 = [NSAttributedStringKey.font: font14, NSAttributedStringKey.foregroundColor: hexcolor(0x444444)]
let op2 = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: hexcolor(0x1db593)]
let attributeText = Maker.makeAttributeText(prefix: ("  你的密码是: ", op1), mid: ("123456", op2), suffix: (" 请牢记!", op1))
```

UI
```swift
let loginBtn = Maker.makeBtn(title: "登录账号",
                                     textColor: hexcolor(0x666666),
                                     font: font14,
                                     bgcolor: nil,
                                     target: self,
                                     action: #selector(jumpLogin(_:)))
view.addSubview(loginBtn)
```

## Required

- [x] Xcode 9.x
- [x] Swift 4.x

## 安装
- Swift Version < 4.2

```
pod repo update
pod "FGToolKit", "~>2.1"
```

- Swift Version >= 4.2

```
pod repo update
pod "FGToolKit", "~>2.1.1"
```
