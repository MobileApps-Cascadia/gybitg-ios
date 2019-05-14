//  This is the GameStatRepo that will store the functions for add, removing, and editing a GameStat
//  The repo conforms to the protocol which is located in GameStatHistoryViewController
//
//  GameStatRepo.swift
//  GYBITG
//
//  Created by James Hayes on 5/9/19.
//

import UIKit

class GameStatRepo: GameStatRepoProtocol {
    
    // This function returns a specific GameStat object based on the statId
    func getGameStat(statId: Int) -> GameStat {
        
        return GameStat()
    }
    
    // This is mainly for testing and creating random GameStat objects
    @discardableResult func createGameStat() -> GameStat {
        let newGameStat = GameStat(random: true)
        allGameStats.append(newGameStat)
        return newGameStat
    }
    
    // This is an array that can store GameStat objects
    var allGameStats: [GameStat] = []
    
    // This function can remove GameStat objects from the array
    func removeItem(gameStat: GameStat) {
        if let index = allGameStats.firstIndex(of: gameStat) {
            allGameStats.remove(at: index)
        }
    }
    
    // This function will be used in the GameStatViewController for adding GameStat objects through the form
    func addGameStat(gameStat: GameStat) {
        let statId = allGameStats.count + 1
        
        let newGameStat = GameStat(statId: statId, userId: "ksmith@gmail.com", gameDate: gameStat.gameDate, points: gameStat.points, rebounds: gameStat.rebounds, assists: gameStat.assists, steals: gameStat.steals, blocks: gameStat.blocks, minutesPlayed: gameStat.minutesPlayed)
        
        allGameStats.append(newGameStat)
    }
    
    
}
