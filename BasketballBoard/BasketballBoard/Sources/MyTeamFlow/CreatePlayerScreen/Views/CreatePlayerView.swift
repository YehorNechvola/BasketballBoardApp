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
    @StateObject var localViewModel = CreatePlayerViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState private var isNameCellFocused: Bool
    @FocusState private var isSurnameCellFocused: Bool
    @FocusState private var isNotesCellFocused: Bool
    @FocusState private var isGameNumberCellFocused: Bool
    
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var playerImage: UIImage?
    @State private var croppedPlayerImage: UIImage?
    
    private var nameCellId: String { "nameCellId" }
    private var lastCellId: String { "lastCellId" }
    
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
    
    private var dateTextColor: UIColor {
        guard let _ = localViewModel.selectedDateToString else {
            return .placeholderText
        }
        return .black
    }
    
    private var playerPositionTextColor: UIColor {
        guard let _ = localViewModel.selectedPosition else {
            return .placeholderText
        }
        return .black
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
                            TextField("Name", text: binding(for: \.nameInput, default: ""))
                                .id(nameCellId)
                                .submitLabel(.done)
                                .focused($isNameCellFocused)
                            TextField("Surname", text: binding(for: \.surnameInput, default: ""))
                                .submitLabel(.done)
                                .focused($isSurnameCellFocused)
                            HStack {
                                Text(localViewModel.selectedDateToString ?? "Date of birth")
                                    .foregroundStyle(Color(uiColor: dateTextColor))
                                    .onChange(of: localViewModel.shouldShowDatePicker) { _, newValue in
                                        scrollToRow(by: newValue ? lastCellId : nameCellId, reader: reader)
                                    }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .background()
                            .onTapGesture {
                                unfocusAllTextFields()
                                localViewModel.shouldShowDatePicker.toggle()
                                scrollToRow(by: localViewModel.shouldShowDatePicker ? lastCellId : nameCellId, reader: reader)
                            }
                            
                            Menu {
                                ForEach(Player.PlayerPosition.allCases) { position in
                                    Button {
                                        localViewModel.selectedPosition = position
                                    } label: {
                                        HStack {
                                            Text(position.positionToString).tag(position)
                                            
                                            Spacer()
                                            
                                            if position == localViewModel.selectedPosition {
                                                Image(systemName: "checkmark")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text("\(localViewModel.playerPositionText)")
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .background()
                                .onTapGesture {
                                    unfocusAllTextFields()
                                }
                                
                            }
                            .foregroundStyle(Color(uiColor: playerPositionTextColor))
                            
                            
                            HStack {
                                Text("Player number:")
                                    .foregroundStyle(Color(uiColor: .placeholderText))
                                Text(localViewModel.numberPlayerToString)
                                    .onChange(of: localViewModel.shouldShowNumberPicker) { _, newValue in
                                        scrollToRow(by: newValue ? lastCellId : nameCellId, reader: reader)
                                    }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .background()
                            .onTapGesture {
                                unfocusAllTextFields()
                                localViewModel.shouldShowNumberPicker.toggle()
                            }
                        }
                        
                        Section {
                            TextField("Notes",
                                      text: binding(for: \.notesInput, default: ""),
                                      axis: .vertical)
                                .focused($isNotesCellFocused)
                                .onChange(of: isNotesCellFocused) { _, newValue in
                                    guard newValue else { return }
                                    scrollToRow(by: lastCellId, reader: reader)
                                }
                                .onChange(of: localViewModel.notesInput) { _, _ in
                                    scrollToRow(by: lastCellId, reader: reader)
                                }
                        }
                        
                        //Helper cell for scrolling for last notes textfield cell
                        Section {
                            Color.clear
                                .id(lastCellId)
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
                localViewModel.shouldShowCropView = playerImage != nil
                photoPickerItem = nil
            }
            
            .fullScreenCover(isPresented: $localViewModel.shouldShowCropView) {
                CropView(image: playerImage!,
                         maskShape: .circle,
                         configuration: SwiftyCropConfiguration()) { croppedImage in
                    croppedPlayerImage = croppedImage
                    localViewModel.shouldShowCropView.toggle()
                } onCancelCompletion: {
                    localViewModel.shouldShowCropView.toggle()
                }
                .toolbar(.hidden)
                .transition(.opacity)
            }
            
            .sheet(isPresented: $localViewModel.shouldShowDatePicker) {
                DatePickerView(selectedDate: $localViewModel.selectedDate,
                               selectedDateToString: binding(for: \.selectedDateToString, default: "Date of birth"))
                .presentationDetents([.height(300)])
            }
            
            .sheet(isPresented: $localViewModel.shouldShowNumberPicker) {
                TwoColumnWheelPicker(firstSelectedNumber: $localViewModel.firstSelectedNumber,
                                     secondSelectedNumber: $localViewModel.secondSelectedNumber)
                .presentationDetents([.height(300)])
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("save")
                    }
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
    
    func scrollToRow(by id: String, reader: ScrollViewProxy) {
        withAnimation {
            reader.scrollTo(id, anchor: .bottom)
        }
    }

    
    func binding<T>(for keyPath: ReferenceWritableKeyPath<CreatePlayerViewModel, T?>, default value: T) -> Binding<T> {
            Binding<T>(
                get: { localViewModel[keyPath: keyPath] ?? value },
                set: { localViewModel[keyPath: keyPath] = $0 }
            )
        }
}

#Preview {
    CreatePlayerView()
}

