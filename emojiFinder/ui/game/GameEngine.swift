//
//  GameEngine.swift
//  emojiFinder
//
//  Created by Vlad on 23.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import Foundation
import UIKit

private struct PusedCells {
    weak var cellOne: GameCellAdp?
    weak var cellTwo: GameCellAdp?
}

protocol GameCellAdp: class {
    func cellDataId() -> String
    func hideLogo()
    func setAsOpen()
}

class GameEngine {
    
    var cellSize = CGSize(width: 40, height: 40)
    var numberOfPairs: Int = 0
    
    fileprivate let complexity: GameComplexity!
    fileprivate var pusedCells = PusedCells()
    
    fileprivate var _numberOfPairs: Int = 0
    
    init(complexity: GameComplexity) {
        self.complexity = complexity
        
        switch complexity {
        case .easy:
            numberOfPairs = 12
            _numberOfPairs = 12
        case .medium:
            numberOfPairs = 16
            _numberOfPairs = 12
        case .hard:
            numberOfPairs = 18
            _numberOfPairs = 12
        }
        
        calculateCellSize()
    }
    
    fileprivate func calculateCellSize() {
        let screenWidth = UIScreen.main.bounds.width
        let screenWidthWithoutInset = screenWidth - ( 5 * 10 )
        let cellWidth = Int(screenWidthWithoutInset / 4)
        
        if cellWidth > 60 {
            cellSize = CGSize(width: 60, height: 60)
        } else {
            cellSize = CGSize(width: cellWidth, height: cellWidth)
        }
        print("cell size is \(cellSize)")
    }
    
    func wasPushedCell(cell: GameCellAdp) {
        if pusedCells.cellOne == nil {
            pusedCells.cellOne = cell
        } else if pusedCells.cellTwo == nil {
            pusedCells.cellTwo = cell
        }
    }
    
    fileprivate func checkCells() {
        if pusedCells.cellOne == nil && pusedCells.cellTwo == nil {
            if pusedCells.cellOne!.cellDataId() == pusedCells.cellTwo!.cellDataId() {
                pusedCells.cellOne!.setAsOpen()
                pusedCells.cellTwo!.setAsOpen()
                self.userGuessedPair()
            } else {
                pusedCells.cellOne!.hideLogo()
                pusedCells.cellTwo!.hideLogo()
            }
        } else {
            assert(false)
        }
    }
    
    fileprivate func userGuessedPair() {
        self.numberOfPairs -= 1
        
        if numberOfPairs == 0 {
            self.userWon()
        }
    }
    
    fileprivate func userWon() {
        
    }
}
