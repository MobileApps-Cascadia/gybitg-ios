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
    var _gameStat: NSManagedObject = NSManagedObject()
    
    // Purpose: Update a GameStat field
    // Parameter: The GameStat object you need updated
    // Postcondition: The GameStat object is updated in CoreData
    func updateStat(gameStat: GameStat) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stat")
        
        let statId = String(gameStat.statId!)
        fetchRequest.predicate = NSPredicate(format: "statId == %@", statId)
        
        do {
            try _gameStat = managedContext.fetch(fetchRequest)[0]
            _gameStat.setValue(gameStat.statId, forKey: "statId")
            _gameStat.setValue(gameStat.userId, forKey: "userId")
            _gameStat.setValue(gameStat.gameDate, forKey: "gameDate")
            _gameStat.setValue(gameStat.isDraft, forKey: "isDraft")
            _gameStat.setValue(gameStat.points, forKey: "points")
            _gameStat.setValue(gameStat.rebounds, forKey: "rebounds")
            _gameStat.setValue(gameStat.assists, forKey: "assists")
            _gameStat.setValue(gameStat.blocks, forKey: "blocks")
            _gameStat.setValue(gameStat.steals, forKey: "steals")
            _gameStat.setValue(gameStat.minutesPlayed, forKey: "minutesPlayed")
            _gameStat.setValue(gameStat.opposingTeamName, forKey: "opposingTeamName")
            _gameStat.setValue(gameStat.homeOrAway, forKey: "homeOrAway")
            
            try managedContext.save()
        } catch let error as NSError {
            print("could not update, \(error), \(error.userInfo)")
        }
        
    }
    
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
        newGameStat.setValue(stat.isDraft, forKey: "isDraft")
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
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // Purpose: Fetch all the saved GameStats from CoreData
    // PostCondition: Returns an array of GameStat objects
    func fetchStatsByUserId(UserId id: String, withCompletion completion: @escaping ([[GameStat]]?) -> Void) {
        var tempGameStatArray = [[GameStat]]()
        var tempArray = [GameStat]()
        var tempDraftArray = [GameStat]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Stat")
        
        fetchRequest.predicate = NSPredicate(format: "userId = %@", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "statId", ascending: false)]
        do{
            stats = try managedContext.fetch(fetchRequest)
            for stat in stats {
                let statId = (stat.value(forKeyPath: "statId") as! Int)
                let userId = (stat.value(forKeyPath: "userId") as! String)
                let gameDate = (stat.value(forKeyPath: "gameDate") as! Date)
                let isDraft = (stat.value(forKeyPath: "isDraft") as! Bool)
                
                let points = (stat.value(forKeyPath: "points") as? Int) ?? 0
                let rebounds = (stat.value(forKeyPath: "rebounds") as? Int) ?? 0
                let assists = (stat.value(forKeyPath: "assists") as? Int) ?? 0
                let blocks = (stat.value(forKeyPath: "blocks") as? Int) ?? 0
                let steals = (stat.value(forKeyPath: "steals") as? Int) ?? 0
                let minutesPlayed = (stat.value(forKeyPath: "minutesPlayed") as? Double) ?? 0.0
                let opposingTeamName = (stat.value(forKeyPath: "opposingTeamName") as? String) ?? ""
                let homeOrAway = (stat.value(forKeyPath: "homeOrAway") as? String) ?? "Home"
                
                let tempStat = GameStat(statId: statId, userId: userId, gameDate: gameDate, isDraft: isDraft, points: points, rebounds: rebounds, assists: assists, steals: steals, blocks: blocks, minutesPlayed: minutesPlayed, opposingTeamName: opposingTeamName, homeOrAway: homeOrAway)
                
                if (tempStat.isDraft!) {
                    tempDraftArray.append(tempStat)
                }
                else {
                    tempArray.append(tempStat)
                }
            }
            tempGameStatArray.append(tempArray)
            tempGameStatArray.append(tempDraftArray)
            completion (tempGameStatArray)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
