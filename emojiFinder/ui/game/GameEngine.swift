//
//  GameEngine.swift
//  emojiFinder
//
//  Created by Vlad on 23.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import Foundation
import UIKit

private struct PushedCells {
    weak var cellOne: GameCellAdp?
    weak var cellTwo: GameCellAdp?
    
    mutating func reset() {
        cellOne = nil
        cellTwo = nil
    }
}

protocol GameCellAdp: class {
    func cellDataId() -> String
    func hideLogo()
    func unhideLogo()
    func setAsOpen()
}

protocol GameTimer: class {
    func start()
    func stop() -> Int
    func reset()
}

class GameEngine {
    
    private let iconsIds: [String]!
    private let complexity: GameComplexity!
    private var pusedCells = PushedCells()
    private let soundEngine = SoundEngine()
    private var _numberOfPairs: Int = 0
    private var numberOfGuessedPairs: Int = 0
    
    var cellSize = CGSize(width: 60, height: 60)
    var currentSet = [String]()
    
    var numberOfMotion = 0
    
    weak var timerDelegate: GameTimer?
    
    init(complexity: GameComplexity, iconIds: [String]) {
        self.complexity = complexity
        self.iconsIds = iconIds
        
        numberOfMotion = 0
        numberOfGuessedPairs = 0
        
        switch complexity {
        case .easy:
            _numberOfPairs = 15
        case .medium:
            _numberOfPairs = 20
        case .hard:
            _numberOfPairs = 25
        }
        
        currentSet = getRandomSetFor(size: _numberOfPairs * 2)
    }
    
    func wasPushedCell(cell: GameCellAdp) {
        if pusedCells.cellOne == nil {
            pusedCells.cellOne = cell
            cell.unhideLogo()
        } else if cell === pusedCells.cellOne {
            return
        } else if pusedCells.cellTwo == nil {
            pusedCells.cellTwo = cell
            cell.unhideLogo()
            checkCells()
        } else {
            if pusedCells.cellOne!.cellDataId() == cell.cellDataId() || pusedCells.cellTwo!.cellDataId() == cell.cellDataId()  {
                resetCells()
            } else {
                resetCells()
                
                pusedCells.cellOne = cell
                cell.unhideLogo()
            }
        }
        
        numberOfMotion += 1
        //if is it first motion
        if numberOfMotion == 1 {
            self.timerDelegate?.start()
        }
    }
    
    fileprivate func resetCells() {
        pusedCells.cellOne?.hideLogo()
        pusedCells.cellTwo?.hideLogo()
        pusedCells.reset()
    }
    
    fileprivate func checkCells() {
        if pusedCells.cellOne != nil && pusedCells.cellTwo != nil {
            if pusedCells.cellOne!.cellDataId() == pusedCells.cellTwo!.cellDataId() {
                pusedCells.cellOne!.setAsOpen()
                pusedCells.cellTwo!.setAsOpen()
                self.userGuessedPair()
                self.resetCells()
            }
        } else {
            assert(false)
        }
    }
    
    fileprivate func userGuessedPair() {
        numberOfGuessedPairs += 1
        soundEngine.playCoincidenceSound()
        
        if _numberOfPairs == numberOfGuessedPairs {
            self.userWon()
        }
    }
    
    fileprivate func userWon() {
        let time = self.timerDelegate?.stop()
        print(time ?? 0)
    }
}

extension GameEngine {
    func getRandomSetFor(size: Int) -> [String] {
        
        var result = [String]()
        
        let randomNumbers: NSMutableSet = []
        let halfSize = size / 2
        
        for _ in 0..<halfSize {
            var random: Int = 0
            repeat {
                random = Int(arc4random_uniform((UInt32(iconsIds.count))))
            } while randomNumbers.contains(random)
            randomNumbers.add(random)
            
            let randomIconId = iconsIds[random]
            result.append(randomIconId)
            result.append(randomIconId)
        }
        let randomResult = randomizeArray(array: result)
        
        return randomResult
    }
    
    fileprivate func randomizeArray<T>(array: [T]) -> [T] {
        var result = [T]()
        
        let randomNumbers: NSMutableSet = []
        
        for _ in 0...(array.count - 1) {
            var random: Int = 0
            repeat {
                random = Int(arc4random_uniform((UInt32(array.count))))
            } while randomNumbers.contains(random)
            randomNumbers.add(random)
            
            let randomObj = array[random]
            result.append(randomObj)
        }
        return result
    }
}
