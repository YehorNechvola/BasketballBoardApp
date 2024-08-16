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
    @FocusState var isNameFocused: Bool
    
    @State private var shouldShowCropView = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var playerImage: UIImage?
    @State private var croppedPlayerImage: UIImage?
    @State private var selectedPosition: Player.PlayerPosition = .pointGuard
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var selectedDateToString = "Date of birth"
    @State private var notesNext = ""
    private var dateColor: UIColor {
        selectedDateToString == "Date of birth" ? .placeholderText : .black
    }
    
    private var playerImagePadding: CGFloat {
        if let _ = croppedPlayerImage {
            0
        } else {
            15
        }
    }
    
    private var playerImageWidth: CGFloat {
        if let _ = croppedPlayerImage {
            100
        } else {
            75
        }
    }
    
    @State private var name: String = ""
    @State private var surname: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { reader in
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
                                .id("PhotoCell")
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.clear)
                        
                        Section {
                            TextField("Name", text: $name)
                                .id("NameCell")
                                .submitLabel(.done)
                            TextField("Surname", text: $surname)
                                .id("SurnameCell")
                                .submitLabel(.done)
                            Text(selectedDateToString)
                                .id("DateCell")
                                .foregroundStyle(Color(uiColor: dateColor))
                                .onTapGesture {
                                    showDatePicker.toggle()
                                }
                            
                            Picker("Position", selection: $selectedPosition) {
                                ForEach(Player.PlayerPosition.allCases) { position in
                                    Text(position.positionToString).tag(position)
                                }
                            }
                            .id("PositionCell")
                            .pickerStyle(MenuPickerStyle())
                            .foregroundStyle(.black)
                        }
                        
                        Section {
                            TextField("Notes", text: $notesNext, axis: .vertical)
                                .id("NotesCell")
                                .focused($isNameFocused)
                                .onChange(of: notesNext) { _, _ in
                                    withAnimation {
                                        reader.scrollTo("NotesCell", anchor: .bottom)
                                    }
                                }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
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
            
            .onChange(of: isNameFocused) { first, second in
                print("keyboard: \(second)")
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
                DatePickerView(selectedDate: $selectedDate, selectedDateToString: $selectedDateToString)
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

#Preview {
    CreatePlayerView()
}

