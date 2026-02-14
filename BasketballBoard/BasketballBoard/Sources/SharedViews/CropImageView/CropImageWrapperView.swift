//
//  CropImageWrapperView.swift
//  BasketballBoard
//
//  Created by Rush_user on 14.02.2026.
//

import SwiftUI

struct CropImageViewWrapper: UIViewControllerRepresentable {
    let image: UIImage
    @Binding var cropTrigger: Bool
    var onCrop: (UIImage) -> Void

    func makeUIViewController(context: Context) -> CropImageViewController {
        let vc = CropImageViewController()
        vc.image = image
        return vc
    }

    func updateUIViewController(_ uiViewController: CropImageViewController, context: Context) {
        if cropTrigger {
            if let croppedImage = uiViewController.cropImage() {
                onCrop(croppedImage)
            }
            cropTrigger = false
        }
    }
}
