//
//  GameStat.swift
//  GYBITG
//
//  Created by James Hayes on 4/26/19.
//

import UIKit

class GameStat: NSObject, Codable {
    
    var statId: Int?
    var userId: String?
    var gameDate: Date?
    var isDraft: Bool?
    var points: Int?
    var rebounds: Int?
    var assists: Int?
    var steals: Int?
    var blocks: Int?
    var minutesPlayed: Double?
    var opposingTeamName: String?
    var homeOrAway: String?
    
    override init() {
        
    }
    
    // simple initializer
    init(statId: Int, userId: String, gameDate: Date, isDraft: Bool) {
        self.statId = statId
        self.userId = userId
        self.gameDate = gameDate
        self.isDraft = isDraft
    }
    
    // full initializer
    init(statId: Int, userId: String, gameDate: Date, isDraft: Bool, points: Int, rebounds: Int, assists: Int, steals: Int, blocks: Int, minutesPlayed: Double, opposingTeamName: String, homeOrAway: String) {
        self.statId = statId
        self.userId = userId
        self.gameDate = gameDate
        self.isDraft = isDraft
        self.points = points
        self.rebounds = rebounds
        self.assists = assists
        self.steals = steals
        self.blocks = blocks
        self.minutesPlayed = minutesPlayed
        self.opposingTeamName = opposingTeamName
        self.homeOrAway = homeOrAway
    }
    
    // builder functions
    func addPoints(points: Int) {
        self.points = points
    }
    func addRebounds(rebounds: Int) {
        self.rebounds = rebounds
    }
    func addAssists(assists: Int) {
        self.assists = assists
    }
    func addSteals(steals: Int) {
        self.steals = steals
    }
    func addBlocks(blocks: Int) {
        self.blocks = blocks
    }
    func addMinPlayed(minPlayed: Double) {
        self.minutesPlayed = minPlayed
    }
    func addOppTeam(oppTeam: String) {
        self.opposingTeamName = oppTeam
    }
    func addLocation(location: String) {
        self.homeOrAway = location
    }
    
    // use this random initializer for testing
    convenience init(random: Bool = false) {
        let testDate: Date = Date()
        let draftStatus = true
        if random {
            let idx = arc4random_uniform(UInt32(100))
            let randomStatId = Int(idx)
            let randomUserId = Constants.TEST_USERID
            self.init(statId: randomStatId, userId: randomUserId, gameDate: testDate, isDraft: draftStatus, points: Int(arc4random_uniform(100)), rebounds: Int(arc4random_uniform(100)), assists: Int(arc4random_uniform(100)), steals: Int(arc4random_uniform(100)), blocks: Int(arc4random_uniform(100)), minutesPlayed: Double(arc4random_uniform(40)), opposingTeamName: "Huskies", homeOrAway: "Home")
        } else {
            self.init(statId: 1, userId: Constants.TEST_USERID, gameDate: testDate, isDraft: draftStatus, points: 0, rebounds: 0, assists: 0, steals: 0, blocks: 0, minutesPlayed: 0.0, opposingTeamName: "Huskies", homeOrAway: "Home")
        }
    }
}
