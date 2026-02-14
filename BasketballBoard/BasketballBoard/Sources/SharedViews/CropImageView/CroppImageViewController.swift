//
//  CroppImageViewController.swift
//  BasketballBoard
//
//  Created by Rush_user on 14.02.2026.
//

import UIKit

final class CropImageViewController: UIViewController {
    
    private var currentScale: CGFloat = 1
    private var gestureStartScale: CGFloat = 1
    private let minScale: CGFloat = 1
    private let maxScale: CGFloat = 4
    private let elasticity: CGFloat = 0.25
    
    private lazy var cropContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePanGesture))
        return gesture
    }()
    
    private lazy var pinchGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self,
                                               action: #selector(handlePinchGesture))
        return gesture
    }()
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(cropContainerView)
        cropContainerView.addSubview(imageView)
        imageView.image = image
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
        view.addSubview(overlayView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let cropSize = min(view.bounds.width, view.bounds.height)
        cropContainerView.frame = CGRect(
            x: 0,
            y: 0,
            width: cropSize,
            height: cropSize
        )
        cropContainerView.center = view.center
        
        setupInitialImageFrame()
        overlayView.frame = view.bounds
        applyOverlayMask()
    }
    
    private func setupInitialImageFrame() {
        guard let image = imageView.image else { return }
        
        let containerSize = cropContainerView.bounds.size
        let imageSize = image.size
        
        let scale = max(
            containerSize.width / imageSize.width,
            containerSize.height / imageSize.height
        )
        
        let scaledWidth = imageSize.width * scale
        let scaledHeight = imageSize.height * scale
        
        imageView.frame = CGRect(
            x: (containerSize.width - scaledWidth) / 2,
            y: (containerSize.height - scaledHeight) / 2,
            width: scaledWidth,
            height: scaledHeight
        )
    }
    
    private func applyOverlayMask() {
        let overlayBounds = overlayView.bounds
        let cropFrame = cropContainerView.frame
        let lineWidth: CGFloat = 2
        
        let maskPath = UIBezierPath(rect: overlayBounds)
        
        let insetCropFrame = cropFrame.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        let circlePath = UIBezierPath(ovalIn: insetCropFrame)
        
        maskPath.append(circlePath)
        maskPath.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        overlayView.layer.mask = maskLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = circlePath.cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = lineWidth
        
        overlayView.layer.addSublayer(borderLayer)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: cropContainerView)
           
           switch gesture.state {
               
           case .changed:
               imageView.center = CGPoint(
                   x: imageView.center.x + translation.x,
                   y: imageView.center.y + translation.y
               )
               gesture.setTranslation(.zero, in: cropContainerView)
               
           case .ended, .cancelled:
               adjustImageIfNeeded()
               
           default:
               break
           }
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        
        switch gesture.state {
               
           case .began:
               gestureStartScale = currentScale
               
           case .changed:
               
               let proposedScale = gestureStartScale * gesture.scale
               let finalScale = elasticScale(for: proposedScale)
               applyScale(finalScale)
               
           case .ended, .cancelled, .failed:
               bounceScaleIfNeeded()
               
           default:
               break
           }
    }
    
    private func applyScale(_ scale: CGFloat) {
        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        currentScale = scale
    }
    
    private func elasticScale(for proposed: CGFloat) -> CGFloat {
        
        if proposed < minScale {
            let diff = minScale - proposed
            return minScale - diff * elasticity
        }
        
        if proposed > maxScale {
            let diff = proposed - maxScale
            return maxScale + diff * elasticity
        }
        
        return proposed
    }
    
    private func bounceScaleIfNeeded() {
        
        var targetScale = currentScale
        
        if currentScale < minScale {
            targetScale = minScale
        }
        
        if currentScale > maxScale {
            targetScale = maxScale
        }
        
        guard targetScale != currentScale else { return }
        
        currentScale = targetScale
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0.5,
                       options: [.allowUserInteraction]) {
            self.applyScale(targetScale)
        }
    }
    
    private func adjustImageIfNeeded() {
        let frame = imageView.frame
        let bounds = cropContainerView.bounds
        
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        // X границы
        if frame.minX > 0 {
            offsetX = -frame.minX
        }
        
        if frame.maxX < bounds.width {
            offsetX = bounds.width - frame.maxX
        }
        
        // Y границы
        if frame.minY > 0 {
            offsetY = -frame.minY
        }
        
        if frame.maxY < bounds.height {
            offsetY = bounds.height - frame.maxY
        }
        
        if offsetX != 0 || offsetY != 0 {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut) {
                self.imageView.frame = frame.offsetBy(dx: offsetX, dy: offsetY)
            }
        }
    }
    
    func cropImage() -> UIImage? {
        guard let image = imageView.image else { return nil }

           let cropSize = cropContainerView.bounds.size
           
           UIGraphicsBeginImageContextWithOptions(cropSize, false, UIScreen.main.scale)
           guard let context = UIGraphicsGetCurrentContext() else { return nil }

           let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: cropSize))
           circlePath.addClip()
           
           let frameInContainer = cropContainerView.convert(imageView.frame, from: imageView.superview)
           
           context.saveGState()
           context.translateBy(x: 0, y: 0)
           
           image.draw(in: frameInContainer)
           context.restoreGState()
           
           let finalImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           
           return finalImage
    }
}
