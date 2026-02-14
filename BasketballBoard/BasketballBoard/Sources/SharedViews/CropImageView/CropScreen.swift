//
//  CropScrenn.swift
//  BasketballBoard
//
//  Created by Rush_user on 14.02.2026.
//

import SwiftUI

struct CropScreen: View {
    let image: UIImage
    @Binding var cropButtonTapped: Bool
    @Environment(\.dismiss) private var dismiss
    let onCrop: (UIImage) -> Void

    var body: some View {
        NavigationStack {
            CropImageViewWrapper(image: image, cropTrigger: $cropButtonTapped) { cropped in
                onCrop(cropped)
                cropButtonTapped = false
            }
            .edgesIgnoringSafeArea(.all)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button() {
                        dismiss()
                    } label : {
                        Image (systemName:"xmark")
                            .foregroundStyle(.white)
                            .font(.callout)
                            .fontWeight (.semibold)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button() {
                        cropButtonTapped = true
                        dismiss()
                    } label: {
                        Image (systemName:"checkmark")
                            .foregroundStyle(.white)
                            .font(.callout)
                            .fontWeight (.semibold)
                    }
                }
            }
        }
    }
}

