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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = ""
            timeLabel.font = Fonts.menuFont
            timeLabel.textColor = UIColor.white
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            GameCell.register(collectionView: collectionView)
        }
    }
    
    fileprivate var isGameActive = false {
        didSet {
            if isGameActive {
                playButton.setImage(Images.pause, for: .normal)
                start()
            } else {
                playButton.setImage(Images.play, for: .normal)
                _ = stop()
            }
        }
    }
    
    var model: VZGameEngine!
    
    fileprivate var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.restart), name: NotificationNames.playAgainNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseGame), name: NotificationNames.appEnterInBackground, object: nil)
        
        Colors.addGradientBackgroundOn(view: self.view, with: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        model.userWonAction = { [weak self] (time, actions, complexity) in
            self?.showWonVC(time: time, actions: actions, complexity: complexity)
        }
        
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(self.playAndPauseButtonAction), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc private func restart() {
        model.restart()
        timeLabel.text = ""
        collectionView.reloadData()
    }
    
    @objc private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func setTimeLabel() {
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
    
    @objc private func pauseGame() {
        isGameActive = false
    }
    
    @objc private func playAndPauseButtonAction() {
        isGameActive = !isGameActive
    }
    
    private func showWonVC(time: Int64, actions: Int32, complexity: VZGameComplexity) {
        if let vc = WinViewController.storyboardInstance {
            let model = VZGameResult(time: time, actions: actions, complexity: complexity)
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("deinit - GameViewController")
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.currentSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = GameCell.cell(collectionView: collectionView, indexPath: indexPath)
        let cellModel = model.currentSet[indexPath.row]
        cell.configure(model: cellModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return model.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GameCell {
            model.wasPushedCell(cell: cell)
        }
    }
}

extension GameViewController: VZGameTimer {
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setTimeLabel), userInfo: Date(), repeats: true)
         timeLabel.text = "0"
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
