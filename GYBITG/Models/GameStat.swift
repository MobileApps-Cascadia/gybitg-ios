//
//  GameStat.swift
//  GYBITG
//
//  Created by Student Account on 4/26/19.
//

import Foundation

struct GameStat {
    
    let points: Int
    let rebounds: Int
    let assists: Int
    let steals: Int
    let blocks: Int
    let minutesPlayed: Int
    let gameDate: Date
    let userId: String
    let statId: Int

    
    init(points: Int, rebounds: Int, assists: Int, steals: Int,
         blocks: Int, minutesPlayed: Int, gameDate: Date, userId: String, statId: Int) {
        self.points = points
        self.rebounds = rebounds
        self.assists = assists
        self.steals = steals
        self.blocks = blocks
        self.minutesPlayed = minutesPlayed
        self.gameDate = gameDate
        self.userId = userId
        self.statId = statId
    }
    
}
