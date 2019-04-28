//
//  GameStatStructTests.swift
//  GYBITGTests
//
//  Created by Student Account on 4/26/19.
//

import XCTest
@testable import GYBITG

class GameStatStructTests: XCTestCase {
    let testDate: Date = Date()
    let testUserId: String = "ksmith0379"
    let testStatId: Int = 1

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Initialize GameStat
    /** Business Rule: Each GameStat has
    * optional "points" int property
    * optional "rebounds" int property
    * optional "assists" int property
    * optional "steals" int property
    * optional "blocks" int property
    * optional "minutesPlayed" int property
    * required "gameDate" date property
    * required "userId" string property
    * required "statId" int property
    */
    
    // Test a GameStat with optional points property
    func testInit_GameStatWithPoints() {

        let testGameStat = GameStat(points: 22, gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertNotNil(testGameStat)
        XCTAssertEqual(testGameStat.points, 22)
    }
    // Test a GameStat with optional rebounds property
    func testInit_GameStatWithRebounds() {
        let testGameStat = GameStat(rebounds: 6, gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.rebounds, 6)
    }
    // Test a GameStat with optional assists property
    func testInit_GameStatWithAssits() {
        let testGameStat = GameStat(assists: 9, gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.assists, 9)
        XCTAssertEqual(testGameStat.points, 0)
        XCTAssertEqual(testGameStat.rebounds, 0)
    }
    // Test a GameStat with optional steals property
    func testInit_GameStatWithSteals() {
        let testGameStat = GameStat(gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.steals, 0)
    }
    // Test a GameStat with optional blocks property
    func testInit_GameStatWithBlocks() {
        let testGameStat = GameStat(blocks: 3, gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.blocks, 3)
    }
    // Test a GameStat with optional minutesPlayed property
    func testInit_GameStatWithMinutesPlayed() {
        let testGameStat = GameStat(minutesPlayed: 30, gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.minutesPlayed, 30)
    }
    // Test a GameStat with required gameDate property
    func testInit_GameStatWithGameDate() {
        let testGameStat = GameStat(gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.gameDate, testDate)
    }
    // Test a GameStat with required userId property
    func testInit_GameStatWithUserId() {
        let testGameStat = GameStat(gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.userId, testUserId)
    }
    // Test a GameStat with required statId property
    func testInit_GameStatWithStatId() {
        let testGameStat = GameStat(gameDate: testDate, userId: testUserId, statId: testStatId)
        XCTAssertEqual(testGameStat.statId, testStatId)
    }
}
