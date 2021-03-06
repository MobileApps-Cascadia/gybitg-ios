//This Video struct will represent the Video model in the application. It will have 9 properties that will make up this Video. The videoID is the String id, The description will be an optional to allow the user to take a video without writing a description. The dateTaken is the date the video was taken or published if youtube video. The fileName is the String file, the videoDuration is the length of the video represented as a Duration object. The videoURL is the URL of the video. The userID is the id of the user associated with the Video and the longerVideoURL of the video. The longerVideoURL, if it exists, is the URL to a longer video of the VideoURL. The thumbnail of the video is a Image object. There is a struct Image, to make the UIImage codable because UIImage is not Codeable. There is a struct Duration, to make the duration of the video codable because CMTime is not CodeableThis class also Implements the equable method to conform to the Equatable protocol and it Will compare if the video on the left-handside is equal to the video on the right-hand side
//  Video.swift
//  GYBITG
//
//  Created by juanita aguilar on 4/25/19.
//

import Foundation
import AVFoundation
import UIKit


class Video: Equatable,Codable {
    
    let videoID: String
    var description: String?
    let dateTaken: Date
    var videoFileName: String
    let videoDuration: Duration
    let videoURL: URL
    let userID: String
    var longerVideoURL: URL?
    var thumbnail: Image?
    var isYouTubeVideo: Bool
    
    init(videoID: String, description: String? = nil, dateTaken: Date, videoFileName: String, videoDuration: Duration, videoURL: URL, userID: String, longerVideoURL: URL? = nil, thumbnail: Image?, isYouTubeVideo: Bool){
        self.videoID = videoID
        self.description = description
        self.dateTaken = dateTaken
        self.videoFileName = videoFileName
        self.videoDuration = videoDuration
        self.videoURL = videoURL
        self.userID = userID
        self.longerVideoURL = longerVideoURL
        self.thumbnail = thumbnail
        self.isYouTubeVideo = isYouTubeVideo
    }
    
    //Implementing the equable method to conform to the Equatable protocol
    //purpose: Will compare if the video on the left-handside is equal to the video on the right-hand side
    // to define what makes a video equal to another
    //precondition: none
    //postcondion: Will return true if the video on the lhs is equal to the one on the rhs, false if not
    static func == (lhs: Video, rhs: Video) -> Bool {
        return lhs.videoID == rhs.videoID
            && lhs.dateTaken == rhs.dateTaken &&
            lhs.videoFileName == rhs.videoFileName &&
            lhs.videoDuration == rhs.videoDuration &&
            lhs.videoURL == rhs.videoURL &&
            lhs.userID == rhs.userID
    }
   
  /*  static func createVideo() -> Video {
        
         //var videoTest = Video(videoID: videoId, dateTaken: Date(), videoFileName: videoUrl!, videoDuration: Duration(), videoURL: videoURL, userID: "", thumbnail: nil)
          return Video(videoID: "", description: "", dateTaken: <#T##Date#>, videoFileName: <#T##String#>, videoDuration: <#T##Duration#>, videoURL: <#T##URL#>, userID: <#T##String#>, longerVideoURL: <#T##URL?#>, thumbnail: <#T##Image?#>)
      }*/
}
//Purpose: To make the UIImage codable because UIImage is not Codeable
//1. Create an imageData property of type Data. Have to do this because can only use a codable type for the property.
//2. Create a custom initializer, to initialize the struct with a UIImage. Then use that UIImage and call the pngData() method. The pngData()method has a return type of Data?, this works perfectly for this situation.
//3. Now the issue is that we want to get a UIImage from this struct, we don’t always want to convert it ourselves. For this create a get method that will return an optional UIImage. This is required as the argument type is Data, Data could mean anything, it could even be text, so initializing a UIImage with data return an optional UIImage. Either return nil or the image.
//4. Change the UIImage in the Video Model to return Image, the struct that we created that Conforms to Codable
struct Image: Codable, Equatable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}

//Purpose: To make the duration of the video codable because CMTime is not Codeable
//1. Create an durationFloat property of type Float64. Have to do this because can only use a codable type for the property.
//2. Create a custom initializer, to initialize the struct with a CMTime. Then use that CMTime and call the CMTimeGetSeconds(_ time: CMTime) -> Float64 method. The CMTimeGetSeconds(_ time: CMTime) -> Float64method has a return type of Float64, this works perfectly for this situation.

//3. Now the issue is that we want to get a CMTime from this struct, we don’t always want to convert it ourselves. For this create a get method that will return an optional CMTime. Either return nil or the CMTime.
//4. Change the CMTime in the Video Model to return Duration, the struct that we created that Conforms to Codable

//Makes a CMTime from a Float64 number of seconds, and a preferred timescale.
struct Duration: Codable, Equatable{
  
    let durationFloat: Float64
    
    init(withCMTime duration: CMTime) {
        
        self.durationFloat = CMTimeGetSeconds(duration)
    }
    
    init(){
        self.durationFloat = 0.0
    }
    
    func getDuration() -> CMTime? {
       
        let duration = CMTimeMakeWithSeconds(self.durationFloat, preferredTimescale: 1)
          
          return duration
      }
}
