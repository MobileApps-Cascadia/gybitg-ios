//
//  GameStatRepo.swift
//  GYBITG
//
//  Created by Student Account on 5/9/19.
//

import UIKit

class GameStatRepo: GameStatRepoProtocol {
    
    @discardableResult func createGameStat() -> GameStat {
        let newGameStat = GameStat(random: true)
        allGameStats.append(newGameStat)
        return newGameStat
    }
    
    var allGameStats: [GameStat] = []
    
    func removeItem(gameStat: GameStat) {
        if let index = allGameStats.firstIndex(of: gameStat) {
            allGameStats.remove(at: index)
        }
    }
    
    func addGameStat(gameStat: GameStat) {
        let statId = allGameStats.count + 1
        
        let newGameStat = GameStat(statId: statId, userId: "ksmith11", gameDate: gameStat.gameDate, points: gameStat.points, rebounds: gameStat.rebounds, assists: gameStat.assists, steals: gameStat.steals, blocks: gameStat.blocks, minutesPlayed: gameStat.minutesPlayed)
        
        allGameStats.append(newGameStat)
    }
    
    
}
