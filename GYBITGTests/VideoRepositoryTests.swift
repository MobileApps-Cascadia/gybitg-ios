//
//  VideoRepositoryTests.swift
//  GYBITGTests
//
//  Created by juanita aguilar on 5/9/19.
//

import XCTest
@testable import GYBITG
import CoreMedia

class VideoRepositoryTests: XCTestCase {
var sut: VideoRepository!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
         sut = VideoRepository()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

  
    //MARK: testing VideoRepository initializer
    func testInit_ReturnsVideoRepositoryInstance(){
        
        let videoRepository = VideoRepository()
        
        XCTAssertNotNil(videoRepository)
        
        
    }
    
    //MARK: testing VideoRepository initializer
    func testInit_CountOfVideosArrayZero(){
        XCTAssertEqual(sut.videos.count, 0)
    }
    
    
    //MARK: testing addVideo
    func testAddVideo_ReturnVideoID(){

        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo1 = Video(videoID: "7", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        
        let videoAddedID = sut.addVideo(videoToAdd: testVideo1)
        XCTAssertNotNil(videoAddedID)
        XCTAssertEqual(sut.getAllVideos().count, 1)
        XCTAssertEqual(sut.getAllVideos()[0], testVideo1)
        XCTAssertEqual(sut.getAllVideos()[0].videoID, testVideo1.videoID)
        
    }
    
    //MARK: testing getVideo
    func testGetVideo_ReturnVideo(){
        
        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo1 = Video(videoID: "7", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        
        let videoAddedID = sut.addVideo(videoToAdd: testVideo1)
        XCTAssertNotNil(videoAddedID)
        
        let testVideoReturn = sut.getVideo(videoID: testVideo1.videoID)
        
        XCTAssertNotNil(testVideoReturn)
        XCTAssertEqual(testVideoReturn, testVideo1)
    }
    
     //MARK: testing getVideo for nil
    func testGetVideo_ReturnNil(){
        
        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
       let testVideo1 = Video(videoID: "7", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        
        let testVideoID = sut.getVideo(videoID: testVideo1.videoID)
       
        XCTAssertNil(testVideoID)
    }
        
    //MARK: testing deleting the video
    func testDelete_ReturnsVideoIDOfDeleted(){

        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo1 = Video(videoID: "7", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        
       let videoAdded1 = sut.addVideo(videoToAdd: testVideo1)
        XCTAssertEqual(sut.videos.count, 1)
        XCTAssertNotNil(videoAdded1)
       
        let deletedVideoID =  sut.deleteVideo(videoToDeleteID: testVideo1.videoID)
        
        XCTAssertEqual(sut.videos.count, 0)
        XCTAssertEqual(deletedVideoID, testVideo1.videoID)
        XCTAssertEqual(deletedVideoID, videoAdded1)
        
    }
    
    //MARK: testing deleting the videos in the array
    func testDelete_AllVideosWillBeDeleted(){
        
        let date = Date()
        let timeInterval: TimeInterval = 600
        let videoDuration = CMTime(seconds: (timeInterval), preferredTimescale: 1)
        let components = URLComponents(string: "https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/LoadingResources/Introduction/Introduction.html#//apple_ref/doc/uid/10000051i)")!
        
        let testVideo1 = Video(videoID: "7", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        let testVideo2 = Video(videoID: "8", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        let testVideo3 = Video(videoID: "9", dateTaken: date, fileName: "video file 7", videoDuration: videoDuration, videoURL: components.url!, userID: "7")
        
        let videoAdded1 = sut.addVideo(videoToAdd: testVideo1)
        let videoAdded2 =  sut.addVideo(videoToAdd: testVideo2)
        let videoAdded3 = sut.addVideo(videoToAdd: testVideo3)
        
        XCTAssertNotNil(videoAdded1)
        XCTAssertNotNil(videoAdded2)
        XCTAssertNotNil(videoAdded3)
        sut.deleteAllVideos()
        XCTAssertEqual(sut.videos.count, 0)
        
        let videoToDelete = sut.deleteVideo(videoToDeleteID: testVideo1.videoID)
        XCTAssertNil(videoToDelete)
        let videoToUpdate = sut.updateVideo(videoToUpdateID: testVideo2.videoID, description: "Update")
        XCTAssertNil(videoToUpdate)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
