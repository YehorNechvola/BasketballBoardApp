//
//  UIApplicatin+HideKeyboard.swift
//  BasketballBoard
//
//  Created by Eva on 16.08.2024.
//

import UIKit

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
