//
//  Date+Age.swift
//  BasketballBoard
//
//  Created by Rush_user on 12.02.2026.
//

import Foundation

extension Date {
    var age: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year, .month, .day], from: self, to: now)
        var age = ageComponents.year ?? 0
        if let month = ageComponents.month, let day = ageComponents.day {
            if month < 0 || (month == 0 && day < 0) {
                age -= 1
            }
        }
        
        return age
    }
    
    func dateToString(format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
