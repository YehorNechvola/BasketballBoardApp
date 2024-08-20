//
//  TwoColumnNumberPickerView.swift
//  BasketballBoard
//
//  Created by Eva on 20.08.2024.
//

import SwiftUI

struct TwoColumnWheelPicker: View {
    @Binding var firstSelectedNumber: Int
    @Binding var secondSelectedNumber: Int
    @Environment(\.dismiss) private var dismiss
    @State private var shouldAddSecondNumber = false

    var firstColumnRange: [Int] = Array(0...9)
    var secondColumnRange: [Int] = Array(0...9)

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 30) {
                VStack {
                    Text("First number")
                    
                    Picker("FirstColumn", selection: $firstSelectedNumber) {
                        ForEach(firstColumnRange, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 120)
                }

                if shouldAddSecondNumber {
                    VStack {
                        Text("Second number")
                        
                        Picker("SecondColumn", selection: $secondSelectedNumber) {
                            ForEach(secondColumnRange, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 120)
                    }
                }
            }
            
            Button {
                withAnimation {
                    shouldAddSecondNumber.toggle()
                }
                
            } label: {
                
                Image(systemName: shouldAddSecondNumber ? "minus.circle.fill" : "plus.circle.fill")
                    .resizable()
                    .tint(.blue)
                    .frame(width: 35, height: 35)
            }
            
            Button("done") {
                dismiss()
            }
        }
        .padding()
    }
}
