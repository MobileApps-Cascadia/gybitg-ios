
// This class will conform to the VideoRepositoryProtocol and implement the methods. It will have an array of videos. WIll get the all of the videos in the array of videos. Will return the video with the videoID passed in. Will insert the video passed in to the array. Will update the video with the videoID with the description passed in. Will delete the video passed in. Will delete all of the videos in the videos array.
//  VideoRepository.swift
//  GYBITG
//
//  Created by juanita aguilar on 5/9/19.
//

import AVFoundation
import CoreMedia
import UIKit
import MobileCoreServices

class MockVideoRepository: VideoRepositoryProtocol{
    
    internal var videos = [Video]()
    
    func getAllVideos() -> [Video] {
        return videos
    }
    
    //Purpose: to Create a Video object from the URL of the parameter
    //Precondition:
    //Postcondition:
    func createVideo(videoURL: URL) -> Video{

        let asset = getAVAsset(videoUrl: videoURL)
        let date: Date =  asset.creationDate?.dateValue ?? Date()
        let video = Video(videoID: "\(date)", dateTaken: date, fileName: videoURL.path, videoDuration: asset.duration, videoURL: videoURL, userID: getIPAddressForCellOrWireless()!)
        return video
    }
    
    //converts the url into a AvAsset
    func getAVAsset(videoUrl: URL)-> AVAsset{
        
        let asset = AVURLAsset(url: videoUrl, options: nil)
            print("THis is the duration of the video: \(asset.duration)")
            
            return asset
   }
    
    
    func getIPAddressForCellOrWireless()-> String? {
        
        let WIFI_IF : [String] = ["en0"]
        let KNOWN_WIRED_IFS : [String] = ["en2", "en3", "en4"]
        let KNOWN_CELL_IFS : [String] = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        
        var addresses : [String : String] = ["wireless":"",
                                             "wired":"",
                                             "cell":""]
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    if let name: String = String(cString: (interface?.ifa_name)!), (WIFI_IF.contains(name) || KNOWN_WIRED_IFS.contains(name) || KNOWN_CELL_IFS.contains(name)) {
                        
                        // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        if WIFI_IF.contains(name){
                            addresses["wireless"] =  address
                        }else if KNOWN_WIRED_IFS.contains(name){
                            addresses["wired"] =  address
                        }else if KNOWN_CELL_IFS.contains(name){
                            addresses["cell"] =  address
                        }
                    }
                    
                }
            }
        }
        freeifaddrs(ifaddr)
        
        var ipAddressString : String?
        let wirelessString = addresses["wireless"]
        let wiredString = addresses["wired"]
        let cellString = addresses["cell"]
        if let wirelessString = wirelessString, wirelessString.count > 0{
            ipAddressString = wirelessString
        }else if let wiredString = wiredString, wiredString.count > 0{
            ipAddressString = wiredString
        }else if let cellString = cellString, cellString.count > 0{
            ipAddressString = cellString
        }
        return ipAddressString
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
