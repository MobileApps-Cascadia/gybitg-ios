//
//  GalleryViewControllerTableViewCell.swift
//  GYBITG
//
//  Created by Student Account on 5/23/19.
//

import UIKit

class GalleryViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var thumbnail: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
