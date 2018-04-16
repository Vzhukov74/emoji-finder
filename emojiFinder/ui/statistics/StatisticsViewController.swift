//
//  StatisticsViewController.swift
//  emojiFinder
//
//  Created by Vlad on 17.11.2017.
//  Copyright © 2017 Vlad. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            
        }
    }
    
    var model: StatisticsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.didFetchResults = { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
        
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlDidChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentedControlDidChanged(_ sender: UISegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        assert(segmentIndex <= 2)
        
        let complexity = VZGameComplexity.init(intValue: segmentIndex)
        model.setFilter(complexity: complexity)
    }
    
    deinit {
        print("deinit - StatisticsViewController")
    }
}

extension StatisticsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfResults()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = model.resultFor(index: indexPath.row)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = data.user_name
        
        return cell
    }
}

extension StatisticsViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .statistics
}
