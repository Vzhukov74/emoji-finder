//
//  GameCell.swift
//  emojiFinder
//
//  Created by Vlad on 22.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell, CellRegistable, CellDequeueReusable, VZGameCellAdp {

    @IBOutlet weak var icon: UIImageView! {
        didSet {
            icon.isHidden = true
        }
    }
    
    @IBOutlet weak var temHideView: UIView! {
        didSet {
            temHideView.layer.cornerRadius = 4
            temHideView.clipsToBounds = true
        }
    }
    
    //MARK: - implementation GameCellAdp protocol
    var _model: VZGameCellModel? {
        didSet {
            icon.image = UIImage(named: _model!._id)
        }
    }
    
    var _isHidden: Bool = false {
        didSet {
            icon.isHidden = _isHidden
        }
    }
}
