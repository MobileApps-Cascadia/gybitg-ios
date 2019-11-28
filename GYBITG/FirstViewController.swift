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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gameRepo?.getAllGameStatsByUserId(userId: Constants.TEST_USERID)
        // update the badge number for the Notifications tab icon
        if let tabItems = tabBarController?.tabBar.items {
            let x : Int = (gameRepo?.allGameStatDrafts.count)!
            let count = String(x)
            
            // In this case we want to modify the badge number of the third (2 - Notifications) tab:
            let tabItem = tabItems[2]
            tabItem.badgeValue = (x > 0 ? count : nil)
        }
    }

    // Handle the segues to the GameStatHistoryViewController and GalleryViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // The 'forward' method is located in the UIStoryboardSegue file
        // Use the enum in the UIStoryboard file to grab the segue identifier; segueShowGameStatHistory
        if(segue.identifier == UIStoryboardSegue.AppSegue.segueShowGameStatHistory.rawValue) {
            segue.forward(gameRepo!, to: segue.destination)
        }
        if(segue.identifier == UIStoryboardSegue.AppSegue.FirstViewToGallerySegue.rawValue) {
                segue.forward(galleryRepo!, to: segue.destination)
        }
    }
    
}

