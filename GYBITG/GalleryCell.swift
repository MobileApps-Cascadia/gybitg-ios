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
    @IBOutlet var Description: UILabel!
    @IBOutlet var videoDuration: UILabel!
    @IBOutlet var thumbnail: UIButton!
    @IBOutlet var Date: UILabel!
    
    
    //to make the labels know about the changed prefferred text size the user chooses via the Settings
    //application
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Description.adjustsFontForContentSizeCategory = true
      //  videoDuration.adjustsFontForContentSizeCategory = true
       //thumbnail.adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
}
