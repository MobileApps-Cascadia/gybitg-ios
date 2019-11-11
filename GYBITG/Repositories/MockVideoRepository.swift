
// This class will conform to the VideoRepositoryProtocol and implement the methods. It will have an array of videos. WIll get the all of the videos in the array of videos. Will create a Video object from the URL of the parameter Will return the video with the videoID passed in. Will insert the video passed in to the array. Will update the video with the videoID with the description, longerVideoURL image passed in. Will delete the video passed in. Will delete all of the videos in the videos array.
//  VideoRepository.swift
//  GYBITG
//
//  Created by juanita aguilar on 5/9/19.
//

import AVFoundation
import CoreMedia
import UIKit
import MobileCoreServices
import Alamofire

class MockVideoRepository: VideoRepositoryProtocol{
    var delegate: VideoRepoDelegate?
    
   
    
    //TODO will be the YOUTUBE api endpoint
    var path: String = ""
      let apiKey = "AIzaSyAbwfyC36pq1WoaGOkdx7m8cLMh8kMQRGE"
    
    func type() -> String {
    return "videoRepo"
    }
    
    internal var videos = [Video]()
    
    func getAllVideos() -> [Video] {
        return videos
    }
    
    //Purpose: To create a Video object from the URL of the parameter
    //Precondition: a URL of a video exists,
    //Postcondition: A Video will be created and returned and properties set. Will check if there is a date for the asset and if not, the date will be set to now
    func createVideo(userID: String, videoURL: URL) -> Video {
        
        let asset = getAVAsset(videoUrl: videoURL)
        let date: Date =  asset.creationDate?.dateValue ?? Date()
        
        let videoDescription = "Description of Video"
        
        //Since I have changed the Video model to use something that is codeable, have to put the right object in so need to convert asset.duration into a Duration object that the Video model uses. Replace videoDuration:assest.duration that returns a CMTime object with
                
            
        let  duration = Duration(withCMTime: asset.duration)
        let video = Video(videoID: "\(date)", description: videoDescription, dateTaken: date, videoFileName: videoURL.path, videoDuration: duration, videoURL: videoURL, userID: userID, thumbnail: nil)
        
        return video
    }
    
    //Purpose: converts the url into a AvAsset
    func getAVAsset(videoUrl: URL)-> AVAsset{
        let asset = AVURLAsset(url: videoUrl, options: nil)
            return asset
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
            //Need to convert the thumnail into an Image object to meet the requirements of the codable Video model.    video!.thumbnail = Image(withImage: thumbnail!)
            if thumbnail != nil{
                
                video!.thumbnail = Image(withImage: thumbnail!)
               // video!.thumbnail = thumbnail
                
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
    
    
  /*  func fetch(withId id: String?, withCompletion completion: @escaping (Video?) -> Void) {
       /*     let URLstring = path + "\(id)"
            if let url = URL.init(string: URLstring){
                let task = URLSession.shared.dataTask(with: url, completionHandler:
                {(data, response, error) in
                    if let user = try? JSONDecoder().decode(Video.self, from: data!){
                        completion (user)
                    }
                })
                task.resume()
            }*/
        }*/
  
    
    //Use Alamofire to get the videos asynchonously
       //need to get the Title, description, thumbnail, date published, duration, id,
       //purpose: to send a request with an id to get the youtube video through the api
       //precondions: @param id
       //postconditions:
       func fetch(withId id: String?, videoUrl: String?) -> String {
           
            //var YouTubeVideo:Video
           var videoTitle = ""
           var videoDescription = ""
           var videoDatePublished = Date()
           var videoId: String
           var videoDuration = Duration()
           var videoThumbnail:Image
           var videoURL = URL(fileURLWithPath: videoUrl!)
            if let vidURL = videoUrl{
              if let vidId = id{
          
              
                
                
                               
           AF.request("https://www.googleapis.com/youtube/v3/videos", method: .get, parameters: ["part":"snippet,contentDetails,statistics","id": "AKiiekaEHhI","key": self.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON{(response)->Void in
               
                       
               print("RESPONS IS: \(response)")
               print("THE RESULTING VALUES ARE : \(response.value)")
               if let JSON = response.value as? [String:Any]{
                  if let videos = JSON["items"] as? [[String:Any]] {
                     for video in videos{
                   //the values in items are returned as an array so loop through the array
                       if let contentDetails = video["contentDetails"] {
                          print("HHHHH \(String(describing: contentDetails))")
                           //prints out the value for every key
                         //need to look for duration
                        //make the contentDetails a dictionary and loop through it to find the duration of the video
                           for (kind, details) in contentDetails as! NSDictionary{
                           // print("kind: \(kind) Detail: \(details)")
                               let kindStr = kind as! String
                               //if the key is duration, go
                                   if kindStr == "duration"{
                                       print("Duration is: \(kindStr) and detail is \(details)")
                              //Now grab the details that is the duration value
                               //convert the duration into a string and parse the string to get the minutes and seconds
                                       let durationStr = details as! String
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
                                       print(minutes)
                                       print(seconds)
                           //convert the minutes into a timeinterval and add the secondes
                                       var timeInterval: TimeInterval = (Double(minutes)! * 60.0)
                                       timeInterval += (Double(seconds))!
                                       //now convert the timeInterval into a CMTime
                                       let durationCMTime = CMTime(seconds:(timeInterval), preferredTimescale: 1)
                                                   //Convert the videoDuration into a Duration for the video model
                                        videoDuration = Duration(withCMTime: durationCMTime)
                                         print("RESULT Conversion \(videoDuration)")
                                   }
                               }
                           }
                           if let snippet = video["snippet"]{
                              for (kind, snipDetails) in snippet as! NSDictionary{
                           //print("kind: \(kind) Detail: \(snipDetails)")
                                 let kindStr = kind as! String
                                 if kindStr == "description"{
                                    print("Description is: \(kindStr) and detail is \(snipDetails)")
                           //Now grab the snipDetails that is the description value
                                    videoDescription = snipDetails as! String
                                 }
                                 if kindStr == "localized"{
                                   for (kind, localDetails) in snipDetails as! NSDictionary{
                                       print("kind: \(kind) LocalDetails:  \(localDetails)")
                                       let kindStr = localDetails as! String
                                       if kindStr == "title"{
                                          print("The TITLE IS: \(kindStr)")
                                          videoTitle = localDetails as! String
                                       }
                                    }
                                 }
                                 if kindStr == "publishedAt"{
                                    print("Date video published at is: \(kindStr) and detail is \(snipDetails)")
                   //Now grab the snipDetails that is the Date the video was publish at value
                                    let publishedStr = snipDetails as! String
                                    print("THE Date published : \(publishedStr)")
                                    let dateFormatter = DateFormatter()
                                    if let  videoDatePublished = dateFormatter.date(fromSwapiString: publishedStr){
                                                       print(videoDatePublished)
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
          //  var video = Video(videoID: id!, description: videoDescription, dateTaken: videoDatePublished, fileName: videoTitle, videoDuration: videoDuration, videoURL: videoURL, userID: id!, longerVideoURL: nil, thumbnail: nil)
          
               return ""
       }
}
extension DateFormatter {
  func date(fromSwapiString dateString: String) -> Date? {
    // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
    self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    self.timeZone = TimeZone(abbreviation: "UTC")
    self.locale = Locale(identifier: "en_US_POSIX")
    return self.date(from: dateString)
  }
}
