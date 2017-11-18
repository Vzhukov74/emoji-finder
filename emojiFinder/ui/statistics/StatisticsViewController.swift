//
//  StatisticsViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("deinit - StatisticsViewController")
    }
}

extension StatisticsViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .statistics
}
