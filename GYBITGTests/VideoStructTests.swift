//
//  VideoStructTests.swift
//  GYBITGTests
//
//  Created by juanita aguilar on 4/26/19.
//

import XCTest
@testable import GYBITG
import CoreMedia

class VideoStructTests: XCTestCase {
        
        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.
        }
        
        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }
        
        //testing the initializer for the Video Model the expected result is a Video with an id
        //testing the video is not nil
        //testing the testVideo created has a videoID of 1
        func testInit_VideoWithVideoID(){
            let timeInterval3: TimeInterval = 119
            let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
            let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
            let testVideo = Video(videoID: "1", dateTaken: Date(), fileName: "video file 1", videoDuration: videoDuration, videoURL: components.url!)
            XCTAssertNotNil(testVideo)
            XCTAssertEqual(testVideo.videoID, "1")
            
        }
        
        //testing for the initializer for the Video model with expetcted video id and a description
        func testInit_VideoWithVideoIAndTitleAndDescription(){
            let timeInterval3: TimeInterval = 119
            let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
            let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
            let testVideo = Video(videoID: "2", description: "me shooting a 3 pointer", dateTaken: Date(), fileName: "video file 2", videoDuration: videoDuration, videoURL: components.url!)
            XCTAssertNotNil(testVideo)
            XCTAssertEqual(testVideo.description, "me shooting a 3 pointer")
        }
        //testing for the initializer for the Video model with expetcted video id, a description
        //and a dateTaken
        func testInit_VideoWithVideoIAndTitleAndDescriptionAndDateTaken(){
            let timeInterval3: TimeInterval = 119
            let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
            let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
            let testVideo = Video(videoID: "3", description: "Me doing drills", dateTaken: Date(), fileName: "video file 3", videoDuration: videoDuration, videoURL: components.url!)
            let  testDate = testVideo.dateTaken
            XCTAssertNotNil(testVideo)
            XCTAssertEqual(testVideo.dateTaken, testDate)
        }
        
        //testing for the initializer for the Video model with expetcted video id, a description,
        //a dateTaken and a fileName
        func testInit_VideoWithVideoIAndTitleAndDescriptionAndDateTakenAndFileName(){
            let date = Date()
            let timeInterval3: TimeInterval = 119
            let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
            let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
            let testVideo = Video(videoID: "4", description: "me doing sprints", dateTaken: date, fileName:"video file 4", videoDuration: videoDuration, videoURL: components.url!)
            XCTAssertNotNil(testVideo)
            XCTAssertEqual(testVideo.fileName, "video file 4")
        }
        
        //testing for the initializer for the Video model with expetcted video id  a description,
        //a dateTaken and a fileName and a VideoLength
        func testInit_VideoWithVideoIAndTitleAndDescriptionAndDateTakenAndFileNameAndVideoDuration(){
            let date = Date()
            //****get the TimeInterval(TimeInterval is a double)and convert it to a CMTime
            let timeInterval3: TimeInterval = 119
            let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
            let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
            let testVideo = Video(videoID: "5", dateTaken: date, fileName: "video file 5", videoDuration: videoDuration, videoURL: components.url!)
            XCTAssertNotNil(testVideo)
            XCTAssertEqual(testVideo.videoDuration, videoDuration)
        
        }
        
        //testing for the initializer for the Video model with expetcted video id  a description,
        //a dateTaken and a fileName and a VideoLength
        //use URLComponents to deal with escape characters but have to unwrap the components.url
        func testInit_ideoWithVideoIAndTitleAndDescriptionAndDateTakenAndFileNameAndVideoDurationAndURL(){
            let date = Date()
            let timeInterval3: TimeInterval = 119
            let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
            let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
            
            let testVideo = Video(videoID: "6", dateTaken: date, fileName: "video file 6", videoDuration: videoDuration, videoURL: components.url!)
            XCTAssertNotNil(testVideo)
            XCTAssertEqual(testVideo.videoURL, components.url!)
        }
        
}


