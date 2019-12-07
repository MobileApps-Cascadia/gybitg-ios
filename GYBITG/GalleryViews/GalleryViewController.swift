//This class will take a video for the Gallery if the camera is available. Will have the app access the Photo Library if the camera is not available or if user selects video library from the actionsheet choices.
//Will get the selected video and Save video to the main photo album.
//Will conform to the UINavigationControllerDelegate, UIImagePickerControllerDelegate.
//Will have a UIImageView to store a thumbnail of the video, a videoFileName,
//Will convert the Date in the specified format "MMM dd,yyyy" - May 29,2019. Will convert the time to CMTime print the duration. Will Return an int for the number of rows in the table a row for each item. Will fill the tableView with the items in the repository array of Videos.Will have a vidID: String? and have a prepare for seque method to send the videoID to the youtubeVideoVC to be loaded in the webview.
//  GalleryViewController.swift
//  GYBITG
//
//  Created by Student Account on 5/7/19.
//
import AVFoundation
import AVKit
import Photos
import UIKit
import MobileCoreServices
import CoreMedia
import EzPopup



//The protocol for the VideoView
protocol VideoRepositoryProtocol: Repo{

    //to store all videos
    var videos: [Video] {get}
    func createVideo(userID: String, videoURL: URL, isYouTubeVideo: Bool) -> Video
    func getAllVideos() -> [Video]
    func getVideo(videoID: String) -> Video?
    func addVideo(videoToAdd: Video) -> String
    func updateVideo(videoToUpdateID: String, description: String?, longerVideoURL: URL?, thumbnail: UIImage?) -> String?
    func deleteVideo(videoToDeleteID: String) -> String?
    func deleteAllVideos()

    var path: String{get}
    //A has-a relationship for the delegate
    //Now in fetch get the video requested and send it in the didRecieveData fx
    var delegate: VideoRepoDelegate? { get set }
    func fetch(withId id:String?, videoUrl: String?, userID: String?) -> String

}

class GalleryViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VideoRepoDelegate{

    var videoRepository: VideoRepositoryProtocol?

    let videoFileName = "/video.mp4"

    let avvc = AVPlayerViewController()

