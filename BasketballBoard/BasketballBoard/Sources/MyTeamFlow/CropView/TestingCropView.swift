//
//  TestingCropView.swift
//  BasketballBoard
//
//  Created by Eva on 21.06.2024.
//

import SwiftUI

struct TestingCropView: View {
    var body: some View {
        CropView(image: UIImage(resource: .ball),
                 maskShape: .circle,
                 configuration: SwiftyCropConfiguration()) { _ in
        }
    }
}

#Preview {
    TestingCropView()
}
