//
//  GameStatDbContext.swift
//  GYBITG
//
//  Created by James Hayes on 10/23/19.
//

import UIKit
import Foundation
import CoreData

public class GameStatDbContext {
    
    var stats: [GameStat] = []
    var drafts: [GameStat] = []
    
    
    // Purpose: Save a GameStat to our CoreData persistent data storage
    // Parameter: The GameStat object you want saved
    // PostCondition: The GameStat object is saved to CoreData
    func saveStat(stat: GameStat) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Stat", in: managedContext)!
        
        let newGameStat = NSManagedObject(entity: entity, insertInto: managedContext)
                
        newGameStat.setValue(stat.statId, forKey: "statId")
        newGameStat.setValue(stat.userId, forKey: "userId")
        newGameStat.setValue(stat.gameDate, forKey: "gameDate")
        newGameStat.setValue(stat.points, forKey: "points")
        newGameStat.setValue(stat.rebounds, forKey: "rebounds")
        newGameStat.setValue(stat.assists, forKey: "assists")
        newGameStat.setValue(stat.blocks, forKey: "blocks")
        newGameStat.setValue(stat.steals, forKey: "steals")
        newGameStat.setValue(stat.minutesPlayed, forKey: "minutesPlayed")
        newGameStat.setValue(stat.opposingTeamName, forKey: "opposingTeamName")
        newGameStat.setValue(stat.homeOrAway, forKey: "homeOrAway")
        
        do {
            try managedContext.save()
            print("GameStat saved to CoreData")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Purpose: Save a GameStat Draft to our CoreData persistent data Storage
    
    
}
