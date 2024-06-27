//
//  PickPhotoOrCameraView.swift
//  BasketballBoard
//
//  Created by Eva on 27.06.2024.
//

import SwiftUI
import PhotosUI

struct PickPhotoOrCameraView: View {
    @Environment(\.dismiss) var dismiss
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var pickedTeamImage: UIImage?
    @Binding var croppedTeamImage: UIImage?
    
    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            
                            Image(uiImage: croppedTeamImage ?? UIImage(resource: .teamPlaceholder))
                                .resizable()
                                .scaledToFit()
                                .frame(width: proxy.size.width * 0.8, alignment: .center)
                                .background(.black.opacity(0.1))
                                .clipShape(Circle())
                            
                            Spacer()
                        }
                        .offset(y: proxy.size.height * 0.05)
                        
                        Spacer()
                        
                        Text("Photo selection")
                        
                        HStack(spacing: 20) {
                            Button {
                                
                            } label: {
                                Image(systemName: "camera")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width * 0.1)
                                    .padding(EdgeInsets(top: 40, leading: 50, bottom: 40, trailing: 50))
                                    .background(.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            
                            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: proxy.size.width * 0.1)
                                    .padding(EdgeInsets(top: 40, leading: 50, bottom: 40, trailing: 50))
                                    .background(.green.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if let pickedTeamImage = pickedTeamImage {
                        CropView(image: pickedTeamImage,
                                 maskShape: .circle,
                                 configuration: SwiftyCropConfiguration()) { croppedImage in
                            croppedTeamImage = croppedImage
                        }
                    }
                }
            }
            .navigationTitle("Team photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    
                    } label: {
                        Text("save")
                    }
                    .disabled(true)
                }
            }
            .onChange(of: photoPickerItem) { _, _ in
                Task {
                    if let photoPickerItem = photoPickerItem,
                       let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            pickedTeamImage = image
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    PickPhotoOrCameraView()
//}
