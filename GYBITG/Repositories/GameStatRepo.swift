//  This is the GameStatRepo that will store the functions for add, removing, and editing a GameStat
//  The repo conforms to the protocol which is located in GameStatHistoryViewController
//
//  GameStatRepo.swift
//  GYBITG
//
//  Created by James Hayes on 5/9/19.
//

import UIKit

class GameStatRepo: GameStatProtocol {
    
    func getAllGameStatsByUserId(userId: String) -> [GameStat] {
        var mGameStatArray: [GameStat] = []
        for stat in allGameStats {
            if stat.userId == userId {
                mGameStatArray.append(stat)
            }
        }
        return mGameStatArray
    }
    
    
    // This function returns a specific GameStat object based on the statId
    func getGameStatByStatId(statId: Int) -> GameStat {
        for stat in allGameStats {
            if stat.statId == statId {
                return stat
            }
        }
        return GameStat(random: true)
    }
    
    // This is mainly for testing and creating random GameStat objects
    @discardableResult func createRandomGameStat() -> GameStat {
        let newGameStat = GameStat(random: true)
        allGameStats.append(newGameStat)
        return newGameStat
    }
    
    // This is an array that can store GameStat objects
    var allGameStats: [GameStat] = []
    
    // This function can remove GameStat objects from the array
    func removeGameStat(gameStat: GameStat) {
        if let index = allGameStats.firstIndex(of: gameStat) {
            allGameStats.remove(at: index)
        }
    }
    
    // This function will be used in the NewGameStatViewController for adding GameStat objects through the form
    func addGameStat(gameStat: GameStat) {
        gameStat.statId = allGameStats.count + 1
        allGameStats.append(gameStat)
    }
    
    
}
