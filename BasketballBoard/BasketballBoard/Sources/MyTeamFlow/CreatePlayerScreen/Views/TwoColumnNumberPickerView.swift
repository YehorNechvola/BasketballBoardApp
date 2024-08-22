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
//    @Binding var shouldAddSecondNumber: Bool

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
                }
                
                VStack {
                    Text("Second number")
                    
                    Picker("SecondColumn", selection: $secondSelectedNumber) {
                        ForEach(secondColumnRange, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
            }
            
            Button("done") {
                dismiss()
            }
        }
        .padding()
    }
}
