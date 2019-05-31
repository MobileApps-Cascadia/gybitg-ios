//
//  GameStatRepositoryTests.swift
//  GYBITGTests
//
//  Created by James Hayes on 5/31/19.
//
// These tests are to make sure all the game stat repository methods are working correctly

import XCTest
@testable import GYBITG

class GameStatRepositoryTests: XCTestCase {

    // reference the protocol class
    var sut: GameStatProtocol!
    
    // constant values used for testing
    let testDate: Date = Date()
    let testUserId: String = "ksmith@gmail.com"
    let testStatId: Int = 1
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // initialize the game stat repo class
        sut = GameStatRepo()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Testing GameStat repository initializes
    func testInit_GameStatRepo() {
        var gameRepo: GameStatProtocol!
        gameRepo = GameStatRepo()
        
        XCTAssertNotNil(gameRepo)
    }
    
    // Testing the repository data array when no game stats are present
    func testRepoGameStatArray_EmptyArray() {
        
        // Test the repository count is zero when no game stats have been added
        XCTAssertEqual(sut.allGameStats.count, 0)
        
    }
    
    // Testing the 'add game stat' repository method
    // Should return the game stat repository data array with the newly added game stat entity
    func testRepoAddGameStat_GameStatInArray() {
        
        // Use the random game stat initilazer to create a new game stat
        let testGameStat = GameStat(random: true)
        
        // Add the game stat entity to the repository data array
        sut.addGameStat(gameStat: testGameStat)
        
        // Test the data array count is equal to 1
        XCTAssertEqual(sut.allGameStats.count, 1)
    }
    
    // Testing the 'remove game stat' repository method
    // Should remove the provided game stat
    func testRepoRemoveGameStat_GameStatRemovedFromArrray() {
        
        // First initialize a game stat
        let testGameStat = GameStat(random: true);
        
        // Next add the new game stat to the data array
        sut.addGameStat(gameStat: testGameStat)
        // Test the game stat has been added to the repo data array
        XCTAssertEqual(sut.allGameStats.count, 1)
        
        // Call the 'remove game stat' method
        sut.removeGameStat(gameStat: testGameStat)
        
        // Test that the repo data array count is back to zero after removing only game stat
        XCTAssertEqual(sut.allGameStats.count, 0)
    }
    
    // Testing the 'remove game stat by stat id' repository method
    // Should remove the game stat with the statId parameter
    func testRepoRemoveGameStatId_GameStatRemovedFromArray() {
        
        // Initialize a game stat with our constant test statId = 1
        let testGameStat = GameStat(random: true)
        testGameStat.statId = testStatId
        
        // Test that the game stat, statId, is equal to our testStatId (1)
        XCTAssertEqual(testGameStat.statId, testStatId)
        //Test the repo data array count = 0, since we haven't added anything yet
        XCTAssertEqual(sut.allGameStats.count, 0)
        
        // Add the game stat and test that it has been added to repo data array
        sut.addGameStat(gameStat: testGameStat)
        XCTAssertEqual(sut.allGameStats.count, 1)
        
        // Remove the game stat by statId (1) and test it has been removed from repo data array
        sut.removeGameStatByStatId(statId: testGameStat.statId)
        XCTAssertEqual(sut.allGameStats.count, 0)
    }

    // Testing the 'get game stat by statId' repository method
    // Should return the game stat with the statId parameter
    func testGetGameStatByStatId_GameStat() {
        
        // Initialize a game stat with our constant statId
        let testGameStat = GameStat(random: true)
        testGameStat.statId = testStatId
        
        // Test that the game stat, statId, is equal to our testStatId (1)
        XCTAssertEqual(testGameStat.statId, testStatId)
        //Test the repo data array count = 0, since we haven't added anything yet
        XCTAssertEqual(sut.allGameStats.count, 0)
        
        // Add the game stat and test that it has been added to repo data array
        sut.addGameStat(gameStat: testGameStat)
        XCTAssertEqual(sut.allGameStats.count, 1)
        
        /* Reference a new game stat to store our retrieved game stat by statId parameter;
         * we will use our testStatId as the input parameter
        */
        let _gameStat = sut.getGameStatByStatId(statId: testStatId)
        // Test to see if the retrieved game stat has the same statId as our testGameStat
        XCTAssertEqual(_gameStat.statId, testGameStat.statId)
    }
    
    // Testing the 'get game by userId' repository method
    // Should return an array of game stat entities with the userId parameter
    func testGetGameStatByUserId_ArrayOfGameStat() {
        
        // Initialize two game stat entities with our constant userId value (ksmith@gmail.com)
        let testGameStat1 = GameStat(random: true)
        let testGameStat2 = GameStat(random: true)
        testGameStat1.userId = testUserId
        testGameStat2.userId = testUserId
        
        // Test that the game stats, statId property, is equal to our testUserId (ksmith@gmail.com)
        XCTAssertEqual(testGameStat1.userId, testUserId)
        XCTAssertEqual(testGameStat2.userId, testUserId)
        
        // Test the repo data array count = 0, since we haven't added any game stat entities yet
        XCTAssertEqual(sut.allGameStats.count, 0)
        
        // Add the two game stat entities and test they have been added to the repo data array
        sut.addGameStat(gameStat: testGameStat1)
        sut.addGameStat(gameStat: testGameStat2)
        XCTAssertEqual(sut.allGameStats.count, 2)
        
        /* Initialize a new game stat array to store our retrieved game stat entities by userId parameter;
         * we will use our testUserId as the input parameter
        */
        let testGameStatArray: [GameStat] = sut.getAllGameStatsByUserId(userId: testUserId)
        // Test to make sure that all the game stats with the testUserId have occupied our testGameStatArray
        XCTAssertEqual(testGameStatArray.count, 2)
    }
}
