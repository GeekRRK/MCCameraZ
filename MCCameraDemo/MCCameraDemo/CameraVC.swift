//
//  CameraVC.swift
//  MCCameraDemo
//
//  Created by Al on 2020/5/11.
//  Copyright © 2020 meicet. All rights reserved.
//

import UIKit
import MCCamera

class CameraVC: UIViewController {

    var previewView: MCCameraPreviewView!
    var camera = MCCamera()
    var ble = MCBLE()
    var curLightIndex = 0
    
    let defaultLightValues = [175, 255, 215, 255, 255]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewView = MCCameraPreviewView(frame: CGRect(x: 0, y: -64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.insertSubview(previewView, at: 0)

        camera.setupWithPreview(previewView, successBlock: { [unowned self] in
            self.ble.setup()
            self.ble.delegate = self
            self.ble.startScan()
            
            self.refreshOrientation()
        }, failureBlock: {
            
        })
        camera.delegate = self
    }

    @IBAction func clickCaptureBtn(_ sender: UIButton) {
        ble.lightupAt(curLightIndex, value: defaultLightValues[curLightIndex])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.camera.capture(forLight: self.curLightIndex)
        }
    }
    
}

extension CameraVC: MCBLEDelegate {
    func requestOpenBLE() {
        
    }
    
    func didConnect() {
        
    }
    
    func didDisconnect() {
        
    }
}

extension CameraVC: MCCameraDelegate {
    func requestOpenCamera() {
        
    }
    
    func didGenerateImage(image: UIImage) {
        if self.curLightIndex == 4 {
            self.curLightIndex = 0
            
            return
        }
        
        curLightIndex += 1
        
        ble.lightupAt(curLightIndex, value: defaultLightValues[curLightIndex])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.camera.capture(forLight: self.curLightIndex)
        }
    }
}

extension CameraVC {
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        refreshOrientation()
    }
    
    func refreshOrientation() {
        if UIDevice.current.orientation == .portraitUpsideDown {
            previewView.videoPreviewLayer.connection?.videoOrientation = .portraitUpsideDown
            camera.setVideoOrientation(isUpsideDown: true)
        } else if UIDevice.current.orientation == .portrait {
            previewView.videoPreviewLayer.connection?.videoOrientation = .portrait
            camera.setVideoOrientation(isUpsideDown: false)
        } else {
            if UIApplication.shared.statusBarOrientation == .portraitUpsideDown {
                previewView.videoPreviewLayer.connection?.videoOrientation = .portraitUpsideDown
                camera.setVideoOrientation(isUpsideDown: true)
            } else if UIApplication.shared.statusBarOrientation == .portrait {
                previewView.videoPreviewLayer.connection?.videoOrientation = .portrait
                camera.setVideoOrientation(isUpsideDown: false)
            }
        }
    }
}
