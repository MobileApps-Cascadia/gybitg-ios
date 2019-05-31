//
//  GameStatClassTests.swift
//  GYBITGTests
//
//  Created by Student Account on 4/26/19.
//

import XCTest
@testable import GYBITG

class GameStatStructTests: XCTestCase {
    let testDate: Date = Date()
    let testUserId: String = "ksmith@gmail.com"
    let testStatId: Int = 1

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Initialize GameStat
    /** Business Rule: Each GameStat has
    * required "gameDate" date property
    * required "userId" string property
    * required "statId" int property
    * required "points" int property
    * required "rebounds" int property
    * required "assists" int property
    * required "steals" int property
    * required "blocks" int property
    * required "minutesPlayed" int property
    * required "opposingTeamName" string property
    * required "homeOrAway" string property
    */
    
    // Test a GameStat with all required property
    func testInit_GameStatWithUserId() {
        let testGameStat = GameStat(statId: testStatId, userId: testUserId, gameDate: testDate, points: 23, rebounds: 7, assists: 11, steals: 6, blocks: 3, minutesPlayed: 33, opposingTeamName: "Huskies", homeOrAway: "Home")
        
        XCTAssertNotNil(testGameStat)
        
        XCTAssertEqual(testGameStat.userId, testUserId)
        XCTAssertEqual(testGameStat.statId, testStatId)
        XCTAssertEqual(testGameStat.gameDate, testDate)
        
        XCTAssertEqual(testGameStat.points, 23)
        XCTAssertEqual(testGameStat.rebounds, 7)
        XCTAssertEqual(testGameStat.assists, 11)
        XCTAssertEqual(testGameStat.steals, 6)
        XCTAssertEqual(testGameStat.blocks, 3)
        XCTAssertEqual(testGameStat.minutesPlayed, 33)
        XCTAssertEqual(testGameStat.opposingTeamName, "Huskies")
        XCTAssertEqual(testGameStat.homeOrAway, "Home")
        
    }
}
