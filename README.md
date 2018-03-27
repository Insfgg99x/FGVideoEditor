![](/screenshoot/title.png)

[![Version](https://img.shields.io/cocoapods/v/FGVideoEditor.svg?style=flat)](http://cocoadocs.org/docsets/FGVideoEditor)
[![License](https://img.shields.io/cocoapods/l/FGVideoEditor.svg?style=flat)](http://cocoadocs.org/docsets/FGVideoEditor)
[![Platform](https://img.shields.io/cocoapods/p/FGVideoEditor.svg?style=flat)](http://cocoadocs.org/docsets/FGVideoEditor)
![Language](https://img.shields.io/badge/Language-%20Swift%204.0%20-blue.svg)

# FGVideoEditor

🎉🚀📅🌎👍🎉

史上首款跟微信朋友圈视频裁剪相似的视频裁剪开源工具

- [x]视频时长裁剪处理
- [x]视频裁剪UI
- [x]视频裁剪预

### Feathures

![](/screenshoot/1.PNG)
![](/screenshoot/2.PNG)
![](/screenshoot/3.PNG)
![](/screenshoot/4.PNG)
![](/screenshoot/5.PNG)
![](/screenshoot/6.PNG)
![](/screenshoot/7.PNG)

![](/img/demo.gif)

****观看视频演示****
[Vedio](https://pan.baidu.com/s/1UlDhhAjrWGihpgGy6wPrIA)

### Usage

#### 选取视频

```swift
let picker = UIImagePickerController.init()
picker.sourceType = .photoLibrary
picker.mediaTypes = [kUTTypeMovie as String]
picker.delegate = wkself
picker.allowsEditing = false
present(picker, animated: true, completion: nil)

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    guard let url = info[UIImagePickerControllerMediaURL] as? URL else {
        picker.dismiss(animated: true, completion: nil)
        showHUD(.error("获取不到资源"))
        return
    }
    crop(video: url)
    picker.dismiss(animated: true, completion: nil)
}
```

#### 利用预览视图裁剪，内置最小最大时长判断

```swift
private func crop(video url:URL) {
    weak var wkself = self
    let preview = FGVideoPreViewController.init(max: 10, vedio: url) { (edit, info) in
        wkself?.cropedUrl = info.url
        wkself?.navigationController?.popViewController(animated: true)
        wkself?.playCropedVideo()
    }
    navigationController?.pushViewController(preview, animated: true)
}

private func playCropedVideo() {
    guard let url = cropedUrl else {
        return
    }
    pickBtn.isHidden = true
    
    player = AVPlayer.init(url: url)
    previewLayer = AVPlayerLayer.init(player: player)
    previewLayer?.backgroundColor = UIColor.clear.cgColor
    previewLayer?.videoGravity = .resizeAspectFill
    previewLayer?.frame = view.bounds
    view.layer.insertSublayer(previewLayer!, at: 0)
    player?.play()
}
```

#### 仅使用视频裁剪能力

```swift
FGVideoEditor.shared.cropVideo(url: url, cropRange: range, completion: { (newUrl, newDuration, result) in
    guard result else {
        self.showHUD(.error("剪切失败"))
        return
    }
    print("裁剪成功，裁剪后的路径:\(newUrl)，时长:%.1f",newDuration)
})
```

#### 仅使用视频裁剪UI
```swift
let editFrame = CGRect.init(x: 50, y: screenheight - 100, width: screenwidth - 100, height: 50)
slider = FGVideoEditSliderView.init(frame: editFrame, url: url, imgw: imgw, maxduration: 10)
view.addSubview(slider)
```

>特征

- [x]var cropStart:CGFloat {get} 获取当前裁剪区域的左边界对应的时间（相对于视频开始播放的位置为0s）
- [x]var cropDuration:CGFloat {get} 获取当前裁剪区域对应的时长
- [x]var cropRange:CMTimeRange {get} 当前裁剪区域的CMTime范围
- [x]var cropWidth:CGFloat {get} 当前裁剪区域的宽度
- [x]var slidingBeginHandler:(() -> ())? {get, set} 开始滑动视频裁剪区域的左／右边界的回调
- [x]var slidingHandler:((FGSlideDirection) -> ())? {get, set} 滑动视频裁剪区域的左／右边界的回调
- [x]var slidingEndHandler:(() -> ())? {get, set} 结束左／右边界的滑动
- [x]var contentDidScrollHandler:(() -> ())? {get, set} 滑动视频帧图片横向列表的回调
- [x]var dragWillBeginHandler:(() -> ())? {get, set} 将要滑动视频帧图片横向列表的回调
- [x]var dragDidEndHandler:(() -> ())? {get, set} 结束滑动视频帧图片横向列表的回调

>示例

```swift
weak var wkself = self
slider.slidingBeginHandler = {
    wkself?.player?.pause()
    wkself?.playing = false
}
let tolerance = CMTimeMake(1, timesclae)
slider.slidingHandler = { (direction) in
    let range = (wkself ?? self).slider.cropRange
    wkself?.currentRange = range
    if direction == .left {
        wkself?.player?.seek(to: range.end)
    } else {
        wkself?.player?.seek(to: range.start,
                             toleranceBefore: tolerance,
                             toleranceAfter: tolerance)
        wkself?.player?.seek(to: range.start)
    }
}
slider.slidingEndHandler = {
    wkself?.player?.seek(to: (wkself ?? self).currentRange.start)
    wkself?.player?.play()
    wkself?.playing = true
}
slider.contentDidScrollHandler = {
    let range = (wkself ?? self).slider.cropRange
    wkself?.currentRange = range
    wkself?.player?.seek(to: range.start)
}
slider.dragWillBeginHandler = {
    wkself?.player?.pause()
    wkself?.playing = false
}
slider.dragDidEndHandler = {
    wkself?.player?.play()
    wkself?.playing = true
}
```

### 安装 Install

```swift
pod "FGVideoEditor"
```
- 若手动安装，请添加依赖：`"SnapKit"`, `"FGHUD", "~>2.4"`, `"FGToolKit"`

### Required

- [x] Xocde 9
- [x] Swift 4.x
