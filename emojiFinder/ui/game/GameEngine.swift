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

class GameEngine {
    
    let emoji = ["👻", "🤡", "👾", "🤖", "😈", "🎃", "👽", "😻", "👍", "👩‍💻", "👨🏻‍💻", "🧙‍♂️", "🧟‍♀️", "👑", "🐼", "🙈", "🙉", "🙊", "🐷", "🐔", "🐙", "🦖", "🐍", "🍄", "⛄️", "☂️", "🍳", "🎱", "🎲", "💣"]
    
    var cellSize = CGSize(width: 40, height: 40)
    var numberOfPairs: Int = 0
    
    fileprivate let complexity: GameComplexity!
    fileprivate var pusedCells = PusedCells()
    
    fileprivate let soundEngine = SoundEngine()
    
    fileprivate var _numberOfPairs: Int = 0
    
    var currentEmojiSet = [String]()
    
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
        
        currentEmojiSet = getRandomSetOfEmojiFor(size: 24)
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
            cell.unhideLogo()
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
        self.numberOfPairs -= 1
        soundEngine.playCoincidenceSound()
        
        if numberOfPairs == 0 {
            self.userWon()
        }
    }
    
    fileprivate func userWon() {
        
    }
}

extension GameEngine {
    func getRandomSetOfEmojiFor(size: Int) -> [String] {
        
        var result = [String]()
        
        let randomNumbers: NSMutableSet = []
        let halfSize = size / 2
        
        for _ in 0...halfSize {
            var random: Int = 0
            repeat {
                random = Int(arc4random_uniform((UInt32(emoji.count))))
            } while randomNumbers.contains(random)
            randomNumbers.add(random)
            
            let randomEmoji = emoji[random]
            result.append(randomEmoji)
            result.append(randomEmoji)
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
