//
//  ViewController.swift
//  FGVideoEditor
//
//  Created by xgf on 2018/3/27.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import FGToolKit
import AVFoundation
import SnapKit
import MobileCoreServices

class ViewController: UIViewController {
    private var pickBtn = UIButton.init()
    private var player :AVPlayer?
    private var previewLayer :AVPlayerLayer?
    private var cropedUrl:URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        createUI()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension ViewController {
    private func setup() {
        view.backgroundColor = .white
        title = "FGVideoEditor Demo"
        NotificationCenter.default.addObserver(self, selector: #selector(didPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resume), name: .UIApplicationDidBecomeActive, object: nil)
    }
    private func createUI() {
        weak var wkself = self
        pickBtn = Maker.makeBtn(title: "选取视频",
                                textColor: .white,
                                font: UIFont.systemFont(ofSize: 16),
                                bgcolor: .darkGray,
                                handler: { (sender) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                return
            }
            let picker = UIImagePickerController.init()
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.delegate = wkself
            picker.allowsEditing = false
            wkself?.present(picker, animated: true, completion: nil)
        })
        pickBtn.layer.cornerRadius = 2
        view.addSubview(pickBtn)
        pickBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 80, height: 40))
        }
    }
}
extension ViewController :UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let url = info[UIImagePickerControllerMediaURL] as? URL else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        crop(video: url)
        picker.dismiss(animated: true, completion: nil)
    }
}
//MARK: - 裁剪视频
extension ViewController {
    private func crop(video url:URL) {
        weak var wkself = self
        let preview = FGVideoPreViewController.init(maxDuration: 10, vedio: url) { (edit, info, result) in
            wkself?.navigationController?.popViewController(animated: true)
            guard result, let cropedInfo = info else {
                wkself?.showHUD(.error("裁剪失败"))
                return
            }
            wkself?.cropedUrl = cropedInfo.url
            wkself?.playCropedVideo()
        }
        navigationController?.pushViewController(preview, animated: true)
    }
}
//MARK: - 播放裁剪后的视频
extension ViewController {
    private func playCropedVideo() {
        guard let url = cropedUrl else {
            return
        }
        pickBtn.isHidden = true
        
        player = AVPlayer.init(url: url)
        previewLayer = AVPlayerLayer.init(player: player)
        previewLayer?.backgroundColor = UIColor.clear.cgColor
        previewLayer?.videoGravity = .resizeAspect
        previewLayer?.frame = view.bounds
        
        view.layer.insertSublayer(previewLayer!, at: 0)
        player?.play()
    }
}
extension ViewController {
    @objc private func didPlayToEnd() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    @objc private func pause() {
        player?.pause()
    }
    @objc private func resume() {
        player?.play()
    }
}
