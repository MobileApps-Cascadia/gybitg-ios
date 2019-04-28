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
    * required "gameDate" date property
    * required "userId" string property
    * required "statId" int property
    * optional "points" int property
    * optional "rebounds" int property
    * optional "assists" int property
    * optional "steals" int property
    * optional "blocks" int property
    * optional "minutesPlayed" int property
    */
    
    // Test a GameStat with required userId, statId, & gameDate property
    func testInit_GameStatWithUserId() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate)
        XCTAssertEqual(testGameStat.userId, testUserId)
        XCTAssertEqual(testGameStat.statId, testStatId)
        XCTAssertEqual(testGameStat.gameDate, testDate)
    }
    // Test a GameStat with optional points property
    func testInit_GameStatWithPoints() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate, points: 22)
        XCTAssertNotNil(testGameStat)
        XCTAssertEqual(testGameStat.points, 22)
    }
    // Test a GameStat with optional rebounds property
    func testInit_GameStatWithRebounds() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate, rebounds: 6)
        XCTAssertEqual(testGameStat.rebounds, 6)
    }
    // Test a GameStat with optional assists property
    func testInit_GameStatWithAssits() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate, assists: 9)
        XCTAssertEqual(testGameStat.assists, 9)
    }
    // Test a GameStat with optional steals property
    func testInit_GameStatWithSteals() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate)
        XCTAssertEqual(testGameStat.steals, 0)
    }
    // Test a GameStat with optional blocks property
    func testInit_GameStatWithBlocks() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate, blocks: 3)
        XCTAssertEqual(testGameStat.blocks, 3)
    }
    // Test a GameStat with optional minutesPlayed property
    func testInit_GameStatWithMinutesPlayed() {
        let testGameStat = GameStat(userId: testUserId, statId: testStatId, gameDate: testDate, minutesPlayed: 30)
        XCTAssertEqual(testGameStat.minutesPlayed, 30)
    }
}
