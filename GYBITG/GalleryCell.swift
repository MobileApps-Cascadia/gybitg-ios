//
//  GalleryCell.swift
//  GYBITG
//
//  Created by juanita aguilar on 5/23/19.
//

import Foundation
import UIKit


// configure UITableViewcell in storyboard
class GalleryCell: UITableViewCell {
    
    //These are not outlets on a controller They are outlest on a view - the custom UITableViewCell
    //So Have to connect them to the ITemCell pg214  Control click on the itemCell in the document outline and make 3 connecitons
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var videoDurationLabel: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    
    
    //to make the labels know about the changed prefferred text size the user chooses via the Settings
    //application
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.adjustsFontForContentSizeCategory = true
        videoDurationLabel.adjustsFontForContentSizeCategory = true
        thumbnail.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
}
