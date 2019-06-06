//
//  UIStoryboardSegue.swift
//  GYBITG
//
//  Created by James Hayes on 5/31/19.
//

import UIKit

//protocol for all repos to inherit from so polymorphism can be used for the UIStoryboardSegue
//Each  Repository will define and return which type of Repo they are as a String
protocol Repo{
    func type()-> String
}

// Handle all the segues in one place
extension UIStoryboardSegue {
    // This forward function will handle 'forward' segues
    func forward(_ gameRepo: GameStatProtocol?, to destination: UIViewController){
        // Check to see if the destination view controller is a navigation controller, eg: using a modal segue there will be a navigation controller before the destination view controller.
        if let navigationController = destination as? UINavigationController {
            let root = navigationController.viewControllers[0]
            // Recursivley call itself to check the next destination view controller
            forward(gameRepo, to: root)
        }
        // Check the destination view controller; GameStatHistoryViewController or NewGameStatViewController, and pass the gameRepo to it
        if let gameStatHistViewController = destination as? GameStatHistoryViewController {
            gameStatHistViewController.gameRepo = gameRepo
        }
        if let newGameStatViewController = destination as? NewGameStatViewController {
            newGameStatViewController.gameRepo = gameRepo
        }
    
    }
    
    // This forward function will handle 'forward' segues
    func forward(_ repo: Repo, to destination: UIViewController){
        // Check to see if the destination view controller is a navigation controller, eg: using a modal segue there will be a navigation controller before the destination view controller.
        //The Generic repo is the parameter so all repositories that inherit from protocol Repo can be passed
        if(repo.type() == "videoRepo"){
            // Check the destination view controller; GalleryViewController, and pass the repo to it
            if let GalleryViewController = destination as? GalleryViewController {
                GalleryViewController.videoRepository = (repo as! VideoRepositoryProtocol)
            }
        }//else if(repo.type() == "?"){
        
    }

    // This enumeration will return the segue identifiers so we're not using the string literals
    // in the prepare functions when segueing to different views
    enum AppSegue : String {
        case segueShowGameStatHistory
        case segueModalGameStatForm
        case FirstViewToGallerySegue
    }
}
