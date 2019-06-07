//  This is the GameStatRepo that stores the methods for storing, adding, removing, and editing a GameStat
//  The repository conforms to the protocol which is located in GameStatHistoryViewController
//
//  GameStatRepo.swift
//  GYBITG
//
//  Created by James Hayes on 5/9/19.
//

import UIKit

class GameStatRepo: GameStatProtocol {
    
    
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
        return "GameRepo"
    }
    
    // This is an array that can store GameStat entities
    var allGameStats: [GameStat] = []
    
    // This function is used in the NewGameStatViewController for adding GameStat entity through the form
    func addGameStat(gameStat: GameStat) {
        gameStat.statId = allGameStats.count + 1
        allGameStats.append(gameStat)
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
    func getAllGameStatsByUserId(userId: String) -> [GameStat] {
        var mGameStatArray: [GameStat] = []
        for stat in allGameStats {
            if stat.userId == userId {
                mGameStatArray.append(stat)
            }
        }
        return mGameStatArray
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
