//
//  UIStoryboardSegue.swift
//  GYBITG
//
//  Created by James Hayes on 5/31/19.
//

import UIKit

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
    func forward(_ galleryRepo: VideoRepositoryProtocol?, to destination: UIViewController){
        // Check to see if the destination view controller is a navigation controller, eg: using a modal segue there will be a navigation controller before the destination view controller.
        if let navigationController = destination as? UINavigationController {
            let root = navigationController.viewControllers[0]
            // Recursivley call itself to check the next destination view controller
            forward(galleryRepo, to: root)
        }
        // Check the destination view controller;  GalleryViewController and pass the gallertRepo to it
        if let GalleryViewController = destination as? GalleryViewController {
            GalleryViewController.videoRepository = galleryRepo
        }
    }
    
    // This enumeration will return the segue identifiers so we're not using the string literals
    // in the prepare functions when segueing to different views
    enum AppSegue : String {
        case segueShowGameStatHistory
        case segueModalGameStatForm
        case FirstViewToGallerySegue
    }
}
