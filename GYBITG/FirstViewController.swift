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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // Handle the segues to the GameStatHistoryViewController and GalleryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // The 'forward' method is located in the UIStoryboardSegue file
        if(segue.identifier == "segueShowGameStatHistory") {
            segue.forward(gameRepo, to: segue.destination)
        }
    }
    
}

