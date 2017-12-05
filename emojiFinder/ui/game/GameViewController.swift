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
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            GameCell.register(collectionView: collectionView)
        }
    }
    
    var complexity: GameComplexity!
    
    fileprivate var controller: GameEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        controller = GameEngine(complexity: complexity)
        
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("deinit - GameViewController")
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller.currentEmojiSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = GameCell.cell(collectionView: collectionView, indexPath: indexPath)
        cell.id = controller.currentEmojiSet[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return controller.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GameCell {
            controller.wasPushedCell(cell: cell)
        }
    }
}

extension GameViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .game
}
