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
    @FocusState private var isNameCellFocused: Bool
    @FocusState private var isSurnameCellFocused: Bool
    @FocusState private var isNotesCellFocused: Bool
    @FocusState private var isGameNumberCellFocused: Bool
    
    @State private var shouldShowCropView = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var playerImage: UIImage?
    @State private var croppedPlayerImage: UIImage?
    @State private var selectedPosition: Player.PlayerPosition = .pointGuard
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    @State private var selectedDateToString = "Date of birth"
    @State private var notesNext = ""
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var gameNumber: String = ""
    
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
                                Spacer()
                            }
                        }
                        .listRowBackground(Color.clear)
                        
                        Section {
                            TextField("Name", text: $name)
                                .submitLabel(.done)
                                .focused($isNameCellFocused)
                            TextField("Surname", text: $surname)
                                .submitLabel(.done)
                                .focused($isSurnameCellFocused)
                            Text(selectedDateToString)
                                .foregroundStyle(Color(uiColor: dateColor))
                                .onTapGesture {
                                    unfocusAllTextFields()
                                    showDatePicker.toggle()
                                }
                            
                            Picker("Position", selection: $selectedPosition) {
                                ForEach(Player.PlayerPosition.allCases) { position in
                                    Text(position.positionToString).tag(position)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .foregroundStyle(.black)
                            .onTapGesture {
                                unfocusAllTextFields()
                            }
                            
                            TextField("Game number", text: $gameNumber)
                                .id("GameNumberCell")
                                .submitLabel(.done)
                                .focused($isGameNumberCellFocused)
                                .keyboardType(.numberPad)
                                .onChange(of: isGameNumberCellFocused) { _, newValue in
                                    guard newValue else { return }
                                    withAnimation {
                                        reader.scrollTo("GameNumberCell", anchor: .top)
                                    }
                                }
                        }
                        
                        Section {
                            TextField("Notes", text: $notesNext, axis: .vertical)
                                .id("NotesCell")
                                .focused($isNotesCellFocused)
                                .onChange(of: notesNext) { _, _ in
                                    withAnimation {
                                        reader.scrollTo("EmptyColorCell", anchor: .bottom)
                                    }
                                }
                                .onChange(of: isNotesCellFocused) { _, newValue in
                                    guard newValue else { return }
                                    withAnimation {
                                        reader.scrollTo("EmptyColorCell", anchor: .bottom)
                                    }
                                }
                        }
                        
                        //Helper cell for scrolling for last notes textfield cell
                        Section {
                            Color.clear
                                .id("EmptyColorCell")
                                .frame(height: 270)
                                .listRowBackground(Color.clear)
                                .background(Color.clear)
                        }
                    }
                    
                    .scrollDismissesKeyboard(.interactively)
                    .scrollContentBackground(.visible)
                    .ignoresSafeArea(.keyboard, edges: .vertical)
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

//MARK: - Private methods
private extension CreatePlayerView {
    func unfocusAllTextFields() {
    isNameCellFocused = false
    isSurnameCellFocused = false
    isNotesCellFocused = false
    isGameNumberCellFocused = false
    }
}

#Preview {
    CreatePlayerView()
}

