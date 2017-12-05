//
//  GameCell.swift
//  emojiFinder
//
//  Created by Vlad on 22.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell, CellRegistable, CellDequeueReusable {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var temHideView: UIView! {
        didSet {
            temHideView.isHidden = false
        }
    }
    
    fileprivate var isUnhide = false
    
    var id = "" {
        didSet {
            info.text = id
        }
    }
}

extension GameCell: GameCellAdp {
    func cellDataId() -> String {
        return self.id
    }
    
    func hideLogo() {
        if !isUnhide {
            temHideView.isHidden = false
        }
    }
    
    func unhideLogo() {
        temHideView.isHidden = true
    }
    
    func setAsOpen() {
        isUnhide = true
        temHideView.isHidden = true
    }
}


protocol CellRegistable { }

extension CellRegistable {
    static func register(table: UITableView) {
        table.register(UINib.init(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: String(describing: self))
    }
    
    static func register(collectionView : UICollectionView) {
        let nib = UINib.init(nibName: String(describing: self), bundle: nil)
        let identifier = String(describing: self)
        
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

protocol CellDequeueReusable { }

extension CellDequeueReusable {
    static func cell(table: UITableView, indexPath: IndexPath) -> Self {
        let cell = table.dequeueReusableCell(withIdentifier: String(describing: self), for: indexPath) as! Self
        return cell
    }
    
    static func cell(collectionView : UICollectionView, indexPath: IndexPath) -> Self {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: self), for: indexPath) as! Self
        return cell
    }
}
