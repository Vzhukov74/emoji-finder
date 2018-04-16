//
//  VZGameCellAdp.swift
//  emojiFinder
//
//  Created by Vlad on 10.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

protocol VZGameCellAdp: class {
    var _isHidden: Bool {get set}
    var _isCellGuessed: Bool {get set}
    var _id: String {get set}
    
    func configure(id: String)
    func cellDataId() -> String
    func hideLogo()
    func unhideLogo()
    func setAsOpen()
}

extension VZGameCellAdp {
    func configure(id: String) {
        self._id = id
    }
    
    func cellDataId() -> String {
        return _id
    }
    
    func hideLogo() {
        if _isCellGuessed {return}
        _isHidden = true
    }
    
    func unhideLogo() {
        _isHidden = false
    }
    
    func setAsOpen() {
        _isCellGuessed = true
        _isHidden = false
    }
}
