//
//  GameViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.isHidden = true
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            GameCell.register(collectionView: collectionView)
        }
    }
    
    fileprivate var isGameActive = false {
        didSet {
            if isGameActive {
                playButton.isHidden = false
                start()
            } else {
                playButton.isHidden = false
                _ = pause()
            }
        }
    }
    
    var gameModel: GameEngine!
    
    fileprivate var controller: GameEngine!
    fileprivate var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gameModel.timerDelegate = self
        
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func setTimeLabel() {
        let elapsed = -(timer.userInfo as! Date).timeIntervalSinceNow
        
        if elapsed > (60 * 60) {
            let hour = elapsed / (60 * 60)
            let temp = elapsed.truncatingRemainder(dividingBy: 60 * 60)
            let min = temp / 60
            let sec = temp.truncatingRemainder(dividingBy: 60)
            timeLabel.text = String(format: "%.0f:%.00f:%.00f", arguments: [hour.rounded(.down), min.rounded(.down), sec])
        } else if elapsed > 60 {
            let min = elapsed / 60
            let sec = elapsed.truncatingRemainder(dividingBy: 60)
            timeLabel.text = String(format: "%.0f:%.00f", arguments: [min,sec])
        } else {
            timeLabel.text = String(format: "%.0f", arguments: [elapsed])
        }
    }
    
    @objc func playAndPauseButtonAction() {
        isGameActive = !isGameActive
    }

    deinit {
        print("deinit - GameViewController")
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameModel.currentSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = GameCell.cell(collectionView: collectionView, indexPath: indexPath)
        cell.id = gameModel.currentSet[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return gameModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GameCell {
            gameModel.wasPushedCell(cell: cell)
        }
    }
}

extension GameViewController: GameTimer {
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLabel), userInfo: Date(), repeats: true)
    }
    
    func stop() -> Int {
        let elapsed: Int = Int(-(timer.userInfo as! Date).timeIntervalSinceNow)
        timer.invalidate()
        return elapsed
    }
    
    func reset() {
        timer.fire()
    }
}

extension GameViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .game
}
