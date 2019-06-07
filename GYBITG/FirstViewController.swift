//
//  FirstViewController.swift
//  GYBITG
//
//  Created by Student Account on 4/25/19.
//

import UIKit

class FirstViewController: UIViewController {

    // This is the GameStatRepo that is instanitated in the AppDelegate file
    var gameRepo: GameStatProtocol?
    var galleryRepo: VideoRepositoryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Handle the segues to the GameStatHistoryViewController and GalleryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // The 'forward' method is located in the UIStoryboardSegue file
        // Use the enum in the UIStoryboard file to grab the segue identifier; segueShowGameStatHistory
        if(segue.identifier == UIStoryboardSegue.AppSegue.segueShowGameStatHistory.rawValue) {
            segue.forward(gameRepo, to: segue.destination)
        }
        if(segue.identifier == UIStoryboardSegue.AppSegue.FirstViewToGallerySegue.rawValue) {
                segue.forward(galleryRepo!, to: segue.destination)
        }
    }
    
}

