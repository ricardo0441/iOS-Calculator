//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Ricardo Rodriguez on 10/10/23.
//

import UIKit

private let orange = UIColor(red: 254/255, green: 148/255, blue: 0/255, alpha: 1)

extension UIButton {
    
    // Borde redondo
        func round() {
            layer.cornerRadius = bounds.height / 2
            clipsToBounds = true
        }
    
    // Brilla
        func shine() {
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 0.5
            }) { (completion) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.alpha = 1
                })
            }
        }
    
//    apariencia de la seleccion del boton
    func selectedOperation(_ selected: Bool) {
        backgroundColor = selected ? .white : orange
        tintColor = selected ? orange : .white
        setTitleColor(selected ? orange : .white, for: .normal)
    }

}
