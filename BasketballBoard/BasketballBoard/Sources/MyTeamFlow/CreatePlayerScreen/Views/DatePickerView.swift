//
//  DatePickerView.swift
//  BasketballBoard
//
//  Created by Eva on 16.08.2024.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var selectedDateToString: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            DatePicker("Date of Birth", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .padding()

            Button("Done") {
                dismiss()
            }
        }
        
        .onDisappear {
            selectedDateToString = DateFormatterService.shared.formatDate(for: selectedDate)
        }
    }
}
