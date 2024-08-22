//
//  CreateNewTeamScreen.swift
//  BasketballBoard
//
//  Created by Eva on 18.06.2024.
//

import SwiftUI
import PhotosUI

struct CreateNewTeamScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MyTeamViewModel
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var shouldShowCropView = false
    @State private var teamNameText: String = ""
    @State private var teamImage: UIImage?
    @State private var croppedTeamImage: UIImage?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center) {
                            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                                Image(uiImage: croppedTeamImage ?? UIImage(resource: .teamPlaceholder))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .interactiveDismissDisabled()
                            
                            Text("add photo")
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    TextField("Name of team", text: $teamNameText)
                }
            }
            .listSectionSpacing(15)
            
            .scrollDismissesKeyboard(.interactively)
            .ignoresSafeArea(.keyboard)
            
            .navigationTitle("New team")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: photoPickerItem) { _, _ in
                Task {
                    if let photoPickerItem = photoPickerItem,
                       let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            teamImage = image
                        }
                    }
                }
            }
            
            .onChange(of: teamImage) {
                shouldShowCropView = teamImage != nil
                photoPickerItem = nil
            }
            
            .fullScreenCover(isPresented: $shouldShowCropView) {
                CropView(image: teamImage!,
                         maskShape: .circle,
                         configuration: SwiftyCropConfiguration()) { croppedImage in
                    croppedTeamImage = croppedImage
                    shouldShowCropView.toggle()
                } onCancelCompletion: {
                    shouldShowCropView.toggle()
                }
                .toolbar(.hidden)
                .transition(.opacity)
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addNewTeam(name: teamNameText, imageData: croppedTeamImage?.pngData())
                        dismiss()
                    } label: {
                        Text("save")
                    }
                    .disabled(teamNameText.isEmpty)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                    }
                }
            }
        }
    }
}

#Preview {
    CreateNewTeamScreen()
        .environmentObject(MyTeamViewModel())
}
