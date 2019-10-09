//
//  GameStat.swift
//  GYBITG
//
//  Created by James Hayes on 4/26/19.
//

import UIKit

class GameStat: NSObject, Codable {
    
    var statId: Int
    var userId: String
    var gameDate: Date
    var points: Int?
    var rebounds: Int?
    var assists: Int?
    var steals: Int?
    var blocks: Int?
    var minutesPlayed: Double?
    var opposingTeamName: String?
    var homeOrAway: String?
    
    init(statId: Int, userId: String, gameDate: Date, points: Int, rebounds: Int, assists: Int, steals: Int, blocks: Int, minutesPlayed: Double, opposingTeamName: String, homeOrAway: String) {
        self.statId = statId
        self.userId = userId
        self.gameDate = gameDate
        self.points = points
        self.rebounds = rebounds
        self.assists = assists
        self.steals = steals
        self.blocks = blocks
        self.minutesPlayed = minutesPlayed
        self.opposingTeamName = opposingTeamName
        self.homeOrAway = homeOrAway
    }
    
    // use this random initializer for testing
    convenience init(random: Bool = false) {
        let testDate: Date = Date()
        if random {
            let idx = arc4random_uniform(UInt32(100))
            let randomStatId = Int(idx)
            let randomUserId = "ksmith@gmail.com"
            self.init(statId: randomStatId, userId: randomUserId, gameDate: testDate, points: Int(arc4random_uniform(100)), rebounds: Int(arc4random_uniform(100)), assists: Int(arc4random_uniform(100)), steals: Int(arc4random_uniform(100)), blocks: Int(arc4random_uniform(100)), minutesPlayed: Double(arc4random_uniform(40)), opposingTeamName: "Huskies", homeOrAway: "Home")
        } else {
            self.init(statId: 1, userId: "ksmith@gmail.com", gameDate: testDate, points: 0, rebounds: 0, assists: 0, steals: 0, blocks: 0, minutesPlayed: 0.0, opposingTeamName: "Huskies", homeOrAway: "Home")
        }
    }
}
