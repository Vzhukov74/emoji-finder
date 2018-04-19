//
//  LabelType.swift
//  emojiFinder
//
//  Created by Vlad on 17.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//
import UIKit

enum LabelType {
    case menu
    case statisticsTitle
    
    static let `default` = LabelType.menu
}

extension UILabel {
    fileprivate struct AssociatedKeys {
        static fileprivate var type: UInt8 = 0
    }
    
    var type: LabelType {
        get {
            if let returnValue = objc_getAssociatedObject(self, &AssociatedKeys.type) as? LabelType {
                return returnValue
            }
            return LabelType.default
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.type, newValue as LabelType, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            switch type {
                
            case .menu:
                self.textColor = Colors.menuText
                self.font = Fonts.menuFont
            case .statisticsTitle:
                self.textColor = Colors.menuText
                self.font = Fonts.statisticsTitleFont
            }
        }
    }
}
