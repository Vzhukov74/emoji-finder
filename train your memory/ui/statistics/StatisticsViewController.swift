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
            StatisticsCell.register(table: tableView)
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: Fonts.segmentedControlFont, NSAttributedStringKey.foregroundColor: Colors.menuText], for: .normal)
            segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: Fonts.segmentedControlFont, NSAttributedStringKey.foregroundColor: UIColor.white], for: .focused)
            segmentedControl.tintColor = Colors.menuText
            
            segmentedControl.setTitle(VZGameComplexity.easy.rawValue, forSegmentAt: 0)
            segmentedControl.setTitle(VZGameComplexity.medium.rawValue, forSegmentAt: 1)
            segmentedControl.setTitle(VZGameComplexity.hard.rawValue, forSegmentAt: 2)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.type = .statisticsTitle
        }
    }
    
    @IBOutlet weak var actionsLabel: UILabel! {
        didSet {
            actionsLabel.type = .statisticsTitle
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.type = .statisticsTitle
        }
    }
    
    @IBOutlet weak var placeLabel: UILabel! {
        didSet {
            placeLabel.type = .statisticsTitle
        }
    }
    
    @IBOutlet weak var closeButton: UIButton!
    
    var model: StatisticsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model.didFetchResults = { [weak self] in
            self?.tableView.reloadData()
        }
        
        closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(self.segmentedControlDidChanged(_:)), for: .valueChanged)
        
        Colors.addGradientBackgroundOn(view: self.view, with: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    @objc private func segmentedControlDidChanged(_ sender: UISegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        assert(segmentIndex <= 2)
        
        let complexity = VZGameComplexity.init(intValue: segmentIndex)
        model.setFilter(complexity: complexity)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
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
        
        let cell = StatisticsCell.cell(table: tableView, indexPath: indexPath)
        cell.configure(data: data, place: indexPath.row)

        return cell
    }
}

extension StatisticsViewController: StoryboardInstanceable {
    static var storyboardName: StoryboardList = .statistics
}
