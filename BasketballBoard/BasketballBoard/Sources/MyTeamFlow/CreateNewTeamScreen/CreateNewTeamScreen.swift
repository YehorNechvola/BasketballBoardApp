//
//  CreateNewTeamScreen.swift
//  BasketballBoard
//
//  Created by Eva on 18.06.2024.
//

import PhotosUI
import SwiftUI

struct CreateNewTeamScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MyTeamViewModel
    @State private var teamNameText: String = ""
    @State private var desccriptionText: String = ""
    @State private var photoPickerItem: PhotosPickerItem?
    @State var teamImage: UIImage?
    
    private let descriptionRowId = "Description"
    
    var body: some View {
        NavigationStack{
            ScrollViewReader { proxy in
                List {
                    Section {
                        HStack(spacing: 20) {
                            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                                Image(systemName: "camera.circle")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.blue)
                            }
                            
                            TextField("Name of team", text: $teamNameText)
                        }
                    }
                    
                    Section {
                        TextField("Description", text: $desccriptionText, axis: .vertical)
                            .id(descriptionRowId)
                            .onChange(of: desccriptionText) {
                                proxy.scrollTo(descriptionRowId, anchor: .bottom)
                            }
                    }
                   
                }
            }
            
            .navigationTitle("New team")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.addNewTeam(name: teamNameText)
                        dismiss()
                    } label: {
                        Text("save")
                    }
                    .disabled(teamNameText.isEmpty)
                }
            }
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
        }
    }
}

private extension CreateNewTeamScreen {
    func calculateHeight(for text: String, in width: CGFloat) -> CGFloat {
        let textView = UITextView()
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 17)
        let size = textView.sizeThatFits(CGSize(width: width, height: CGFloat.infinity))
        return size.height
    }
}

#Preview {
    CreateNewTeamScreen()
        .environmentObject(MyTeamViewModel())
}
