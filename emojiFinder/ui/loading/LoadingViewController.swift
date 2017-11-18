//
//  LoadingViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    deinit {
        print("deinit - LoadingViewController")
    }
}

extension LoadingViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .loading
}
