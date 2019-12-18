//
//  ViewController.swift
//  CCQRCode
//
//  Created by cyd on 2018/7/9.
//  Copyright © 2018 cyd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "单击view进入相册"
        self.view.backgroundColor = UIColor.white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = .savedPhotosAlbum
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1.取到图片
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        // 2.生成CIImage
        let ciimage = CIImage(cgImage: image!.cgImage!)
        // 3.识别精度
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]

        /**
         4.创建识别器，3个参数

         ofType：识别类型
         CIDetectorTypeFace      面部识别
         CIDetectorTypeText      文本识别
         CIDetectorTypeQRCode    条码识别
         CIDetectorTypeRectangle 矩形识别

         context：上下文，默认传nil

         options：识别精度
         CIDetectorAccuracyLow  低精度，识别速度快
         CIDetectorAccuracyHigh 高精度，识别速度慢
         */
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)

        /**
         5.获取识别结果，2个参数

         in：需要识别的图片

         options：需要识别的特征
         CIDetectorMinFeatureSize: 指定最小尺寸的检测器，小于这个尺寸的特征将不识别，CIDetectorTypeFace(0.01 ~ 0.50)，CIDetectorTypeText(0.00 ~ 1.00)，CIDetectorTypeRectangle(0.00 ~ 1.00)
         CIDetectorTracking: 是否开启面部追踪 TRUE 或 FALSE
         CIDetectorMaxFeatureCount: 设置返回矩形特征的最多个数 1 ~ 256 默认值为1
         CIDetectorNumberOfAngles: 设置角度的个数 1, 3, 5, 7, 9, 11
         CIDetectorImageOrientation: 识别方向
         CIDetectorEyeBlink: 眨眼特征
         CIDetectorSmile: 笑脸特征
         CIDetectorFocalLength: 每帧焦距
         CIDetectorAspectRatio: 矩形宽高比
         CIDetectorReturnSubFeatures: 文本检测器是否应该检测子特征，默认值是否
         */
        let features = detector?.features(in: ciimage, options: nil)

        picker.dismiss(animated: true, completion: nil)
        // 遍历出二维码(通过截屏的二维码很容易识别出，如果是拍照的二维码，很可能识别不出来)
        for item in features! where item.isKind(of: CIQRCodeFeature.self) {
            let ms = (item as! CIQRCodeFeature).messageString ?? ""
            let vc = UIAlertController(title: "提示", message: ms, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (_) in

            }))
            self.present(vc, animated: true, completion: nil)
            return
        }
        let vc = UIAlertController(title: "提示", message: "没有识别到二维码", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (_) in

        }))
        self.present(vc, animated: true, completion: nil)
        return
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

