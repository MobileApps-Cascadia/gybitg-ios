//This Video struct will represent the Video model in the application. It will have 8 properties that will make up this Video. The videoID is the String id, The description will be an optional to allow the user to take a video without writing a description. The dateTaken is the date the video was taken. The fileName is the String file, the videoDuration is the length of the video represented as a CMTime object. The videoURL is the URL of the video. The userID is the id of the user associated with the Video and the longerVideoURL of the video. The longerVideoURL, if it exists, is the URL to a longer video of the VideoURL. This class also Implements the equable method to conform to the Equatable protocol and it Will compare if the video on the left-handside is equal to the video on the right-hand side
//  Video.swift
//  GYBITG
//
//  Created by juanita aguilar on 4/25/19.
//

import Foundation
import AVFoundation
import UIKit

class Video: Equatable {
    
    let videoID: String
    var description: String?
    let dateTaken: Date
    let fileName: String
    let videoDuration: CMTime
    let videoURL: URL
    let userID: String
    var longerVideoURL: URL?
    var thumbnail: UIImage?
    
    init(videoID: String, description: String? = nil, dateTaken: Date, fileName: String, videoDuration: CMTime, videoURL: URL, userID: String, longerVideoURL: URL? = nil, thumbnail: UIImage?){
        self.videoID = videoID
        self.description = description
        self.dateTaken = dateTaken
        self.fileName = fileName
        self.videoDuration = videoDuration
        self.videoURL = videoURL
        self.userID = userID
        self.longerVideoURL = longerVideoURL
        self.thumbnail = thumbnail
    }
    
    //Implementing the equable method to conform to the Equatable protocol
    //purpose: Will compare if the video on the left-handside is equal to the video on the right-hand side
    // to define what makes a video equal to another
    //precondition: none
    //postcondion: Will return true if the video on the lhs is equal to the one on the rhs, false if not
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.videoID == rhs.videoID &&
            lhs.description == rhs.description &&
            lhs.dateTaken == rhs.dateTaken &&
            lhs.fileName == rhs.fileName &&
            lhs.videoDuration == rhs.videoDuration &&
            lhs.videoURL == rhs.videoURL &&
            lhs.userID == rhs.userID &&
            lhs.longerVideoURL == rhs.longerVideoURL &&
            lhs.thumbnail == rhs.thumbnail
    }
    
}