    let contentVC = VideoDetailsViewController.instantiate()
    let videoTimeLimit = 180.0
    var videoID: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()

        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAttachmentActionSheet))
          self.navigationItem.rightBarButtonItem? = add

        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150

        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        //Make this VC the videoRepository's delegate
        //Now make and extension and conform to the videoRepos delgate
        videoRepository?.delegate = self

    }

    @IBAction func onEditMenuTouched(_ sender: UIButton) {
        guard let contentVC = contentVC else { return }
        let popupVC = PopupViewController(contentController: contentVC, popupWidth: 300, popupHeight: 300)
        popupVC.cornerRadius = 5
        present(popupVC, animated: true, completion: nil)

    }


    //Purpose: To show the user an actionsheet with options to choose from
    //Precondition: The User clicks the icon
    //Postcondtion: Will present the user with an alertController with options to choose from
    @objc func showAttachmentActionSheet() {

        let ac = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){

            if let currentPopoverpresentioncontroller = ac.popoverPresentationController{
                currentPopoverpresentioncontroller.permittedArrowDirections = []
                currentPopoverpresentioncontroller.sourceRect = CGRect(x: (self.view.bounds.midX), y: (self.view.bounds.midY), width: 0, height: 0)
                currentPopoverpresentioncontroller.sourceView = self.view
            }
        }

        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.takeVideos()
        })
        let controller = UIImagePickerController()
        let libraryAction = UIAlertAction(title: "Video Library", style: .default, handler: { (action) -> Void in
            self.viewLibrary(controller)
        })

       //add an action for selecting video from YOUtube
        let youTubeAction = UIAlertAction(title: "YouTube", style: .default, handler: { (action) -> Void in

          //call the funciton to open youtube app
            self.YoutubeAction()
            //call the function to display an alert with a textbox to enter url
             self.alertTextBoxForYouTubeUrl()
        })

        ac.addAction(cameraAction)
        ac.addAction(libraryAction)
        ac.addAction(youTubeAction)


        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        ac.addAction(cancelAction)

        present(ac, animated: true, completion: nil)
    }

    //Purpose: To take a three minute max video for the Gallery if the camera is available
    //Precondition: needs the privacy - camera usage in the info.plist, the user clicked the camera icon in the UINavigationController
    //Postcondition: A video will be taken or selected from the photos library or an alert will popup to let the user know the video has stopped because of 3 minutes have been reached
    @objc func takeVideos(){
        let controller = UIImagePickerController()

        //Check if project runs on a device with camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            //Present UIImagePickerController to take video
            controller.sourceType = .camera
            controller.mediaTypes = [kUTTypeMovie as String]
            controller.delegate = self

            //limit video to the videoTimeLimit set
            controller.videoMaximumDuration = TimeInterval(videoTimeLimit)

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
    //Postcondtion: The video will be added to the photos directory, turned into a thumbnail and put on screen in the Gallery or if the video is over the 3 minute limit, will alert the user to choose another or cancel
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var isOverThreeMin = false;

        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video to the main photo album
            //calls the videoSaved fx
            if( picker.sourceType != UIImagePickerController.SourceType.photoLibrary){

            let selectorToCall = #selector(self.videoSaved(_:didFinishSavingWithError:context:))

            UISaveVideoAtPathToSavedPhotosAlbum(selectedVideo.relativePath, self, selectorToCall, nil)

            // Save the video to the app directory
            let videoData = try? Data(contentsOf: selectedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDirectory: URL = URL(fileURLWithPath: paths[0])

            let dataPath = documentsDirectory.appendingPathComponent(videoFileName)
            try! videoData?.write(to: dataPath, options: [])
            }
            //if the selected video is from the photoLibrary
            else if( picker.sourceType == UIImagePickerController.SourceType.photoLibrary){
            //check if the selected video is over the limit
                //turn the selected video into an asset to get the duration
                let asset = AVURLAsset(url: selectedVideo, options: nil)

                if( asset.duration.seconds > videoTimeLimit){
                    isOverThreeMin = true
                   picker.dismiss(animated: true)
                   let ac = UIAlertController(title: "Video Selected Is Over the 3 Minute Limit", message: "Select another video or cancel action", preferredStyle: .actionSheet)
                    let controller = UIImagePickerController()
                    let libraryAction = UIAlertAction(title: "Video Library", style: .default, handler: { (action) -> Void in
                               self.viewLibrary(controller)
                      })

                     ac.addAction(libraryAction)
                     let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
                     ac.addAction(cancelAction)

                    self.present(ac, animated: true, completion: nil)

                      }

            }
        //if the video is not over 3 minutes, the video will be turned into a thumbnail and added to the Gallery
            if(!isOverThreeMin){
               addVideoThumbnailToTableView(selectedVideo: selectedVideo)
            }

        }

       picker.dismiss(animated: true)
    }

    //Purpose: To create a Video object, and add a thumbnail of the video to the tableView
    //Precondtion: a valid URL
    //Postcondtion: A thumbnail will be created from the video URL, presented in the tableView, a Video object will be created and added to the repository's array of Videos
    func addVideoThumbnailToTableView(selectedVideo: URL){

        let videoThumbnail = turnVideoToThumbnail(selectedVideo)

        let newVideo =  videoRepository!.createVideo(userID: Constants.TEST_USERID, videoURL: selectedVideo, isYouTubeVideo: false)

            //Need to convert the thumnail into an Image object to meet the requirements of the codable Video model.   Replace  newVideo.thumbnail = videoThumbnail With newVideo.thumbnail = Image(withImage: thumbnail!)

        newVideo.thumbnail = Image(withImage: videoThumbnail!)

        _ = videoRepository!.addVideo(videoToAdd: newVideo)

    //Figure out where that last item is in the array
        if let index = videoRepository!.videos.firstIndex(of: newVideo){
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
        return videoRepository!.videos.count
    }

    //Purpose: A second required fx the UITableViewDataSource Protocol This is the nth row displays the nth entry in the allItems array. Asks the datasource for a cell to insert in a particular location of the table view.
    //Precondition:
    //Postcondition: Returns a cell in the tableView to display at a particular location in the tableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        let video = videoRepository!.videos[indexPath.row]

     //configure the custom cell with the Item
        cell.Description.text = video.description
        cell.videoDuration.text = convertTimeIntervalToCMTime(video: video)
        cell.Date.text = convertDateMMMddyyyy(dateToConvert: video.dateTaken)


        if video.thumbnail != nil{
            //Need to convert the thumbnail (that is a Image object to meet the requirements of the codable Video model) into a UIImage object.  the Image has a getter to do this. 1.Convert Image to UIImage 2.Replace video.thumbnail with covertImageToUIImage

           let covertImageToUIImage = video.thumbnail?.getImage()
            cell.thumbnail.setImage(covertImageToUIImage, for: .normal)
            cell.thumbnail.setBackgroundImage(covertImageToUIImage, for: .normal)
        //cell.thumbnail.setImage(video.thumbnail, for: .normal)
           // cell.thumbnail.setBackgroundImage(video.thumbnail, for: .normal)
        }

        return cell
     }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let indexPath = tableView.indexPathForSelectedRow
        let video = videoRepository!.videos[indexPath!.row]
        if video.isYouTubeVideo == true{
            self.videoID = video.videoID

            self.performSegue(withIdentifier: "goToYouTubeVC", sender: self)
        }

        else{
             self.playThumbnailVideo(videoURL: video.videoURL)
        }
    }

    //Purpose: To convert the time to CMTime show the duration so it looks like min:sec
    //Precodition: there is a video passed in
    //Postcondition: A sting will be returned with the formatted videoDuration
    func convertTimeIntervalToCMTime(video: Video) -> String{
        var formatTime: String

        //Since I have changed the Video model to use something that is codeable, have to put the right object in so need to reverse convert asset.duration into a Duration object that the Video model uses. Replace   //var  duration = Duration(withCMTime: asset.duration) With  if let duration = video.videoDuration.getDuration(){
                       //var  duration = Duration(withCMTime: asset.duration)
        if let duration = video.videoDuration.getDuration(){

            let convertToTimeInterval: TimeInterval = duration.seconds
            let minutes: Int = Int(convertToTimeInterval/60)
            let seconds: Int = Int(convertToTimeInterval.truncatingRemainder(dividingBy: 60))

           if(seconds < 10){
            formatTime =  "\(minutes):0\(seconds)"
           } else{
            formatTime = "\(minutes):\(seconds)"
           }
           return formatTime
        }
        else{return "0:0"}
    }

    //Purpose: To convert the Date in the specified format "MMM dd,yyyy" - May 29,2019
    //Preconditon: a Date object is passed
    //PostCondition: the Date will be converted in to the string in format, MMM dd,yyyy and returned
    func convertDateMMMddyyyy(dateToConvert: Date) -> String{

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let convertedDate = dateFormatter.string(from: dateToConvert)

        return convertedDate
    }

    //Purpose: Plays the video associated with the thumbnail in the listing
    //Precondition: a videoURL is passed
    //PostCondition: The AVPlayer will open and begin playing the video selected
    @objc func playThumbnailVideo(videoURL: URL!){
        avvc.player = AVPlayer(url: videoURL)
        self.present(avvc, animated: true){
        self.avvc.player?.play()
       }
    }

    //Purpose: To add an alert textbox so the user can enter a url to get a video from YouTube
    //Precondition: The user selects the YouTube option from the attachment
    //PostCondition: An an alert will pop up so the user can enter a url and the url will be used to get the video from youtube
    func alertTextBoxForYouTubeUrl(){
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter URL", message: "Add a video from YouTube", preferredStyle: .alert)
        //2. Add the text field
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Text Here"


        }
    // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in

            if let textField = alert?.textFields?[0]{

                    if(textField.text!.isValidURL()){
                        //Will then call the get video
                       let id = self.getVideoIdFromUrl(urlString: textField.text!)

                        _ = textField.text!.isValidURL()
                             //put id and url from textfield into fetch
                        _ = self.videoRepository!.fetch(withId: id, videoUrl: textField.text!, userID: Constants.TEST_USERID)

                    }
                    else {//if the user did not enter a url display an alert and call the function again
                        let emptyFieldAlert = UIAlertController(title: "Empty or invalid URL", message: "You Did not enter a valid Url", preferredStyle: .alert)
                        emptyFieldAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                               self.alertTextBoxForYouTubeUrl()
                    }))

                   self.present(emptyFieldAlert, animated: true, completion: nil)

                }
            }
        }))

        //4. Add code to for canceling action
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
          alert.addAction(cancelAction)

        // 5. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //Purpose: to send the videoId to the youtubeVideoVC to be loaded in the webview
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
          let youtubeViewController = segue.destination as! YouTubeViewController
          if let vidID = self.videoID{
            youtubeViewController.videoID! += vidID
          }
       }

    //Purpose: To add get the url passed
    //Precondition: The user selects the YouTube option from the attachment
    //PostCondition: The url passed
    func getVideoIdFromUrl(urlString: String?)-> String?{
        //Need to do more work to get the id
        //its differnt url  when coppied from Youtube https://youtu.be/RmHqOSrkZnk
        if let array = urlString?.components(separatedBy: ".be/"){
            let id = array[1]
            return id
        }
        else{
        return nil
        }
    }

    //Purpose: To open the Youtube app from this app
    //Precondtions: The user chooses the Youtube option and the user oks the alert to give permission to acces Youtube
    //Postcondition: An alert will pop up for the user to give permission and the Youtube app will open
    func YoutubeAction() {

        let YoutubeQuery =  "Your Query"
        let escapedYoutubeQuery = YoutubeQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let appURL = NSURL(string: "youtube://www.youtube.com/results?search_query=\(escapedYoutubeQuery!)")!
        let webURL = NSURL(string: "https://www.youtube.com/results?search_query=\(escapedYoutubeQuery!)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }

    }


    //purpose: To be notified when the request for the fetched video is completed
    //precodition:@param Video
    //postcodition: the galleryViewController is notified that the video is fetched and will add this video to the array and reload the tableview
    func didReceiveData(_ data: Video?) {
        if let newVideo = data{
            _ = videoRepository!.addVideo(videoToAdd: newVideo)
            self.tableView.reloadData()
         }
        else{
            print(Error.self)
        }
    }
}

//Purpose: To be able to chech the string to see if its a valid URL and matches the String passed in
    extension String{

    //Purpose: To use regular expression to find occurrences of text in a string using a search pattern
    //Precondtions: The string passed in exists
    //Postcondition: The string will be checked for matches true if a match false if not
    func matches(pattern: String?) -> Bool
    {
         guard let patternStr = pattern else {return false}
        do
        {
            let regex = try NSRegularExpression(pattern: patternStr, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: utf16.count)) != nil
        }
        catch
        {
            return false
        }
    }

        //Purpose: To check if the url is valid and matches the pattern
        //Precondtions:
        //Postcondition: Will return true if the Url is valid and matches the pattern of the url
    func isValidURL() -> Bool
    {
        guard let url = URL(string: self ) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false }

        let urlPattern = "https://youtu.be/[a-z0-9]+"
        return self.matches(pattern: urlPattern)
    }


}

//Loads a remote image
//used to upload the corresponding thumbnail to the uploaded Youtube video
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
