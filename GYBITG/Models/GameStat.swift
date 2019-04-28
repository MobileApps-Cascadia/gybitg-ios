//
//  GameStat.swift
//  GYBITG
//
//  Created by Student Account on 4/26/19.
//

import Foundation

struct GameStat {
    
    let statId: Int
    let userId: String
    let gameDate: Date
    let points: Int?
    let rebounds: Int?
    let assists: Int?
    let steals: Int?
    let blocks: Int?
    let minutesPlayed: Double?
   

    init(points: Int? = 0, rebounds: Int? = 0, assists: Int? = 0,steals: Int? = 0, blocks: Int? = 0, minutesPlayed: Double? = 0.0, gameDate: Date, userId: String, statId: Int) {
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
