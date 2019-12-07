//  This file is for the reusable cell that is in game stats history table-view

//  GameStatCell.swift
//  GYBITG
//
//  Created by James Hayes on 5/9/19.
//

import UIKit

class GameStatCell: UITableViewCell {
    
    @IBOutlet weak var gameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gameLabel.adjustsFontForContentSizeCategory = true
    }
}
