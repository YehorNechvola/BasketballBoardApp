//
//  CameraPreview.swift
//  BasketballBoard
//
//  Created by Eva on 01.07.2024.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    let frame: CGRect
    @ObservedObject var cameraManager: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        cameraManager.previewLayer = AVCaptureVideoPreviewLayer(session: cameraManager.captureSession)
        cameraManager.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraManager.previewLayer.frame = self.frame
        view.layer.insertSublayer(cameraManager.previewLayer, at: 0)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}
