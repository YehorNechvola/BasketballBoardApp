//
//  UIAplication + ResignFirstResponder.swift
//  BasketballBoard
//
//  Created by Eva on 04.07.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
