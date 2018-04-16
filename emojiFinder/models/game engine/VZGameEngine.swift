//
//  VZGameEngine.swift
//  emojiFinder
//
//  Created by Vlad on 10.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import Foundation
import UIKit


private struct VZPushedCells {
    weak var cellOne: VZGameCellAdp?
    weak var cellTwo: VZGameCellAdp?
    
    mutating func reset() {
        cellOne = nil
        cellTwo = nil
    }
}

protocol VZGameTimer: class {
    func start()
    func stop() -> Int
    func reset()
}

class VZGameEngine {
    
    private let iconsIds: [String]!
    private let complexity: VZGameComplexity!
    private let soundEngine = SoundEngine()
    private var pusedCells = VZPushedCells()
    private var _numberOfPairs: Int = 0
    private var numberOfGuessedPairs: Int = 0
    
    var cellSize = CGSize(width: 60, height: 60)
    var currentSet = [String]()
    
    var numberOfMotion = 0
    
    weak var timerDelegate: VZGameTimer?
    var userWonAction: ((_ time: Int64, _ actions: Int32, _ complexity: VZGameComplexity) -> Void)?
    
    init(complexity: VZGameComplexity, iconIds: [String]) {
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
        
        currentSet = getRandomParsSetFor(size: _numberOfPairs)
    }
    
    func wasPushedCell(cell: VZGameCellAdp) {
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
        self.userWonAction?(Int64(time!), Int32(numberOfMotion), complexity)
    }
}

extension VZGameEngine {
    func getRandomParsSetFor(size: Int) -> [String] {
        
        var result = [String]()
        
        let randomNumbers: NSMutableSet = []
        
        for _ in 0..<size {
            var random: Int = 0
            repeat {
                random = Int(arc4random_uniform((UInt32(iconsIds.count))))
                if randomNumbers.count == iconsIds.count { break }
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
