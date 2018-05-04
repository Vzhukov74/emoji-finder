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

class VZGameEngine {
    
    private let iconsIds: [String]!
    private let complexity: VZGameComplexity!
    private let soundEngine = VZGameSoundEngine()
    private var pusedCells = VZPushedCells()
    private var _numberOfPairs: Int = 0
    private var numberOfGuessedPairs: Int = 0
    private var timerModel: VZTimerModel!
    
    var currentSet = [VZGameCellModel]()
    var numberOfMotion = 0
    
    var userWonAction: ((_ time: Int64, _ actions: Int32, _ complexity: VZGameComplexity) -> Void)?
    var updateTime: ((_ time: String?) -> Void)? {
        didSet {
            timerModel.updateTime = self.updateTime
        }
    }
    var updatePlayPauseButton: ((_ state: Bool) -> Void)?
    var restartUI: (() -> Void)?
    
    var isGameActive: Bool {
        return timerModel.isTimerActive
    }
    
    init(complexity: VZGameComplexity, iconIds: [String]) {
        self.complexity = complexity
        self.iconsIds = iconIds
        
        self.timerModel = VZTimerModel()
        
        switch complexity {
        case .easy:
            _numberOfPairs = 15
        case .medium:
            _numberOfPairs = 20
        case .hard:
            _numberOfPairs = 25
        }
        
        configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pause), name: NotificationNames.appEnterInBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.restart), name: NotificationNames.playAgainNotification, object: nil)
    }
    
    func toggleGame() {
        timerModel.toggle()
        self.updatePlayPauseButton?(timerModel.isTimerActive)
    }
    
    @objc func pause() {
        toggleGame()
    }
    
    @objc func restart() {
        timerModel.reset()
        configure()
    }
    
    func wasPushedCell(cell: VZGameCellAdp) {
        
        soundEngine.playOpenCellSound()
        
        numberOfMotion += 1
        //if is it first motion
        if numberOfMotion == 1 || !timerModel.isTimerActive {
            toggleGame()
        }
        
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
    }
    
    private func configure() {
        numberOfMotion = 0
        numberOfGuessedPairs = 0
        
        pusedCells.reset()
        
        let idSet = getRandomParsSetFor(size: _numberOfPairs)
        currentSet = idSet.map({ VZGameCellModel(_isHidden: true, _isCellGuessed: false, _id: $0)  })
        
        self.updatePlayPauseButton?(timerModel.isTimerActive)
        self.restartUI?()
    }
    
    private func resetCells() {
        pusedCells.cellOne?.hideLogo()
        pusedCells.cellTwo?.hideLogo()
        pusedCells.reset()
    }
    
    private func checkCells() {
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
    
    private func userGuessedPair() {
        numberOfGuessedPairs += 1
        soundEngine.playCoincidenceSound()
        
        if _numberOfPairs == numberOfGuessedPairs {
            self.userWon()
        }
    }
    
    private func userWon() {
        timerModel.pause()
        soundEngine.playPlayEndSound()
        self.userWonAction?(Int64(timerModel.getTime()), Int32(numberOfMotion), complexity)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit - VZGameEngine")
    }
}

extension VZGameEngine {
    private func getRandomParsSetFor(size: Int) -> [String] {
        
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
    
    private func randomizeArray<T>(array: [T]) -> [T] {
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
