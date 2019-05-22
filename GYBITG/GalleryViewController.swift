//This class will take a video for the Gallery if the camera is available. Will have the app access the Photo Library if the camera is not available.
//Will get the selected video and Save video to the main photo album.
//Will conform to the UINavigationControllerDelegate, UIImagePickerControllerDelegate.
//Will have a UIImageView to store a thumbnail of the video, a videoFileName,

//  GalleryViewController.swift
//  GYBITG
//
//  Created by Student Account on 5/7/19.
//
import AVFoundation
import Photos
import UIKit
import MobileCoreServices
import CoreMedia

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

class GalleryViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let mockVideoRepository = MockVideoRepository()
    
    let videoFileName = "/video.mp4"
    //to store a thumbnail of the video, a videoFileName,
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var thumbNail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets the title of the page in the UINavigationController
        navigationItem.title = "Gallery"
       // navigationItem.rightBarButtonItem?.image =
        //sets the right button of the camera to the camera system and calls the takeVideos method
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showAttachmentActionSheet))//#selector(takeVideos))
        //sets the rightBarButtonItem on the UINavigationController to the camera
        self.navigationItem.rightBarButtonItem  = camera


        // Do any additional setup after loading the view.
    }
    
    //Purpose: To take a video for the Gallery if the camera is available
    //Precondition: needs the privacy - camera usage in the info.plist, the user clicked the camera icon in the UINavigationController
    //Postcondition: A video will be taken or selected from the photos library
    @objc func takeVideos(){
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
    
    //Purpose: To get the selected video andf Save video to the main photo album and puts that image on the screen in the image view
    //Precondtion: Needs the privacy - photo libraryadditon in the info.plist
    //Postcondtion: The select/Users/juanitaaguilar/Documents/gybitg-ios/GYBITG/Info.plisted video will be added to the photos directory, turned into a thumbnail and put on screen in the Gallery
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
            
           let video =  mockVideoRepository.createVideo(videoURL: selectedVideo)
            let videoID = mockVideoRepository.addVideo(videoToAdd: video)
            print(videoID)
            let videoThumbnail = turnVideoToThumbnail(selectedVideo)
            
            if videoThumbnail != nil{
                
                //put that image on the screen in the image view
                //need the imageView
               // imageView.image = videoThumbnail
                thumbNail.image = videoThumbnail
                
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
            print("THis is the duration of the video: \(asset.duration)")
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
    
   // func addVideotoRepo(videoURL: URL){
     //   var video = Video(videoID: "", dateTaken: <#T##Date#>, fileName: <#T##String#>, videoDuration: <#T##CMTime#>, videoURL: <#T##URL#>, userID: //<#T##String#>)
   // }
    
    //Purpose: To set the text of the text fields to the corresponding item properties when the view is loaded
    //Precondition: Needs a UINavigationController to call this function when its about to swap views
    //Postcondition: The text of the text fields to the corresponding item properties will be set to the values in the function
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //nameField.text = item.name
       // SerialNumberField.text = item.serialNumber
        //ValueField.text = "\(item.valueInDollars)"
        // DateLabel.text = "\(item.dateCreated)"
        //use the date and number formatters created above to show content
      
       // DateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    //Ch14 pg 246 When the UINavigationController is about to swap views, it calls 2 Fx
    //1. viewWillDissaperar and 2. viewWillAppear
    //The VC that is about to be popped off the stack will have its viewWillDisappera and the Vc that is pushed on
    // Will have viewWillApper called on it
    //This will allow the values in the items viewTable to be updated when user taps Back button
    //now go to ItemsVC and override the viewWillDisappear
    //ch14 pg 251- now go to down to viewWillDisappear to implement that the keyboard will go away when the user pushes backbutton
    //Purpose: To save changes to item to allow the values in the items viewTable to be updated when user taps Back button
    //Precondition: Needs a UINavigationController to call this function when its about to swap views
    //Postcondition: This will allow the values in the items viewTable to be updated when user taps Back button
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //clear first responder to dismiss keyboard pg251
        view.endEditing(true)
        
        //save changes to item
        //item.name = nameField.text ?? ""
        //item.serialNumber = SerialNumberField.text
        
        //if let valueText = ValueField.text,
         //   let value = numberFormatter.number(from: valueText){
        //    item.valueInDollars = value.intValue
       // }else{
           // item.valueInDollars = 0
       // }
        
        
    }
    
    //Purpose: To show the user an actionsheet with options to choose from
    //Precondition: The User clicks the icon
    //Postcondtion: Will present the user with an alertController with options to choose from
    @objc func showAttachmentActionSheet() {
    
       let ac = UIAlertController(title: "Edit", message: "Choose Option", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.takeVideos()
            //pg 206
            // .self.itemStore.removeItem(item)
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        ac.addAction(cameraAction)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        
       /** let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            //pg 206
           // .self.itemStore.removeItem(item)
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
        
        ac.addAction(deleteAction)*/
        
        present(ac, animated: true, completion: nil)
    }
}
