//
//  CameraView.swift
//  BasketballBoard
//
//  Created by Eva on 01.07.2024.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var shouldShowBlurView = false
    @State private var shouldApplyPhotoClick = false
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                let frame = CGRect(origin: CGPoint(x: 0, y: 50),
                                   size: CGSize(width: proxy.size.width, height: proxy.size.width * 1.333))
                
                CameraPreview(frame: frame, cameraManager: cameraManager)
            }
            
            GeometryReader { proxy in
                BlurView(style: .systemUltraThinMaterialDark)
                    .opacity(shouldShowBlurView ? 1 : 0)
                    .frame(height: proxy.size.width * 1.333)
                    .offset(y: 50)
            }
            
            
            GeometryReader { proxy in
                Color(.black.withAlphaComponent(0.8))
                    .opacity(shouldApplyPhotoClick ? 1 : 0)
                    .frame(height: proxy.size.width * 1.333)
                    .offset(y: 50)
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                Button {
                    cameraManager.toggleFlash()
                } label: {
                    Image(systemName: cameraManager.cameraTourchState == .on ? "bolt.circle" : "bolt.slash.circle" )
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .tint(.white)
                        .foregroundStyle(cameraManager.cameraTourchState == .on ? Color.yellow : Color.white.opacity(0.8))
                }
                
                HStack  {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .foregroundStyle(.white)
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    }
                    .offset(x: 30)
                    
                    Spacer()
                    
                    Button {
                        shouldApplyPhotoClick.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            shouldApplyPhotoClick.toggle()
                        }
                        cameraManager.capturePhoto()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .animation(.linear(duration: 0.1), value: shouldApplyPhotoClick)
                                .frame(width: shouldApplyPhotoClick ? 68 : 70,
                                       height: shouldApplyPhotoClick ? 68 : 70)
                            
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                                .frame(width: 80, height: 80)
                        }
                    }
                    .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.6),
                                     trigger: shouldApplyPhotoClick) { $1 == true }
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            shouldShowBlurView.toggle()
                        } completion: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    shouldShowBlurView.toggle()
                                }
                            }
                        }
                        cameraManager.switchCamera()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.circle")
                            .resizable()
                            .foregroundStyle(.white)
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                    }
                    .disabled(shouldShowBlurView)
                    .offset(x: -30)
                }
                .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.6),
                                 trigger: shouldShowBlurView) { $1 == true }
            }
        }
        .background(.black)
        .onAppear {
            cameraManager.setupCamera()
        }
        
        .onDisappear {
            cameraManager.stopSession()
        }
    }
}

#Preview {
    CameraView()
}
