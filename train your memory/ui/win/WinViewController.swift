//
//  WinViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class WinViewController: UIViewController {

    @IBOutlet weak var goToMenuButton: UIButton! {
        didSet {
            goToMenuButton.type = .menu
        }
    }
    
    @IBOutlet weak var playAgainButton: UIButton! {
        didSet {
            playAgainButton.type = .menu
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.text = ""
            timeLabel.type = .winInfo
        }
    }
    
    @IBOutlet weak var actionsLabel: UILabel! {
        didSet {
            actionsLabel.text = ""
            actionsLabel.type = .winInfo
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.textColor = Colors.menuText
        }
    }
    
    var model: VZGameResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Colors.addGradientBackgroundOn(view: self.view, with: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        goToMenuButton.addTarget(self, action: #selector(self.goToMenuButtonAction), for: .touchUpInside)
        playAgainButton.addTarget(self, action: #selector(self.playAgainButtonAction), for: .touchUpInside)
        
        configureLabels()
        if let name = WinNameHelper.getName() {
            nameTextField.text = name
        }
        nameTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    @objc private func goToMenuButtonAction() {
        let name = nameTextField.text!
        
        if model.tryToSaveWith(name: name) {
            WinNameHelper.save(name: name)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            showErrorAlert()
        }
    }
    
    @objc private func playAgainButtonAction() {
        let name = nameTextField.text!
        
        if model.tryToSaveWith(name: name) {
            WinNameHelper.save(name: name)
            NotificationCenter.default.post(Notification(name: NotificationNames.playAgainNotification))
            self.navigationController?.popViewController(animated: true)
        } else {
            showErrorAlert()
        }
    }
    
    private func configureLabels() {
        timeLabel.text = model.timeAsString()
        actionsLabel.text = String(model.actions)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Oops!", message: "You did not enter a name!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit - WinViewController")
    }
}

extension WinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension WinViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .win
}
