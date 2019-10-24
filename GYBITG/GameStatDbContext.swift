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
    
    var stats: [NSManagedObject] = []
    var drafts: [NSManagedObject] = []
    
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
    
    // Purpose: Fetch all the saved GameStats from CoreData
    // PostCondition: Returns an array of GameStat objects
    func fetchStatsbyUserId(UserId id: String, withCompletion completion: @escaping ([GameStat]?) -> Void) {
        let tempStat = GameStat()
        var tempArray = [GameStat]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stat")
        
//        fetchRequest.predicate = NSPredicate(format: "userId = %@", id)
//        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "gameDate", ascending: false)]
        do{
            stats = try managedContext.fetch(fetchRequest)
            for stat in stats {
                tempStat.userId = (stat.value(forKeyPath: "userId") as! String)
                tempStat.statId = (stat.value(forKeyPath: "statId") as! Int)
                tempStat.gameDate = (stat.value(forKeyPath: "gameDate") as! Date)
                tempStat.points = (stat.value(forKeyPath: "points") as! Int)
                tempStat.rebounds = (stat.value(forKeyPath: "rebounds") as! Int)
                tempStat.assists = (stat.value(forKeyPath: "assists") as! Int)
                tempStat.blocks = (stat.value(forKeyPath: "blocks") as! Int)
                tempStat.steals = (stat.value(forKeyPath: "steals") as! Int)
                tempStat.minutesPlayed = (stat.value(forKeyPath: "minutesPlayed") as! Double)
                tempStat.opposingTeamName = (stat.value(forKeyPath: "opposingTeamName") as! String)
                tempStat.homeOrAway = (stat.value(forKeyPath: "homeOrAway") as! String)
                tempArray.append(tempStat)
            }
            completion (tempArray)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
