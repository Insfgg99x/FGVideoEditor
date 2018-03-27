

//
//  FGVideoPreViewController.swift
//  FGVideoEditor
//
//  Created by xia on 2018/3/25.
//  Copyright © 2018年 appsboulevard. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit
import FGToolKit
import FGHUD

public class FGVideoPreViewController: UIViewController {
    var shouldDeleteOriginalVideo = false
    private var maxduration:CGFloat = 10
    private var comletionHandler:((FGVideoPreViewController, FGVideoInfo) -> ())?
    private var videourl:URL?
    private let framesInScreen = 10
    private var croph:CGFloat = 50
    private var imgh:CGFloat = 50
    private var imgw:CGFloat = 50
    private var duration:CGFloat = 0
    private var player:AVPlayer?
    private var playBtn:UIButton?
    private var playing = false
    private var topBar:UIView?
    private var botBar:UIView?
    private var cancelBtn:UIButton?
    private var confirmBtn:UIButton?
    private var editBtn = UIButton.init()
    private var bottomDoneBtn = UIButton.init()
    private var backBtn:UIButton?
    private var previewLayer:AVPlayerLayer?
    private var slider:FGVideoEditSliderView!
    private var currentRange = kCMTimeRangeZero
    private var croping = false
    private var cropedUrl = URL.init(fileURLWithPath: NSHomeDirectory())
    private var overLengtLb = UILabel.init()
    private var timesclae:CMTimeScale = 600
    private var croped = false
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createUI()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        if playing {
            player?.pause()
            player = nil
        }
    }
}
public extension FGVideoPreViewController {
    public convenience init(max duration:CGFloat, vedio url:URL, finishHandler:((FGVideoPreViewController, FGVideoInfo) -> ())?) {
        self.init()
        maxduration = duration
        videourl = url
        comletionHandler = finishHandler
    }
}
private extension FGVideoPreViewController {
    @objc private func enterBackground() {
        player?.pause()
        playing = false
    }
    @objc private func didEnterForceground() {
        if croping {
            if !playing {
                player?.play()
                playing = true
            }
        }
    }
}
private extension FGVideoPreViewController {
    private func setup() {
        view.backgroundColor = .black
        //fd_interactivePopDisabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForceground), name: .UIApplicationDidBecomeActive, object: nil)
    }
    private func createUI() {
        topBar = UIView.init()
        topBar?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.7)
        view.addSubview(topBar!)
        topBar?.snp.makeConstraints({ (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        })
        
        backBtn = UIButton.init()
        backBtn?.setImage(UIImage.init(named: "whiteback"), for: .normal)
        backBtn?.contentHorizontalAlignment = .left
        backBtn?.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        topBar?.addSubview(backBtn!)
        backBtn?.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        
        botBar = UIView.init()
        botBar?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.7)
        view.addSubview(botBar!)
        botBar?.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        })

        editBtn.setTitle("编辑", for: .normal)
        editBtn.titleLabel?.font = font14
        editBtn.setTitleColor(.white, for: .normal)
        editBtn.contentHorizontalAlignment = .left
        editBtn.addTarget(self, action: #selector(editAction(_:)), for: .touchUpInside)
        botBar?.addSubview(editBtn)
        editBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 50, height: 40))
        }
        
        bottomDoneBtn.setTitle("完成", for: .normal)
        bottomDoneBtn.titleLabel?.font = font14
        bottomDoneBtn.setTitleColor(.white, for: .normal)
        bottomDoneBtn.setTitleColor(hexcolor(0x4b8b5c), for: .disabled)
        bottomDoneBtn.backgroundColor = hexcolor(0x00b919)
        bottomDoneBtn.layer.cornerRadius = 4
        bottomDoneBtn.addTarget(self, action: #selector(bottomDoneAction(_:)), for: .touchUpInside)
        botBar?.addSubview(bottomDoneBtn)
        bottomDoneBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 50, height: 30))
        }
        
        playBtn = UIButton.init()
        playBtn?.setImage(UIImage.init(named: "img_play"), for: .normal)
        playBtn?.addTarget(self, action: #selector(playAction(_:)), for: .touchUpInside)
        view.addSubview(playBtn!)
        playBtn?.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 85, height: 85))
        }
        guard let url = videourl else {
            showHUD(.error("获取不到资源"))
            return
        }
        
        let asset = AVAsset.init(url: url)
        let total = asset.duration
        duration = CGFloat(CMTimeGetSeconds(total))
        timesclae = total.timescale
        currentRange = CMTimeRangeMake(kCMTimeZero, total)
        
        player = AVPlayer.init(url: url)
        previewLayer = AVPlayerLayer.init(player: player!)
        previewLayer?.contentsGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
        previewLayer?.frame = view.bounds
        previewLayer?.backgroundColor = UIColor.clear.cgColor
        view.layer.insertSublayer(previewLayer!, at: 0)
        let py = self.player!
        py.addPeriodicTimeObserver(forInterval: CMTimeMake(10, total.timescale), queue: nil, using: { (current) in
            if current >= self.currentRange.end {
                self.playEnd()
            }
            if self.slider != nil {
                if !self.slider.isHidden {
                    let w = self.slider.cropWidth
                    let currentDuration = CGFloat(CMTimeGetSeconds(self.currentRange.duration))
                    let currentMin = CGFloat(CMTimeGetSeconds(self.currentRange.start))
                    let currentmax = CGFloat(CMTimeGetSeconds(self.currentRange.end))
                    let currenttime = CGFloat(CMTimeGetSeconds(py.currentTime()))
                    guard currenttime >= currentMin, currenttime <= currentmax else {
                        return
                    }
                    let tmp = currenttime - currentMin
                    guard tmp > 0.0 else {
                        return
                    }
                    let speed = w / currentDuration
                    let xpos = speed * tmp
                    self.slider.indicatorXpos = xpos
                }
            }
        })
        
        guard duration >= minvideoduration else {
            let toshortLb = UILabel.init()
            toshortLb.text = "不能分享小于1秒的视频"
            toshortLb.font = font14
            toshortLb.textAlignment = .right
            toshortLb.textColor = .white
            topBar?.addSubview(toshortLb)
            toshortLb.snp.makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalToSuperview()
                make.width.equalTo(200)
                make.height.equalTo(20)
            })
            editBtn.isHidden = true
            bottomDoneBtn.backgroundColor = hexcolor(0x005917)
            bottomDoneBtn.isEnabled = false
            return
        }
        if duration > maxduration {
            bottomDoneBtn.isHidden = true
            editBtn.setTitleColor(hexcolor(0x00ae17), for: .normal)
            editBtn.contentHorizontalAlignment = .right
            editBtn.snp.remakeConstraints({ (make) in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 50, height: 30))
            })
            
            overLengtLb.text = "只能分享\(Int(maxduration))秒内的视频，需要进行编辑"
            overLengtLb.textColor = .white
            overLengtLb.font = font14
            overLengtLb.adjustsFontSizeToFitWidth = true
            botBar?.addSubview(overLengtLb)
            overLengtLb.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(20)
                make.centerY.equalToSuperview()
                make.right.equalTo(bottomDoneBtn.snp.left).offset(-20)
            })
        }
    }
}
private extension FGVideoPreViewController {
    @objc private func backAction() {
        player?.pause()
        player = nil
        navigationController?.popViewController(animated: true)
    }
    @objc private func editAction(_ sender:UIButton) {
        guard let url = videourl else {
            showHUD(.error("获取不到资源"))
            return
        }
        croping = true
        
        topBar?.isHidden       = true
        playBtn?.isHidden      = true
        backBtn?.isHidden      = true
        editBtn.isHidden       = true
        bottomDoneBtn.isHidden = true
        overLengtLb.isHidden   = true
        if !playing {
            playing = true
            player?.play()
        }
        if cancelBtn == nil {
            cancelBtn = UIButton.init()
            cancelBtn?.setTitle("取消", for: .normal)
            cancelBtn?.setTitleColor(.white, for: .normal)
            cancelBtn?.titleLabel?.font = font14
            cancelBtn?.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
            botBar?.addSubview(cancelBtn!)
            cancelBtn?.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 50, height: 30))
            }
        }
        cancelBtn?.isHidden = false
        
        if confirmBtn == nil {
            confirmBtn = UIButton.init()
            confirmBtn?.setTitle("完成", for: .normal)
            confirmBtn?.setTitleColor(hexcolor(0x00ae17), for: .normal)
            confirmBtn?.titleLabel?.font = font14
            confirmBtn?.addTarget(self, action: #selector(confrimEditAction(_:)), for: .touchUpInside)
            botBar?.addSubview(confirmBtn!)
            confirmBtn?.snp.makeConstraints { (make) in
                make.right.equalToSuperview().offset(-10)
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize.init(width: 50, height: 30))
            }
        }
        confirmBtn?.isHidden = false
        
        let newH = CGFloat(screenheight - 100)
        let newW = CGFloat(screenwidth) / CGFloat(screenheight) * newH
        let marginx = (CGFloat(screenwidth) - newW) / 2
        previewLayer?.frame = .init(x: marginx, y: 0, width: newW, height: newH)
        
        imgw = newW / CGFloat(framesInScreen)//裁剪区域范围为固定10帧宽度
        
        if slider == nil {
            let editFrame = CGRect.init(x: marginx, y: CGFloat(screenheight - 100), width: newW, height: imgh)
            slider = FGVideoEditSliderView.init(frame: editFrame, url: url, imgw: imgw, maxduration: 10)
            view.addSubview(slider)
            slider.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(marginx)
                make.right.equalToSuperview().offset(-marginx)
                make.bottom.equalToSuperview().offset(-50)
                make.height.equalTo(imgh)
            }
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
        }
        slider.isHidden = false
    }
    @objc private func bottomDoneAction(_ sender:UIButton) {
        sender.isEnabled = false
        guard videourl != nil else {
            showHUD(.error("资源加载失败"))
            return
        }
        var info:FGVideoInfo? = nil
        if croped {
             info = FGVideoEditTool.videoInfo(cropedUrl, at: 0)
            if shouldDeleteOriginalVideo {
                do {
                    try FileManager.default.removeItem(at: videourl!)
                } catch {
                    
                }
            }
            FGVideoEditor.shared.save(vedio: cropedUrl, hud: false)
        } else {
            info = FGVideoEditTool.videoInfo(videourl!, at: 0)
        }
        if comletionHandler != nil {
            comletionHandler?(self, info!)
        }
    }
    private func cancelEditing(_ success:Bool) {
        topBar?.isHidden       = false
        cancelBtn?.isHidden    = true
        confirmBtn?.isHidden   = true
        backBtn?.isHidden      = false
        previewLayer?.frame    = view.bounds
        slider.isHidden        = true
        slider?.isHidden       = true
        playBtn?.isHidden      = true
        editBtn.isHidden       = false
        refreshBottom(success)
    }
    private func refreshBottom(_ success:Bool) {
        if !success {
            if duration > maxduration {
                overLengtLb.isHidden   = false
                bottomDoneBtn.isHidden = true
                editBtn.snp.remakeConstraints({ (make) in
                    make.right.equalToSuperview().offset(-20)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize.init(width: 50, height: 30))
                })
                editBtn.setTitleColor(hexcolor(0x00ae17), for: .normal)
            } else {
                overLengtLb.isHidden   = true
                bottomDoneBtn.isHidden = false
                editBtn.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(20)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize.init(width: 50, height: 40))
                }
                editBtn.setTitleColor(.white, for: .normal)
            }
        } else {
            if duration > maxduration {
                let currentDuration = CGFloat(currentRange.duration.value) / CGFloat(currentRange.duration.timescale)
                if currentDuration > maxduration {
                    overLengtLb.isHidden   = false
                    bottomDoneBtn.isHidden = true
                    editBtn.snp.remakeConstraints({ (make) in
                        make.right.equalToSuperview().offset(-20)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(CGSize.init(width: 50, height: 30))
                    })
                    editBtn.setTitleColor(hexcolor(0x00ae17), for: .normal)
                } else {
                    overLengtLb.isHidden   = true
                    bottomDoneBtn.isHidden = false
                    editBtn.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(20)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(CGSize.init(width: 50, height: 40))
                    }
                    editBtn.setTitleColor(.white, for: .normal)
                }
            } else {
                overLengtLb.isHidden   = true
                bottomDoneBtn.isHidden = false
                editBtn.snp.remakeConstraints { (make) in
                    make.left.equalToSuperview().offset(20)
                    make.centerY.equalToSuperview()
                    make.size.equalTo(CGSize.init(width: 50, height: 40))
                }
                editBtn.setTitleColor(.white, for: .normal)
            }
        }
    }
    @objc func cancelAction(_ sender: UIButton) {
        sender.isEnabled = false
        cancelEditing(false)
        self.player?.pause()
        self.playing = false
        sender.isEnabled = true
    }
    @objc private func confrimEditAction(_ sender:UIButton) {
        guard let url = videourl else {
            showHUD(.error("获取不到资源"))
            return
        }
        let range = slider.cropRange
        //cut video
        botBar?.isUserInteractionEnabled = false
        showHUD(.loading("处理中"))
        FGVideoEditor.shared.cropVideo(url: url, cropRange: range, completion: { (newUrl, newDuration, result) in
            guard result else {
                self.showHUD(.error("剪切失败"))
                DispatchQueue.main.async {
                    self.botBar?.isUserInteractionEnabled = true
                }
                return
            }
            self.croped = true
            self.currentRange = range
            self.cropedUrl = newUrl
            self.player?.seek(to: range.start)
            self.player?.play()
            self.playing = true
            DispatchQueue.main.async {
                self.cancelEditing(true)
            }
            self.hideHUD()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.botBar?.isUserInteractionEnabled = true
            })
        })
    }
    @objc private func playAction(_ sender:UIButton) {
        if croping {
            return
        }
        sender.isHidden = true
        player?.play()
        playing = true
    }
    @objc private func playEnd() {
        if croping {
            playBtn?.isHidden = true
            player?.seek(to: currentRange.start)
            player?.play()
        } else {
            playBtn?.isHidden = false
            playing = false
            player?.seek(to: currentRange.start)
        }
    }
}
extension FGVideoPreViewController {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if croping {
            return
        }
        if playing {
            player?.pause()
            playing = false
            playBtn?.isHidden = false
        } else {
            player?.play()
            playing = true
            playBtn?.isHidden = true
        }
    }
}

