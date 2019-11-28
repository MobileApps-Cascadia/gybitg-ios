//  Purpose: To store the methods for retrieving, creating, deleting, and updating a GameStat from storage
//  The repository conforms to the protocols which is located in GameStatHistoryViewController
//
//  GameStatRepo.swift
//  GYBITG
//
//  Created by James Hayes on 5/9/19.
//

import UIKit

class GameStatRepo: GameStatProtocol {

    // context to the class for core data operations
    let _context = GameStatDbContext()

    // This is an array that can store GameStat entities
    var allGameStats: [GameStat] = []
    
    // Purpose: store saved gamestat drafts
    var allGameStatDrafts: [GameStat] = []
    
    // Purpose: return all the saved gamestat drafts by userId
    // Parameters: a userId
    func getAllGameStatDraftsByUserId(userId: String) -> [GameStat] {
        return allGameStatDrafts
    }
    
    // Purpose: return all the saved drafts
    func getAllDrafts() -> [GameStat] {
        return allGameStatDrafts
    }
    
    // Purpose: to save a gamestat in the gamestat draft array
    // Parameter: a incomplete gamestat object
    func saveGameStatDraft(gameStat: GameStat) {
        allGameStatDrafts.append(gameStat)
        _context.saveStat(stat: gameStat)
    }

    // Used to update a current Game Stat
    // Parameter: Game Stat
    func updateGameState(gamestat: GameStat) {
        for (index, old) in allGameStats.enumerated() {
            if old.statId == gamestat.statId {
                allGameStats[index] = gamestat
                break
            }
        }
    }
    
    // Used for the UIStoryboardSegue to return the type of view controller we're forwarding to
    func type() -> String {
        return UIStoryboardSegue.RepoTypes.GameRepo.rawValue
    }
    
    // This function is used in the NewGameStatViewController for adding GameStat entity through the form
    func addGameStat(gameStat: GameStat) {
        allGameStats.append(gameStat)
        _context.saveStat(stat: gameStat)
    }
    
    // Remove a game stat by the statId parameter
    func removeGameStatByStatId(statId: Int) {
        var _gameStat: GameStat
        for stat in allGameStats {
            if stat.statId == statId{
                _gameStat = stat
                if let index = allGameStats.firstIndex(of: _gameStat) {
                    allGameStats.remove(at: index)
                }
            }
        }
    }
    
    // This function can remove the provided GameStat entity from the array
    func removeGameStat(gameStat: GameStat) {
        if let index = allGameStats.firstIndex(of: gameStat) {
            allGameStats.remove(at: index)
        }
    }
    
    // Retrieve all the game stat entities by the userId parameter
    func getAllGameStatsByUserId(userId: String) {
        // fetch an array of GameStat objects from CoreData
        // use a closure to fill the allGameStats array
        _context.fetchStatsByUserId(UserId: Constants.TEST_USERID){ (data) in
            if (data?.count ?? 0 > 0) {
                self.allGameStats = data![0]
                self.allGameStatDrafts = data![1]
            } else {
                print("You have no stats saved")
                return
            }
        }
    }
    
    // This function returns a specific GameStat entity based on the statId parameter
    func getGameStatByStatId(statId: Int) -> GameStat {
        for stat in allGameStats {
            if stat.statId == statId {
                return stat
            }
        }
        return GameStat(random: true)
    }
    
    // This method is used for testing and initializing and adding a random GameStat entity to the data array
    @discardableResult func createRandomGameStat() -> GameStat {
        let newGameStat = GameStat(random: true)
        allGameStats.append(newGameStat)
        return newGameStat
    }
}
