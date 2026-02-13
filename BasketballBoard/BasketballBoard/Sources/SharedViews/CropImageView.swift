//
//  CropImageView.swift
//  BasketballBoard
//
//  Created by Rush_user on 13.02.2026.
//

import SwiftUI

struct CropImageView: View {
    var image: UIImage?
    var onCrop: (UIImage?, Bool) -> ()
    
    @Environment(\.dismiss) var dismiss
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    var body: some View {
        NavigationStack {
            imageView()
                .navigationTitle ("Crop View")
                .navigationBarTitleDisplayMode(. inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.gray.opacity(0.3), for: .navigationBar)
                .toolbarColorScheme(.light, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.black
                    .ignoresSafeArea())
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            let renderer = ImageRenderer(content: imageView())
                            renderer.proposedSize = .init(width: 300, height: 300)
                            if let image = renderer.uiImage {
                                onCrop(image, true)
                            } else {
                                onCrop(nil, false)
                            }
                            dismiss()
                        } label: {
                            Image (systemName:"checkmark")
                                .font(.callout)
                                .fontWeight (.semibold)
                        }
                    }
                }
            
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image (systemName:"xmark")
                                .font(.callout)
                                .fontWeight (.semibold)
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func imageView() -> some View {
        let cropSize = CGSize(width: 300, height: 300)
        GeometryReader {
            let size = $0.size
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            Color.clear
                                .onChange(of: isInteracting) { _, newValue in
                                     if !newValue {
                                         withAnimation(.easeInOut(duration: 0.2)) {
                                             if rect.minX > 0 {
                                                 offset.width = (offset.width - rect.minX)
                                             }
                                             
                                             if rect.minY > 0 {
                                                 offset.height = (offset.height - rect.minY)
                                             }
                                             
                                             if rect.maxX < size.width {
                                                 offset.width = (rect.minX - offset.width)
                                             }
                                             
                                             if rect.maxY < size.height {
                                                 offset.height = (rect.minY - offset.height)
                                             }
                                         }
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(size)
                    .onChange(of: isInteracting) { _, newValue in
                        if !newValue {
                            lastStoredOffset = offset
                        }
                    }
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting,
                          body: { _, out, _ in
                              out = true
                          }).onChanged({ value in
                              let translation = value.translation
                              offset = .init(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                          })
        )
        .gesture(
            MagnifyGesture()
                .updating($isInteracting,
                          body: { _, out, _ in
                              out = true
                          }).onChanged({ value in
                              let updatedScale = value.magnification + lastScale
                              scale = (updatedScale < 1 ? 1 : updatedScale)
                          }).onEnded({ value in
                              withAnimation(.easeInOut(duration: 0.2)) {
                                  if scale < 1 {
                                      scale = 1
                                      lastScale = 0
                                  } else {
                                      lastScale = scale - 1
                                  }
                              }
                          })
        )
        .frame(cropSize)
        .cornerRadius(cropSize.width / 2)
    }
}

extension View {
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
}

struct CropImageView_Previews: PreviewProvider {
    static var previews: some View {
        CropImageView(image: UIImage(resource: .board)) { _, _ in
            
        }
    }
}

