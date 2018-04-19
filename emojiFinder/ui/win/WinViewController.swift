//
//  WinViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class WinNameHelper {
    private static let nameKey = "ru.nameKey"
    
    static func getName() -> String? {
        if let value = UserDefaults.standard.value(forKey: WinNameHelper.nameKey) {
            return value as? String ?? nil
        } else {
            return nil
        }
    }
    
    static func save(name: String) {
        UserDefaults.standard.set(name, forKey: WinNameHelper.nameKey)
    }
}

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
            timeLabel.type = .statisticsTitle
        }
    }
    
    @IBOutlet weak var actionsLabel: UILabel! {
        didSet {
            actionsLabel.text = ""
            actionsLabel.type = .statisticsTitle
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
        timeLabel.text = String(model.time) + "sec"
        actionsLabel.text = String(model.actions)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Oops!", message: "You did not enter a name!", preferredStyle: .alert)
        
       // alert.accessibilityAttributedLabel = NSMutableAttributedString(string: "", attributes: [NSAttributedStringKey.font: Fonts.statisticsTitleFont, NSAttributedStringKey.foregroundColor: Colors.menuText])
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //action.accessibilityAttributedLabel
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit - WinViewController")
    }
}

extension WinViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .win
}

//    func forTest() {
//        let entityDescription = NSEntityDescription.entity(forEntityName: "GameResult", in: self.managedObjectContext)
//
//        let managedObject = GameResult(entity: entityDescription!, insertInto: self.managedObjectContext)
//
//        // Установка значения атрибута
//        managedObject.user_name = "Pither"// .setValue("Pither", forKey: "user_name")
//        managedObject.setValue(10, forKey: "actions")
//        managedObject.setValue(20, forKey: "time")
//        managedObject.setValue(1, forKey: "complexity")
//
//        // Извлечение значения атрибута
//        let name = managedObject.value(forKey: "user_name")
//        print("name = \(String(describing: name))")
//
//        // Запись объекта
//        self.saveContext()
//
//        // Извление записей
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameResult")
//        do {
//            let results = try self.managedObjectContext.fetch(fetchRequest)
//            for result in results as! [GameResult] {
//                print("name - \(result.user_name!)")
//            }
//        } catch {
//            print(error)
//        }
//    }
