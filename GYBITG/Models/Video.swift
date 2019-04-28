//This Video struct will represent the Video model in the application. It will have 7 properties that will make up this Video. The videoID is the String id, The description will be an optional to allow the user to take a video without writing a description. The dateTaken is the date the video was taken. The fileName is the String file, the videoDuration is the length of the video represented as a CMTime object. The videoURL is the URL of the video. The userID is the id of the user associated with the Video.
//  Video.swift
//  GYBITG
//
//  Created by juanita aguilar on 4/25/19.
//

import Foundation
import CoreVideo
import AVFoundation
import CoreMedia

struct Video {
    let videoID: String
    let description: String?
    let dateTaken: Date
    let fileName: String
    let videoDuration: CMTime
    let videoURL: URL
    let userID: String
    
    init(videoID: String, description: String? = nil, dateTaken: Date, fileName: String, videoDuration: CMTime, videoURL: URL, userID: String){
        self.videoID = videoID
        self.description = description
        self.dateTaken = dateTaken
        self.fileName = fileName
        self.videoDuration = videoDuration
        self.videoURL = videoURL
        self.userID = userID
    }
    
}
