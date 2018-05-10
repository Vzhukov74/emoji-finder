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
            playButton.setTitle("Play", for: .normal)
        }
    }
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
    
    private lazy var cellSize: CGSize = {
        let screenWidth = UIScreen.main.bounds.width
        let space = 5
        
        let width: CGFloat = (UIScreen.main.bounds.width - CGFloat(space * 6)) / 5
        
        let size = CGSize(width: width, height: width)
        return size
    }()
    
    var model: VZGameEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Colors.addGradientBackgroundOn(view: self.view, with: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(self.playAndPauseButtonAction), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configureModel()
    }
    
    @objc private func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func playAndPauseButtonAction() {
        model.toggleGame()
    }
    
    private func configureModel() {
        model.userWonAction = { [weak self] (time, actions, complexity) in
            self?.showWonVC(time: time, actions: actions, complexity: complexity)
        }
        
        model.updateTime = { [weak self] time in
            DispatchQueue.main.async {
                self?.timeLabel.text = time
            }
        }
        
        model.updatePlayPauseButton = { [weak self] state in
            if state {
                self?.playButton.setTitle("Pause", for: .normal)
            } else {
                self?.playButton.setTitle("Play", for: .normal)
            }
        }
        
        model.restartUI = { [weak self] in
            self?.collectionView.reloadData()
        }
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
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GameCell {
            model.wasPushedCell(cell: cell)
        }
    }
}

extension GameViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .game
}
