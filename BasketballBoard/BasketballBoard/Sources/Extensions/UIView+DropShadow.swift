//
//  UIView+DropShadow.swift
//  BasketballBoard
//
//  Created by Eva on 29.05.2024.
//

import UIKit

extension UIView {
    func dropShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 4.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.3
      }
}
