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
    //This keyWorks AIzaSyAbwfyC36pq1WoaGOkdx7m8cLMh8kMQRGE
  let apiKey = "AIzaSyAYJAckWf6wC0YF23QobOIXnNXNL3ZvwOU" //"AIzaSyAbwfyC36pq1WoaGOkdx7m8cLMh8kMQRGE"//AIzaSyAYJAckWf6wC0YF23QobOIXnNXNL3ZvwOU"
    //TODO will be the YOUTUBE api endpoint
    var path: String = "https://www.googleapis.com/youtube/v3/videos" //"https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+statistics&id=AKiiekaEHhI&key="
    //nexzt line could replace? base url is endpoint
  //  private let baseURL = URL(string: "https://swapi.co/api/")!
       
      /*  init(withPath path:String){
              self.path = path
       }*/
    
    
    func getyoutubeApi(endPointURL: String, videoID: String, apiKey: String)-> URL?{
        
        if let youtubeApi = URL(string: "\(endPointURL)  ?part=contentDetails%2C+snippet%2C+statistics&id= \(videoID) &key= \(apiKey)") {
            print("This is the YOUTUBE API \(youtubeApi)")
            return youtubeApi
            
        }
        else{return nil }
    }

   // let url = NSURL(string: self.path /(apiKey))
    
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
        let video = Video(videoID: "\(date)", dateTaken: date, videoTitle: videoURL.path, videoDuration: duration, videoURL: videoURL, userID: userID, thumbnail: nil)
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
    
//'https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&id=
            
            // Set up your URL
          //  let youtubeApi = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+statistics&id=AKiiekaEHhI&key={YOUR_API_KEY}"
        
    //Use Alamofire to get the videos asynchonously
    //need to get the Title, description, thumbnail, date published, duration, id, 
    //purpose: to send a request with an id to get the youtube video through the api
    //precondions: @param id
    //postconditions:
   func fetch(withId id: String?, videoUrl: String?) -> String {
   
        var videoId: String
        let videoURL = URL(fileURLWithPath: videoUrl!)
    
         if videoUrl != nil{
            if id != nil{
            videoId = id!
        AF.request("https://www.googleapis.com/youtube/v3/videos", method: .get, parameters: ["part":"snippet,contentDetails,statistics","id": videoId,"key": self.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON{(response)->Void in
            
          var videoTest = Video(videoID: videoId, dateTaken: Date(), videoTitle: "", videoDuration: Duration(), videoURL: videoURL, userID: "", thumbnail: nil)
            //var videoDescription:
                  var videoDuration = Duration()
                  var videoTitle = "TEST"
                 var videoDescription = String()
                    
           print("RESPONS IS: \(response)")
           print("THE RESULTING VALUES ARE : \(response.value)")
            if let JSON = response.value as? [String:Any]{
               if let videos = JSON["items"] as? [[String:Any]] {
                  for video in videos{
                      var videoDatePublished:Date
                     
                //the values in items are returned as an array so loop through the array
                    if let contentDetails = video["contentDetails"] {
                         //prints out the value for every key
                       print("HHHHH \(String(describing: contentDetails))")
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
                                    if seconds != ""{
                                       timeInterval += (Double(seconds))!
                                    }
                                    //now convert the timeInterval into a CMTime
                                    let durationCMTime = CMTime(seconds:(timeInterval), preferredTimescale: 1)
                                                //Convert the videoDuration into a Duration for the video model
                                     videoDuration = Duration(withCMTime: durationCMTime)
                                      print("RESULT Conversion \(videoDuration)")
                                    
                                }
                            }
                       }
                        if let snip = video["snippet"]{
                          
                           for (kind, snipDetails) in snip as! NSDictionary{
                        
                        //print("kind: \(kind) Detail: \(snipDetails)")
                              let kindStr = kind as! String
                              if kindStr == "description"{
                                 print("Description is: \(kindStr) and detail is \(snipDetails)")
                        //Now grab the snipDetails that is the description value
                             
                                let descriptionStr = snipDetails as! String
                                videoDescription += descriptionStr
                               // videoTest.description = videoDescription
                                self.updateVideo(videoToUpdateID: id!, description: videoDescription, longerVideoURL: nil, thumbnail: nil)
                              }
                              if kindStr == "localized"{
                                for (kind, localDetails) in snipDetails as! NSDictionary{
                                    print("kind: \(kind) LocalDetails:  \(localDetails)")
                                    let kindStr = localDetails as! String
                                    if kindStr == "title"{
                                       print("The TITLE IS: \(kindStr)")
                                        if let videoTitleStr = localDetails as? String{
                                            videoTitle = videoTitleStr
                                        }
                                        else{
                                            videoTitle = ""
                                        }
                                        videoTest.videoTitle = videoTitle
                                    }
                                 }
                              }
                              if kindStr == "publishedAt"{
                                 print("Date video published at is: \(kindStr) and detail is \(snipDetails)")
                //Now grab the snipDetails that is the Date the video was publish at value
                                let publishedStr = snipDetails as! String
                                
                                 let dateFormatter = DateFormatter()
                                let vidDPublished  = dateFormatter.date(fromSwapiString: publishedStr)
                                videoDatePublished = vidDPublished!
                                        print(videoDatePublished)
                                let video = Video(videoID: id!, description: videoTest.description, dateTaken: videoDatePublished, videoTitle: videoTest.videoTitle!, videoDuration: videoDuration, videoURL: videoURL, userID: id!, longerVideoURL: nil, thumbnail: nil)
                                print(" Video Descripton ois: \(video.description)")
                                //Add this to fetch but put the Created new video in the param to send to the Vc
                                if self.delegate != nil{
                                   self.delegate?.didReceiveData(video)
                                }
                               }
                          /*  if kindStr == "thumbnails"{
                                print("Date video thumbnail at is: \(kindStr) and detail is \(snipDetails)")
                                         //Now grab the snipDetails that is the Date the video was publish at value
                                let thumbnailStr = snipDetails as! String
                                
                                
                            }*/
                            
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
    
    
  /*  func getVideo(withId id: String?, response: AF){
//This works
//AF.request("https://www.googleapis.com/youtube/v3/search?part=snippet&q=apple&key=AIzaSyAbwfyC36pq1WoaGOkdx7m8cLMh8kMQRGE").responseJSON { (response) in
        //AF.request("https://www.googleapis.com/youtube/v3/videos?part=contentDetails%2C+snippet%2C+statistics&id=AKiiekaEHhI&key=AIzaSyAbwfyC36pq1WoaGOkdx7m8cLMh8kMQRGE").responseJSON { (response) in
          //  print(response)
            AF.request("https://www.googleapis.com/youtube/v3/videos", method: .get, parameters: ["part":"snippet,contentDetails,statistics","id": "AKiiekaEHhI","key": self.apiKey], encoding: URLEncoding.default, headers: nil).responseJSON{(response)->Void in
                
                    var videoTitle: String
                    var videoDescription: String
                    var videoDatePublished: Date
                    var videoId: String
                    var videoDuration:Duration
                    var videoThumbnail:Image
                
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
      
        }*/
  
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

 
 
 
 
 
/*extension VideoRepository{
    var path: String
    
    convenience init(withPath path:String){
           self.path = path
    }
        
    func fetch(withId id: Int, withCompletion completion: @escaping (Video?) -> Void) {
        let URLstring = path + "\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let user = try? JSONDecoder().decode(User.self, from: data!){
                    completion (user)
                }
            })
            task.resume()
        }
    }
}*/
