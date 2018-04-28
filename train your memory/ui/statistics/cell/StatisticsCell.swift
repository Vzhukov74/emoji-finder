//
//  StatisticsCell.swift
//  emojiFinder
//
//  Created by Vlad on 17.04.2018.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class StatisticsCell: UITableViewCell, CellRegistable, CellDequeueReusable {

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
    
    func configure(data: GameResult, place: Int) {
        self.nameLabel.text = data.user_name
        self.actionsLabel.text = String(data.actions)
        self.timeLabel.text = data.timeAsString()
        self.placeLabel.text = String(place)
    }
}
