//
//  VZGameCellAdp.swift
//  emojiFinder
//
//  Created by Vlad on 10.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation

struct VZGameCellModel {
    var _isHidden: Bool
    var _isCellGuessed: Bool
    var _id: String
}

protocol VZGameCellAdp: class {
    var _model: VZGameCellModel? {get set}
    var _isHidden: Bool {get set}
    
    func configure(model: VZGameCellModel)
    func cellDataId() -> String
    func hideLogo()
    func unhideLogo()
    func setAsOpen()
}

extension VZGameCellAdp {
    func configure(model: VZGameCellModel) {
        self._model = model
        self._isHidden = model._isHidden
    }
    
    func cellDataId() -> String {
        return _model!._id
    }
    
    func hideLogo() {
        if _model!._isCellGuessed {return}
        _model!._isHidden = true
        self._isHidden = _model!._isHidden
    }
    
    func unhideLogo() {
        _model!._isHidden = false
        self._isHidden = _model!._isHidden
    }
    
    func setAsOpen() {
        _model!._isCellGuessed = true
        _model!._isHidden = false
        self._isHidden = _model!._isHidden
    }
}
