// This class will conform to the VideoRepositoryProtocol and implement the methods. It will have an array of videos. WIll get the all of the videos in the array of videos. Will return the video with the videoID passed in. Will insert the video passed in to the array. Will update the video with the videoID with the description passed in. Will delete the video passed in. Will delete all of the videos in the videos array.
//  VideoRepository.swift
//  GYBITG
//
//  Created by juanita aguilar on 5/9/19.
//

import Foundation

//The protocol for the VideoView
protocol VideoRepositoryProtocol{
    //to store all videos
    var videos: [Video] {get}
    func getAllVideos() -> [Video]
    func getVideo(videoID: String) -> Video?
    func addVideo(videoToAdd: Video) -> String
    func updateVideo(videoToUpdateID: String, description: String?, longerVideoURL: URL?) -> String?
    func deleteVideo(videoToDeleteID: String) -> String?
    func deleteAllVideos()
    
}

class VideoRepository: VideoRepositoryProtocol{
   
    internal var videos = [Video]()
    
    func getAllVideos() -> [Video] {
        return videos
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
    func updateVideo(videoToUpdateID: String, description: String?, longerVideoURL: URL?) -> String? {
        
        let video = getVideo(videoID: videoToUpdateID)
        if video != nil{
            if description != nil{
             video!.description = description!
            }
            if longerVideoURL != nil{
                video!.longerVideoURL = longerVideoURL!
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
    
}
