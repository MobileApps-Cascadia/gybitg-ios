//This class will take a video for the Gallery if the camera is available. Will have the app access the Photo Library if the camera is not available or if user selects video library from the actionsheet choices.
//Will get the selected video and Save video to the main photo album.
//Will conform to the UINavigationControllerDelegate, UIImagePickerControllerDelegate.
//Will have a UIImageView to store a thumbnail of the video, a videoFileName,
//Will convert the Date in the specified format "MMM dd,yyyy" - May 29,2019. Will convert the time to CMTime print the duration. Will Return an int for the number of rows in the table a row for each item. Will fill the tableView with the items in the repository array of Videos.
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
    func createVideo(userID: String, videoURL: URL) -> Video
    func getAllVideos() -> [Video]
    func getVideo(videoID: String) -> Video?
    func addVideo(videoToAdd: Video) -> String
    func updateVideo(videoToUpdateID: String, description: String?, longerVideoURL: URL?, thumbnail: UIImage?) -> String?
    func deleteVideo(videoToDeleteID: String) -> String?
    func deleteAllVideos()
    
}

class GalleryViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var videoRepository = MockVideoRepository()
    
    let videoFileName = "/video.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          tableView.reloadData()
        //Sets the title of the page in the UINavigationController
       // navigationItem.title = "Gallery"
       // navigationItem.rightBarButtonItem?.image =
        //sets the right button of the camera to the camera system and calls the takeVideos method
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAttachmentActionSheet))//#selector(takeVideos))
        //sets the rightBarButtonItem on the UINavigationController to the camera
        self.navigationItem.rightBarButtonItem? = add

        //Dynamic cell height pg 216
        tableView.rowHeight = 150//UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
        
    }
    
    //Purpose: To show the user an actionsheet with options to choose from
    //Precondition: The User clicks the icon
    //Postcondtion: Will present the user with an alertController with options to choose from
    @objc func showAttachmentActionSheet() {
        
        //let ac = UIAlertController(title: "Edit", message: "Choose Option", preferredStyle: .actionSheet)
        let ac = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            
            if let currentPopoverpresentioncontroller = ac.popoverPresentationController{
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                currentPopoverpresentioncontroller.sourceView = self.view
                //self.present(ac, animated: true, completion: nil)
            }
        }/**else{
         self.present(ac, animated: true, completion: nil)
         }*/
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.takeVideos()
            
            //pg 206
            // .self.itemStore.removeItem(item)
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        let controller = UIImagePickerController()
        let libraryAction = UIAlertAction(title: "Video Library", style: .default, handler: { (action) -> Void in
            self.viewLibrary(controller)
        })
        
        ac.addAction(cameraAction)
        ac.addAction(libraryAction)
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
    //will first check to see if a camera is available
    //will set the array to contain movies as the mediaTypes
    //Purpose: To take a video for the Gallery if the camera is available
    //Precondition: needs the privacy - camera usage in the info.plist
    //Postcondition: A video will be taken or selected from the photos library
    @IBAction func takeVideo(_ sender: UIBarButtonItem) {
        
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
    //Postcondtion: The video will be added to the photos directory, turned into a thumbnail and put on screen in the Gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            //calls the videoSaved fx
            let selectorToCall = #selector(self.videoSaved(_:didFinishSavingWithError:context:))
            
            
            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)
            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])
            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
            
            addVideoThumbnailToTableView(selectedVideo: selectedVideo)
            
           // let video =  videoRepository.createVideo(userID: " ", videoURL: selectedVideo)
          //  let videoID = videoRepository.addVideo(videoToAdd: video)
           // print(videoID)
           // let videoThumbnail = turnVideoToThumbnail(selectedVideo)
           // let updatevideoID = videoRepository.updateVideo(videoToUpdateID: videoID, description: nil, longerVideoURL: nil, thumbnail: videoThumbnail)
            
           /* if videoThumbnail != nil{
                
                //put that image on the screen in the image view
                //need the imageView
               // imageView.image = videoThumbnail
               // thumbNail.image = videoThumbnail
              //  Thumbnail.setImage(videoThumbnail, for: .selected)
                
            }*/
        }
        
        picker.dismiss(animated: true)
    }
    
    //Purpose: To create a Video object, and add a thumbnail of the video to the tableView
    //Precondtion: a valid URL
    //Postcondtion: A thumbnail will be created from the video URL, presented in the tableView, a Video object will be created and added to the repository's array of Videos
    func addVideoThumbnailToTableView(selectedVideo: URL){
    //Create a new item and add it to the store
         let videoThumbnail = turnVideoToThumbnail(selectedVideo)
        
        let newVideo =  videoRepository.createVideo(userID: " ", videoURL: selectedVideo)
            newVideo.thumbnail = videoThumbnail
        let videoID = videoRepository.addVideo(videoToAdd: newVideo)
   // let newVideo = itemStore.createItem()
     print("This IS the Video ID \(videoID)")
        // print("This IS the User ID \(userID)")
        
        //let updatevideoID = videoRepository.updateVideo(videoToUpdateID: videoID, description: nil, longerVideoURL: nil, thumbnail: videoThumbnail)
        
    //Figure out where that last item is in the array
        if let index = videoRepository.videos.firstIndex(of: newVideo){
             let indexPath = IndexPath(row: index, section: 0)
        
           //insert this new row into the table
          tableView.insertRows(at: [indexPath], with: .automatic)
        
        }
    }
        
    //Purpose: To Save a video to the photos library
    //Precondition: Needs the privacy - photo libraryadditon
    //Postcondition:
    //This method takes four parameters: the video to write, who to tell when writing has finished, what method to call, and any context
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
    
    //Purpose: A required func of the UITableViewDataSource Protocol this returns an int for the number of rows in the table a row for each item
    //Precondition:
    //Postcondition: Returns an int for the number of rows in the table a row for each item
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
      return videoRepository.videos.count
    }
    
    //Purpose: A second required fx the UITableViewDataSource Protocol This is the nth row displays the nth entry in the allItems array. Asks the datasource for a cell to insert in a particular location of the table view.
    //Precondition:
    //Postcondition: Returns a cell in the tableView to display at a particular location in the tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     // Create an istance of UITableViewCell, with default appearance
     //dont use if you have the resue code
     // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
     
     //Get a row or recycled cell
     //Will check the pool or or quee of cells to see if a cell with the correct reuse identifier already exists. If not a new cell will be created and returned
     //The identifier UITableViewCell was created in the storyBoard by selecting the cell in the ui and the attributes to indtifier and selecting the style to right Detail
     // let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
     
     //if using custom ItemCell do this instead of line above to deque a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
     
     //set the text on the cell with the description of this item
     //that is at the nth index of items, where n = row
     //this cell will appera in on the table view
        let video = videoRepository.videos[indexPath.row]
     
     /** cell.textLabel?.text = item.name
     cell.detailTextLabel?.text = "$\(item.valueInDollars)"*/
     
     //configure the custom cell with the Item
        
        cell.Description.text = video.description
        cell.videoDuration.text = convertTimeIntervalToCMTime(video: video)
        cell.Date.text = convertDateMMMddyyyy(dateToConvert: video.dateTaken)
        
        if video.thumbnail != nil{
        cell.thumbnail.setImage(video.thumbnail, for: .normal)
            cell.thumbnail.setBackgroundImage(video.thumbnail, for: .normal)
        }
        //cell.thumbnail.setBackgroundImage(video.thumbnail, for: .normal)
        //cell.thumbnail.imageView?.sizeThatFits((video.thumbnail?.size/10.00))
     
        return cell
     }
    
    //****get the TimeInterval(TimeInterval is a double)and convert it to a CMTime
    //Purpose: To convert the time to CMTime print the duration
    //Precodition: there is a video passed in
    //Postcondition: A sting will be returned with the formatted videoDuration
    func convertTimeIntervalToCMTime(video: Video) -> String{
        var formatTime: String
    //UPDATED Used .seconds of the CMTime
        let convertToTimeInterval: TimeInterval = video.videoDuration.seconds
        
    //print the duration so it looks like min:sec
    //have to get the remainer and format
    //cast minutes into an Int to truncate
        let minutes: Int = Int(convertToTimeInterval/60)
        let seconds: Int = Int(convertToTimeInterval.truncatingRemainder(dividingBy: 60))
        
        if(seconds < 10){
            formatTime =  "\(minutes):0\(seconds)"
        print("\(minutes):0\(seconds)")
        } else{
            formatTime = "\(minutes):\(seconds)"
        print("\(minutes):\(seconds)")
        }
        return formatTime
    }
    
    //Purpose: To convert the Date in the specified format "MMM dd,yyyy" - May 29,2019
    //Preconditon: a Date object is passed
    //PostCondition: the Date will be converted in to the string in format, MMM dd,yyyy and returned
    func convertDateMMMddyyyy(dateToConvert: Date) -> String{
        //---------Prints the Date in the specified format "yyyy-MM-dd hh:mm:ss" - 2019-05-29 12:37:53 or "MMM dd,yyyy" - May 29,2019
        let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let convertedDate = dateFormatter.string(from: dateToConvert)
        print("THIS is date: \(convertedDate)")
        
        return convertedDate

    }
   // func addActionsheetForIpad(actionSheet UIAlertController)
    
    
    
    //---------------Will Need for the Next SCREEN that is navigated to after this------------------------
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
    
    
}
