//
//  CreateNewTeamScreen.swift
//  BasketballBoard
//
//  Created by Eva on 18.06.2024.
//

import SwiftUI

struct CreateNewTeamScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MyTeamViewModel
    @State private var teamNameText: String = ""
    @State private var descriptionText: String = ""
    @State private var presentPickerPhotoView = false
    @State private var teamImage: UIImage?
    
    private let descriptionRowId = "Description"
    
    var body: some View {
        NavigationStack{
            ScrollViewReader { proxy in
                List {
                    Section {
                        HStack(spacing: 20) {
                            Button {
                                presentPickerPhotoView.toggle()
                            } label: {
                                
                                Image(uiImage: teamImage ?? UIImage(systemName: "camera.circle")!)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundStyle(.blue)
                            }
                            
                            TextField("Name of team", text: $teamNameText)
                        }
                    }
                    
                    Section {
                        TextField("Description", text: $descriptionText, axis: .vertical)
                            .id(descriptionRowId)
                            .onChange(of: descriptionText) {
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
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("cancel")
                    }
                }
            }
            .fullScreenCover(isPresented: $presentPickerPhotoView) {
                PickPhotoOrCameraView(croppedTeamImage: $teamImage)
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
