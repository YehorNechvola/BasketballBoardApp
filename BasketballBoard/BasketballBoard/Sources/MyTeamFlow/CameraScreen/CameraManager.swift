//
//  CameraViewModel.swift
//  BasketballBoard
//
//  Created by Eva on 01.07.2024.
//

import UIKit
import AVFoundation

final class CameraManager: NSObject, ObservableObject {
    
    enum CameraTourchState {
        case on
        case off
        case unavailable
    }
    
    //MARK: - Properties
    var captureSession = AVCaptureSession()
    private var photoOutput = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var isRecording = false
    @Published var cameraTourchState: CameraTourchState = .off
    
    //MARK: - Methods Setup Camera
    func setupPreviewLayerFrame(view: Any) {
        let view = view as! UIView
        previewLayer.frame = view.bounds
    }
    
    func setupCamera() {
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }

        do {
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.addInput(input)
            captureSession.addOutput(photoOutput)
            captureSession.sessionPreset = .photo
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession.startRunning()
            }
            
        } catch {
            print("Error setting up camera: \(error.localizedDescription)")
        }
    }
    
    func stopSession() {
        captureSession.stopRunning()
    }
    
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func switchCamera() {
        guard let currentCameraInput = captureSession.inputs.last as? AVCaptureDeviceInput else { return }
        guard let videoCaptureDevice = (currentCameraInput.device.position == .back) ?
                AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) :
                    AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
        cameraTourchState = videoCaptureDevice.position == .front ? .unavailable : .off
        
        do {
            let newInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            captureSession.beginConfiguration()
            captureSession.removeInput(currentCameraInput)
            
            if captureSession.canAddInput(newInput) {
                captureSession.addInput(newInput)
            }
            
            DispatchQueue.global(qos: .userInteractive).async {
                self.captureSession.commitConfiguration()
            }
            
        } catch {
            print("Error switching camera: \(error.localizedDescription)")
        }
    }
    
    func toggleFlash() {
        guard let currentCameraInput = captureSession.inputs.last as? AVCaptureDeviceInput else { return }
        guard currentCameraInput.device.hasTorch else { 
            cameraTourchState = .unavailable
            return
        }
        
        do {
            try currentCameraInput.device.lockForConfiguration()
            currentCameraInput.device.torchMode = currentCameraInput.device.isTorchActive ? .off : .on
            cameraTourchState = currentCameraInput.device.isTorchActive ? .off : .on
            currentCameraInput.device.unlockForConfiguration()
        } catch {
            print("Device tourch Flash Error ");
        }
    }
}

//MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        if let imageData = photo.fileDataRepresentation() {
            if let image = UIImage(data: imageData) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}

