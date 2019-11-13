// This class will conform to the VideoRepositoryProtocol and implement the methods. It will have an array of videos. WIll get the all of the videos in the array of videos. Will create a Video object from the URL of the parameter. Will return the video with the videoID passed in. Will insert the video passed in to the array. Will update the video with the videoID with the description, longerVideoURL or image passed in. Will delete the video passed in. Will delete all of the videos in the videos array.
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
import youtube_ios_player_helper_swift
import Alamofire

//Delegate to send the requested video to the GalleryVC
protocol VideoRepoDelegate: class {
   func didReceiveData(_ data: Video?)
}


class VideoRepository: VideoRepositoryProtocol{
    //A has-a relationship for the delegate
    //Now in fetch get the video requested and send it in the didRecieveData fx
     weak var delegate: VideoRepoDelegate?
    
    //NEED a key for the youtube api
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
    func createVideo(userID: String, videoURL: URL) -> Video{
        
        let asset = AVURLAsset(url: videoURL, options: nil)
        
        let date: Date =  asset.creationDate?.dateValue ?? Date()
        
        //Since I have changed the Video model to use something that is codeable, have to put the right object in so need to convert asset.duration into a Duration object that the Video model uses. Replace videoDuration:assest.duration that returns a CMTime object with
         
      
       //Duration duration = duration(asset.duration)
     
        let  duration = Duration(withCMTime: asset.duration)
        let video = Video(videoID: "\(date)", dateTaken: date, videoFileName: videoURL.path, videoDuration: duration, videoURL: videoURL, userID: userID, thumbnail: nil)
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
    
        
    //Use Alamofire to get the videos asynchonously
    //need to get the Title, description, thumbnail, date published, duration, id, 
    //purpose: to send a request with an id to get the youtube video through the api
    //precondions: @param id
    //postconditions:
   func fetch(withId id: String?, videoUrl: String?) -> String {
       
         var hasThumbnail = false
    
        var videoId: String
        let videoURL = URL(fileURLWithPath: videoUrl!)
    
         if videoUrl != nil{
            if id != nil{
               videoId = id!
                AF.request(self.path, method: .get, parameters: ["part":"snippet,contentDetails","id": videoId,"key": self.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON{(response)->Void in
            
            var videoTest = Video(videoID: videoId, dateTaken: Date(), videoFileName: videoUrl!, videoDuration: Duration(), videoURL: videoURL, userID: "", thumbnail: nil)
            
                 var videoDuration = Duration()
                 var videoDescription = String()

            
          // print("RESPONS IS: \(response)")
                    print("THE RESULTING VALUES ARE : \(String(describing: response.value))")
            if let JSON = response.value as? [String:Any]{
               if let videos = JSON["items"] as? [[String:Any]] {
                  for video in videos{
                   
                    var videoDatePublished: Date
                     
                //the values in items are returned as an array so loop through the array
                    if let contentDetails = video["contentDetails"] {
                      
                     //make the contentDetails a dictionary and loop through it to find the duration of the video
                        for (kind, details) in contentDetails as! NSDictionary{
                       
                            let kindStr = kind as! String
                            //if the key is duration, go
                                if kindStr == "duration"{
                                  //  print("Duration is: \(kindStr) and detail is \(details)")
                           //Now grab the details that is the duration value
                            //convert the duration into a string
                                    let durationStr = details as! String
                                    // and parse the string to get the minutes and seconds
                                    let timeInterval = self.convertMinutesSecondsToTimeInterval(durationStr: durationStr)
                                       //now convert the timeInterval into a CMTime
                                    let durationCMTime = CMTime(seconds:(timeInterval), preferredTimescale: 1)
                                
                                    //now convert the timeInterval into a CMTime
                        //Convert the videoDuration into a Duration for the video model
                                     videoDuration = Duration(withCMTime: durationCMTime)
                                }
                            }
                       }
                        if let snip = video["snippet"]{
                          
                           for (kind, snipDetails) in snip as! NSDictionary{
                        
                              let kindStr = kind as! String
                              if kindStr == "description"{
                                 print("Description is: \(kindStr) and detail is \(snipDetails)")
                        //Now grab the snipDetails that is the description value
                             
                                let descriptionStr = snipDetails as! String
                                videoDescription += descriptionStr
                                _ =  self.updateVideo(videoToUpdateID: id!, description: videoDescription, longerVideoURL: videoTest.longerVideoURL, thumbnail: nil)
                              }
                //if you need the video Title put code here//   if kindStr == "localized"{
                            
                              if kindStr == "publishedAt"{
                               //  print("Date video published at is: \(kindStr) and detail is \(snipDetails)")
                //Now grab the snipDetails that is the Date the video was publish at value
                                 let publishedStr = snipDetails as! String
                                
                                 let dateFormatter = DateFormatter()
                                 let vidDPublished  = dateFormatter.date(fromSwapiString: publishedStr)
                                
                                 videoDatePublished = vidDPublished!
                                
                                let video = Video(videoID: id!, description: videoTest.description, dateTaken: videoDatePublished, videoFileName: videoTest.videoFileName, videoDuration: videoDuration, videoURL: videoURL, userID: id!, longerVideoURL:videoTest.longerVideoURL, thumbnail: videoTest.thumbnail)
                                 
                                //Add this to fetch but put the Created new video in the param to send to the Vc
                                if self.delegate != nil {
                                  self.delegate?.didReceiveData(video)
                                }
                               }
                         if kindStr == "thumbnails"{
                            print("video thumbnails at is: \(kindStr) and detail is \(snipDetails)")
                            for (kind, snipDetail) in snipDetails as! NSDictionary{
                                let thumbStr = kind as! String
                                if thumbStr == "default"{
                                   for (kind, snipDetails) in snipDetail as! NSDictionary{
                                     print("video default at is: \(kind) and url detail is \(snipDetails)")
                                        let defaultStr = kind as! String
                                        if defaultStr == "url"{
                                             print("video thumbnails at is: \(kind) and detail is \(snipDetails)")
                                    //get the url from the string
                                            let videoUrlString = snipDetails as! String
                                            let thumbUrl = URL(fileURLWithPath: videoUrlString)
                                            print("the videoUrlString is \(snipDetails)")
                                               
                                        do{
                                             let data = try? Data(contentsOf: thumbUrl)
                                             if data != nil{
                                           // let data = try Data?(contentsOf: thumbUrl)
                                           // var thumbUIImage = UIImage(data: data)

                                           //self.updateVideo(videoToUpdateID: id!, description: videoTest.description, longerVideoURL: nil, thumbnail: thumbUIImage)
                                            
                                                 hasThumbnail = true
                                              }
                                              else{
                                                let uIImageToConvert = Image(withImage:  UIImage(named: "ball-basketball-basketball-court-1752757(1)")!)
                                                videoTest.thumbnail = uIImageToConvert
                                              }
                                           }
                                          }
                                        }
                                      print("hasThumbnail is : \(hasThumbnail)")
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
/*extension DateFormatter {
  func date(fromSwapiString dateString: String) -> Date? {
    // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
    self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
    self.timeZone = TimeZone(abbreviation: "UTC")
    self.locale = Locale(identifier: "en_US_POSIX")
    return self.date(from: dateString)
  }
}*/



/*// Create your request
let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
    do {
        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject] {

            print("Response from YouTube: \(jsonResult)")
        }
    }
    catch {
        print("json error: \(error)")
    }

})

// Start the request
task.resume()*/

 
 
 
 
 
