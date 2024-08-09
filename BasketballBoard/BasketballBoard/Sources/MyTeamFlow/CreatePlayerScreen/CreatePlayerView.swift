//
//  CreatePlayerView.swift
//  BasketballBoard
//
//  Created by Eva on 09.08.2024.
//

import SwiftUI
import PhotosUI


struct CreatePlayerView: View {
    @EnvironmentObject var viewModel: MyTeamViewModel
    @Environment(\.dismiss) var dismiss
    @State private var shouldShowCropView = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var playerImage: UIImage?
    @State private var croppedPlayerImage: UIImage?
    @State private var selectedPosition: Player.PlayerPosition = .pointGuard
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    private var playerImagePadding: CGFloat {
        if let _ = croppedPlayerImage {
            0
        } else {
            30
        }
    }
    
    private var playerImageWidth: CGFloat {
        if let _ = croppedPlayerImage {
            200
        } else {
            150
        }
    }
    
    @State private var name: String = ""
    @State private var surname: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .center) {
                            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                                Image(uiImage: croppedPlayerImage ?? UIImage(resource: .playerPlaceholder))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: playerImageWidth, height: playerImageWidth)
                                    .padding(EdgeInsets(top: playerImagePadding,
                                                        leading: playerImagePadding,
                                                        bottom: playerImagePadding,
                                                        trailing: playerImagePadding))
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(Circle()
                                        .stroke(.black, lineWidth: 1)
                                    )
                            }
                            
                            Text("add photo")
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
                    TextField("Name", text: $name)
                    TextField("Surname", text: $surname)
                    Text("Date of birth")
                        .foregroundStyle(.placeholder)
                        .onTapGesture {
                            showDatePicker.toggle()
                        }
                    
                    Picker("Position", selection: $selectedPosition) {
                        ForEach(Player.PlayerPosition.allCases) { position in
                            Text(position.positionToString).tag(position)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundStyle(.placeholder)
                }
            }
            
            .navigationTitle("New player")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: photoPickerItem) { _, _ in
                Task {
                    if let photoPickerItem = photoPickerItem,
                       let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            playerImage = image
                        }
                    }
                }
            }
            
            .onChange(of: playerImage) {
                shouldShowCropView = playerImage != nil
                photoPickerItem = nil
            }
            
            .fullScreenCover(isPresented: $shouldShowCropView) {
                CropView(image: playerImage!,
                         maskShape: .circle,
                         configuration: SwiftyCropConfiguration()) { croppedImage in
                    croppedPlayerImage = croppedImage
                    shouldShowCropView.toggle()
                } onCancelCompletion: {
                    shouldShowCropView.toggle()
                }
                .toolbar(.hidden)
                .transition(.opacity)
            }
            
            .sheet(isPresented: $showDatePicker) {
                DatePickerView(selectedDate: $selectedDate)
                    .presentationDetents([.height(300)])
            }
            
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                        dismiss()
                    } label: {
                        Text("done")
                    }
                    .disabled(true)
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

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            DatePicker("Date of Birth", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle()) // Wheel style for the date picker
                .labelsHidden() // Hide the label if you want just the wheel
                .padding()

            Button("Done") {
                dismiss()
            }

        }
    }
}

#Preview {
    CreatePlayerView()
}
