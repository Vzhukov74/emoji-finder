//
//  ButtonTypes.swift
//  emojiFinder
//
//  Created by Vlad on 10.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//
import UIKit

enum ButtonType {
    case menu
    
    static let `default` = ButtonType.menu
}

extension UIButton {
    fileprivate struct AssociatedKeys {
        static fileprivate var type: UInt8 = 0
    }
    
    var type: ButtonType {
        get {
            if let returnValue = objc_getAssociatedObject(self, &AssociatedKeys.type) as? ButtonType {
                return returnValue
            }
            return ButtonType.default
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.type, newValue as ButtonType, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            switch type {
                
            case .menu:
                self.setTitleColor(Colors.menuText, for: .normal)
                self.titleLabel?.font = Fonts.menuFont
            }
        }
    }
}
