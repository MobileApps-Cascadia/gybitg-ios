// This class will conform to the VideoRepositoryProtocol and implement the methods. It will have an array of videos. WIll get the all of the videos in the array of videos. Will create a Video object from the URL of the parameter. Will return the video with the videoID passed in. Will insert the video passed in to the array. Will update the video with the videoID with the description, longerVideoURL or image passed in. Will delete the video passed in. Will delete all of the videos in the videos array.
//Will have a fetch method to send a request using Alamofire, with an id to get the youtube video through the api and the youTube video will be uploaded and saved to the repo, with the videoId, thumbnail, date published, duration and the title will be used for the description in the tableView. Will have a method to convert the minutes and seconds of the string passed in into minutes into a timeinterval and add the seconds.

//  VideoRepository.swift
//  GYBITG
//
//  Created by juanita aguilar on 5/9/19.
//

import AVFoundation
import Photos
import UIKit
import MobileCoreServices
import CoreMedia
import Alamofire

//Delegate to send the requested video to the GalleryVC
protocol VideoRepoDelegate: class {
    func didReceiveData(_ data: Video?)
}

class VideoRepository: VideoRepositoryProtocol{
    
    
     weak var delegate: VideoRepoDelegate?
    
    //Key for the youtube api
    let apiKey = "AIzaSyAYJAckWf6wC0YF23QobOIXnNXNL3ZvwOU"
    //the YOUTUBE api endpoint
    var path: String = "https://www.googleapis.com/youtube/v3/videos"
    
    
    func type() -> String {
    return "videoRepo"
    }
        
    internal var videos = [Video]()
    
     func getAllVideos() -> [Video] {
        return videos
    }
    
    
    //Purpose: To create a Video object from the URL of the parameter and properties set
    //Precondition: a URL of a video exists, a valid userID is passed
    //Postcondition: A Video will be created and returned
    func createVideo(userID: String, videoURL: URL, isYouTubeVideo: Bool) -> Video{
        
        let asset = AVURLAsset(url: videoURL, options: nil)
        let date: Date =  asset.creationDate?.dateValue ?? Date()
        
        //Since I have changed the Video model to use something that is codeable, have to put the right object in so need to convert asset.duration into a Duration object that the Video model uses. Replaced videoDuration:assest.duration that returns a CMTime object with
     
        let  duration = Duration(withCMTime: asset.duration)
        let video = Video(videoID: "\(date)", dateTaken: date, videoFileName: videoURL.path, videoDuration: duration, videoURL: videoURL, userID: userID, thumbnail: nil, isYouTubeVideo: isYouTubeVideo)
        return video
    }
    
    //purpose: Will return the video with the videoID passed in
    //precondition: the video is in the array
    //postcondion: The Video with the videoID passed in will be returned or nil if not in the array
    func getVideo(videoID: String) -> Video? {
        
        for video in videos {
            if(video.videoID == videoID){
                return video
            }
        }
        return nil
    }
    
    //purpose: Will insert the video passed in
    //precondition: Video is not already in the array
    //postcondion: The Video passed in will be added to the videos array and the videoID returned
    func addVideo(videoToAdd: Video) -> String {
        if(!videos.contains(videoToAdd)){
            videos.append(videoToAdd)
        }
        return videoToAdd.videoID
    }
    
    //purpose: Will update the video with the videoID with the description passed in
    //precondition: The videoID passed in exists in the array
    //postcondion: The VideoID passed in will be updated and the videoID returned or nil if not in the array
    func updateVideo(videoToUpdateID: String, description: String?, longerVideoURL: URL?, thumbnail: UIImage?) -> String? {
 
        let video = getVideo(videoID: videoToUpdateID)
        if video != nil{
            if description != nil{
             video!.description = description!
            }
            if longerVideoURL != nil{
                video!.longerVideoURL = longerVideoURL!
            }
            
            //Need to convert the thumnail into an Image object to meet the requirements of the codable Video model.  Replace video!.thumbnail = thumbnail with  video!.thumbnail = Image(withImage: thumbnail!)
            if thumbnail != nil{
                video!.thumbnail = Image(withImage: thumbnail!)
            }
            return video?.videoID
        }
             return nil
    }
 
    
    //purpose: Will delete the video passed in
    //precondition: Video is not nil
    //postcondion: The Video passed in will be deleted in the videos array and its videoID returned or nill if nil
    func deleteVideo(videoToDeleteID: String) -> String? {
        let video = getVideo(videoID: videoToDeleteID)
        if video != nil{
            videos.remove(at:  (videos.firstIndex(of: video!)!))
            return video?.videoID
        }
        
        return nil
    }
   
