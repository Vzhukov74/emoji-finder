//
//  MenuViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//
import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuButton0: UIButton! {
        didSet {
            menuButton0.type = .menu
            menuButton0.tag = 0
            menuButton0.setTitle(VZGameComplexity.easy.rawValue, for: .normal)
        }
    }
    
    @IBOutlet weak var menuButton1: UIButton! {
        didSet {
            menuButton1.type = .menu
            menuButton1.tag = 1
            menuButton1.setTitle(VZGameComplexity.medium.rawValue, for: .normal)
        }
    }
    
    @IBOutlet weak var menuButton2: UIButton! {
        didSet {
            menuButton2.type = .menu
            menuButton2.tag = 2
            menuButton2.setTitle(VZGameComplexity.hard.rawValue, for: .normal)
        }
    }
    
    @IBOutlet weak var menuButton3: UIButton! {
        didSet {
            menuButton3.type = .menu
            menuButton3.tag = 3
            menuButton3.setTitle("Results", for: .normal)
        }
    }
    
    @IBOutlet weak var soundButton: UIButton! {
        didSet {
            soundButton.tag = 4
        }
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 0: self.showGameVC(complexity: .easy)
        case 1: self.showGameVC(complexity: .medium)
        case 2: self.showGameVC(complexity: .hard)
        case 3: self.showResultsVC()
        case 4: self.toggleSound()
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        Colors.addGradientBackgroundOn(view: self.view, with: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSoundButton()
    }
    
    private func showGameVC(complexity: VZGameComplexity) {
        if let vc = GameViewController.storyboardInstance {
            let model = VZGameEngine(complexity: complexity, iconIds: Constants.pixelIconsIds)
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func showResultsVC() {
        if let vc = StatisticsViewController.storyboardInstance {
            let model = StatisticsModel()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func toggleSound() {
        SoundConfig.toggleSound()
        configureSoundButton()
    }
    
    private func configureSoundButton() {
        if SoundConfig.isSoundOn() {
            soundButton.setTitle("Sound On", for: .normal)
        } else {
            soundButton.setTitle("Sound Off", for: .normal)
        }
    }

    deinit {
        print("deinit - MenuViewController")
    }
}

extension MenuViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .menu
}
