//
//  MenuViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

enum GameComplexity {
    case easy
    case medium
    case hard
}

class MenuViewController: UIViewController {

    @IBAction func menuButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: self.showGameVC(complexity: .easy)
        case 1: self.showGameVC(complexity: .medium)
        case 2: self.showGameVC(complexity: .medium)
        case 3: self.showResultsVC()
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func showGameVC(complexity: GameComplexity) {
        if let vc = GameViewController.storyboardInstance {
            let gameModel = GameEngine(complexity: complexity, iconIds: Constants.pixelIconsIds)
            vc.gameModel = gameModel
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    fileprivate func showResultsVC() {
        
    }

    deinit {
        print("deinit - MenuViewController")
    }
}

extension MenuViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .menu
}