    //purpose: Will delete all of the videos in the videos array
    //precondition: none
    //postcondion: All of the videos in the videos array will be deleted
    func deleteAllVideos() {
        videos.removeAll()
    }
    
        
    //Use Alamofire to get the videos asynchonously
    //purpose: to send a request using Alamofire, with an id to get the youtube video through the api and return the videoId
    //precondions: @param id @param videoUrl
    //postconditions: The youTube video will be uploaded and saved to the repo, with the videoId, thumbnail, date published, duration and the title will be used for the description in the tableView
    func fetch(withId id: String?, videoUrl: String?, userID: String?) -> String {
     
       if let videoUrlStr = videoUrl, let vidId = id, let userId = userID{
            let videoURL = URL(fileURLWithPath: videoUrlStr)
              let videoId = vidId
        
                AF.request(self.path, method: .get, parameters: ["part":"snippet,contentDetails","id": videoId,"key": self.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON{(response)->Void in
                    
                    let videoTest = Video(videoID: videoId, dateTaken: Date(), videoFileName: videoUrl!, videoDuration: Duration(), videoURL: videoURL, userID: userId, thumbnail: nil, isYouTubeVideo: true)
                    
                  var videoDuration = Duration()
                  var videoTitle = String()
          // print("RESPONS IS: \(response)")
                 //   print("THE RESULTING VALUES ARE : \(String(describing: response.value))")
            if let JSON = response.value as? [String:Any], let videos = JSON["items"] as? [[String:Any]] {
                  for video in videos{
                    var videoDatePublished: Date
                //the values in items are returned as an array so loop through the array
                    if let contentDetails = video["contentDetails"] {
                     //make the contentDetails a dictionary and loop through it to find the duration of the video
                        for (kind, details) in contentDetails as! NSDictionary{
                            let kindStr = kind as! String
                                if kindStr == "duration"{
                           //Now grab the details that is the duration value
                            //convert the duration into a string
                                    let durationStr = details as! String
                                    // and parse the string to get the minutes and seconds
                                    let timeInterval = self.convertMinutesSecondsToTimeInterval(durationStr: durationStr)
                                       //now convert the timeInterval into a CMTime
                                    let durationCMTime = CMTime(seconds:(timeInterval), preferredTimescale: 1)
                        //Convert the videoDuration into a Duration for the video model
                                     videoDuration = Duration(withCMTime: durationCMTime)
                                }
                            }
                       }
                        if let snip = video["snippet"]{
                           for (kind, snipDetails) in snip as! NSDictionary{
                            let kindStr = kind as! String
                    
                            if kindStr == "localized"{
                               for (kind, localDetails) in snipDetails as! NSDictionary{
                                let kindStr = kind as! String
                                   if kindStr == "title"{
                                       videoTitle = localDetails as! String
                                 _ =   self.updateVideo(videoToUpdateID: id!, description: videoTitle, longerVideoURL: videoTest.longerVideoURL, thumbnail: nil)
                                   }
                                }
                            }
                            if kindStr == "publishedAt"{
                                 let publishedStr = snipDetails as! String
                                 let dateFormatter = DateFormatter()
                                 let vidDPublished  = dateFormatter.date(fromSwapiString: publishedStr)
                                 videoDatePublished = vidDPublished!
                                
                                let video = Video(videoID: id!, description: videoTest.description, dateTaken: videoDatePublished, videoFileName: videoTest.videoFileName, videoDuration: videoDuration, videoURL: videoURL, userID: id!, longerVideoURL:videoTest.longerVideoURL, thumbnail: videoTest.thumbnail, isYouTubeVideo: videoTest.isYouTubeVideo)
                                 
                                if let delegate = self.delegate{
                                    delegate.didReceiveData(video)
                                }
                               }
                         if kindStr == "thumbnails"{
                            for (kind, snipDetail) in snipDetails as! NSDictionary{
                                let thumbStr = kind as! String
                                if thumbStr == "default"{
                                   for (kind, snipDetails) in snipDetail as! NSDictionary{
                                        let defaultStr = kind as! String
                                        if defaultStr == "url"{
                                  
                                            let videoUrlString = snipDetails as! String
                                            let thumbUrl = URL(string: videoUrlString)
                                        do{
                                            if let thumbnailUrl = thumbUrl, let data = try? Data(contentsOf: thumbnailUrl){
                                                if let thumbUIImage = UIImage(data: data){
                                                    let   uIImageToConvert = Image(withImage: thumbUIImage)
                                                    videoTest.thumbnail = uIImageToConvert
                                                }
                                              }
                                              else{//default image
                                                let uIImageToConvert = Image(withImage:  UIImage(named: "ball-basketball-basketball-court-1752757(1)")!)
                                                videoTest.thumbnail = uIImageToConvert
                                              }
                                            }
                                          }
                                       }
                                   }
                                }
                             }
                            
                          }
                       }
                   }
              }
          }
      }
    return id ?? "no id valid"
      
    }
    
    //Purpose: to convert the minutes and seconds of the string passed in into minutes into a timeinterval and add the secondes
    func convertMinutesSecondsToTimeInterval(durationStr: String)->TimeInterval{
    //parse the string to get the minutes and seconds
            var minutes = ""
            var ismin = true
            var seconds = ""
            for s in durationStr{
                if s.isNumber && ismin{
                    minutes += String (s)
                }
                if s == "M"{
                    ismin = false
                }
                if s.isNumber && !(ismin){
                    seconds += String (s)
                }
            }
        var timeInterval: TimeInterval = (Double(minutes)! * 60.0)
        if seconds != ""{
           timeInterval += (Double(seconds))!
        }
    
        return timeInterval
        }
  
    
}


 
 
 
 
 
