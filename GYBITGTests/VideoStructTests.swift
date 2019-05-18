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
    
    //Testing the initializer for the Video Model the expected result is a Video with an id.
    //Testing the video is not nil.
    //Testing the testVideo created has a videoID of 1.
    func testInit_VideoWithVideoID(){
        
        let timeInterval3: TimeInterval = 119
        let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "1", dateTaken: Date(), fileName: "video file 1", videoDuration: videoDuration, videoURL: components.url!, userID: "1")
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.videoID)
        XCTAssertEqual(testVideo.videoID, "1")
        
        XCTAssertNil(testVideo.description)
        XCTAssertNil(testVideo.longerVideoURL)
        
    }
    
    //Testing for the initializer for the Video model with expetcted videoID and a description.
    func testInit_VideoWithVideoIDAndDescription(){
        
        let timeInterval3: TimeInterval = 119
        let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "2", description: "me shooting a 3 pointer", dateTaken: Date(), fileName: "video file 2", videoDuration: videoDuration, videoURL: components.url!, userID: "2")
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.description)
        XCTAssertEqual(testVideo.description, "me shooting a 3 pointer")
        
    }
    
    //Testing for the initializer for the Video model with expetcted videoID, a description and a dateTaken.
    func testInit_VideoWithVideoIDAndDescriptionAndDateTaken(){
        
        let timeInterval3: TimeInterval = 119
        let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "3", description: "Me doing drills", dateTaken: Date(), fileName: "video file 3", videoDuration: videoDuration, videoURL: components.url!, userID: "3")
        let  testDate = testVideo.dateTaken
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.dateTaken)
        XCTAssertEqual(testVideo.dateTaken, testDate)
        
    }
    
    //Testing for the initializer for the Video model with expetcted videoID, a description, a dateTaken and a fileName.
    func testInit_VideoWithVideoIDAndDescriptionAndDateTakenAndFileName(){
        
        let date = Date()
        let timeInterval3: TimeInterval = 119
        let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "4", description: "me doing sprints", dateTaken: date, fileName:"video file 4", videoDuration: videoDuration, videoURL: components.url!, userID: "4")
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.fileName)
        XCTAssertEqual(testVideo.fileName, "video file 4")
        
    }
    
    //Testing for the initializer for the Video model with expetcted videoID, a description,a dateTaken a fileName and a VideoDuration.
    func testInit_VideoWithVideoIDAndDescriptionAndDateTakenAndFileNameAndVideoDuration(){
        
        let date = Date()
        //****get the TimeInterval(TimeInterval is a double)and convert it to a CMTime
        let timeInterval3: TimeInterval = 119
        let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "5", description: "Highlights of championships", dateTaken: date, fileName: "video file 5", videoDuration: videoDuration, videoURL: components.url!, userID: "5")
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.videoDuration)
        XCTAssertEqual(testVideo.videoDuration, videoDuration)
        
    }
    
    //Testing for the initializer for the Video model with expetcted videoID, a description, a dateTaken, a fileName and a VideoDuration.
    //Use URLComponents to deal with escape characters but have to unwrap the components.url.
    func testInit_VideoWithVideoIDAndDescriptionAndDateTakenAndFileNameAndVideoDurationAndURL(){
        
        let date = Date()
        let timeInterval3: TimeInterval = 119
        let videoDuration = CMTime(seconds:(timeInterval3), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "6", description: "Highlights of championships", dateTaken: date, fileName: "video file 6", videoDuration: videoDuration, videoURL: components.url!, userID: "6")
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.videoURL)
        XCTAssertEqual(testVideo.videoURL, components.url!)
        
    }
    
    //Testing for the initializer for the video model with expected videoId, a description, a dateTaken, a fileName, a videoDuration a videoURL and a userID
    func testInit_VideoWithVideoIDAndDescriptionAndDateTakenAndFileNameAndVideoDurationAndURLAndUserID(){
        
        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "7", description: "Highlights of championships", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        
        XCTAssertNotNil(testVideo)
        XCTAssertNotNil(testVideo.userID)
        XCTAssertEqual(testVideo.userID, "7")
        XCTAssertNotNil(testVideo.videoID)
        XCTAssertNotNil(testVideo.description)
        XCTAssertEqual(testVideo.description, "Highlights of championships")
        XCTAssertNotNil(testVideo.dateTaken)
        XCTAssertEqual(testVideo.dateTaken, date)
        XCTAssertNotNil(testVideo.fileName)
        XCTAssertEqual(testVideo.fileName, "video file 7")
        XCTAssertNotNil(testVideo.videoDuration)
        XCTAssertEqual(testVideo.videoDuration, videoDuration)
        XCTAssertNotNil(testVideo.videoURL)
        XCTAssertEqual(testVideo.videoURL, components.url!)
        
        
    }
    
    //Testing for the initializer with videoID, a description, a dateTaken, a fileName a VideoDuration, a videoURL a userID and a longerVideoURL
    func testInit_VideoWithVideoIDAndDescriptionAndDateTakenAndFileNameAndVideoDurationAndURLAndUserIDAndLongerVideoURL(){
    
        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let longerComponents = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "7", description: "Highlights of championships", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7", longerVideoURL: longerComponents.url!) //need to unwrap the optional url of the components
        
        XCTAssertNotNil(testVideo.longerVideoURL)
        XCTAssertEqual(testVideo.longerVideoURL!, longerComponents.url!)
        
    }
    
    //Testing if the video on the left-handside is equal to the video on the right-hand side
    func testEquatable_ReturnTrueLhsEqualRhs(){
        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let longerComponents = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo = Video(videoID: "7", description: "Highlights of championships", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7", longerVideoURL: longerComponents.url!) //need to unwrap the optional url of the components
        let testVideo2 = Video(videoID: "7", description: "Highlights of championships", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7", longerVideoURL: longerComponents.url!) //need to unwrap the optional url of the components
        
        XCTAssertEqual(testVideo, testVideo2)
        
        
        
    }
    
}


