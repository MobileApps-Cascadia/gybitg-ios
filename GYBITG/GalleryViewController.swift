//
//  GalleryViewController.swift
//  GYBITG
//
//  Created by Student Account on 5/7/19.
//
import AVFoundation
import Photos
import UIKit
import MobileCoreServices

class GalleryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let videoFileName = "/video.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //setting camera button to take a video
    //will first chect to see if a camera is available
    //will set the array to contain movies as the mediaTypes
    //Purpose: To take a video for the Gallery if the camera is available
    //Precondition: needs the privacy - camera usage in the info.plist
    //Postcondition: A video will be taken or selected from the photos library
    @IBAction func takeVideo(_ sender: UIButton) {
        
            let controller = UIImagePickerController()
            
            //Check if project runs on a device with camera available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                //Present UIImagePickerController to take video
                controller.sourceType = .camera
                controller.mediaTypes = [kUTTypeMovie as String]
                controller.delegate = self
                
                present(controller, animated: true, completion: nil)
            }
            else {
                
                viewLibrary(controller)
            }
        }
        
    //Purpose: To have the app access the Photo Library if the camera is not available
    //Precondition: Needs the privacy - photo library usage in the info.plist
    //Postcondition: The photo library is presented
        func viewLibrary(_ controller: UIImagePickerController) {
            // Display Photo Library
            controller.sourceType = UIImagePickerController.SourceType.photoLibrary
            controller.mediaTypes = [kUTTypeMovie as String]
            controller.delegate = self
            
            present(controller, animated: true, completion: nil)
        }
    
    
    //Purpose: To get the selected video and Save video to the main photo album and puts that image on the screen in the image view
    //Precondtion: Needs the privacy - photo libraryadditon in the info.plist
    //Postcondtion: The selected video will be added to the photos directory, turned into a thumbnail and put on screen in the Gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            //calls the videoSaved fx
            let selectorToCall = #selector(self.videoSaved(_:didFinishSavingWithError:context:))
            
            // 2
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
            
            let videoThumbnail = turnVideoToThumbnail(selectedVideo)
            if videoThumbnail != nil{
                
                //put that image on the screen in the image view
                //need the imageView
               // imageView.image = videoThumbnail
            }
        }
        // 3
        picker.dismiss(animated: true)
    }
    
    //Saves a video to the photos library
    //also needs the privacy - photo libraryadditon
    @objc func videoSaved(_ video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutableRawPointer){
        if let theError = error {
            print("error saving the video = \(theError)")
        } else {
            DispatchQueue.main.async(execute: { () -> Void in
            })
        }
    }
    
    //Purpose: To turn the video into a thumbnail
    //Precondition: There is a video
    //Postcondtion: A thumbnail will be created and returned from the video or nil if video does not exist
    func turnVideoToThumbnail(_ videoURL: URL) -> UIImage? {
        
        
        do {
            let asset = AVURLAsset(url: videoURL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
        
    }
    
}
