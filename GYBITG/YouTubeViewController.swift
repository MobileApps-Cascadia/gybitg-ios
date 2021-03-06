//This class will get the videoId and play the youtubevideo.Will get the URL of the youTube video. Will load and play the Youtube video passed in and The WKWebView will play the youtube video. Will have a WKWebView webView, a Sting videoID and a videoUrl that is the url of the video to be loaded.
//  YouTubeViewController.swift
//  GYBITG
//
//  Created by juanita aguilar on 11/23/19.
//

import UIKit
import WebKit

class YouTubeViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {

    var webView: WKWebView!
    var videoID:String? = ""
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUrltoLoad()
        // Do any additional setup after loading the view.
    }
    
    //Purpose: To load and play the Youtube video passed in
     //Precondition: The video is a youtube video and the user clicks on the cell that has the corresponding youtube video information
     //Postcondition: The WKWebView will play the youtube video
    override func viewDidAppear(_ animated: Bool) {
        let myRequest = URLRequest(url: self.videoURL!)
        webView.load(myRequest)
    }

       override func loadView() {
           let webConfiguration = WKWebViewConfiguration()
           webView = WKWebView(frame: .zero, configuration: webConfiguration)
           webView.uiDelegate = self
           view = webView
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Purpose: To get the URL of the youTube video
     //Precondition: The video is a youtube video
     //Postcondition: The Self.videoURL will be set to the the Youtube url if the videoID is not nill or a default YoutTube url
    func getUrltoLoad(){
        if let videoID = self.videoID{
            self.videoURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
        }
        else{
            self.videoURL =  URL(string:"https://www.youtube.com")
        }
    }

}

extension WKWebView{
    func load(_ urlString: String) {
        if let url = URL(string: urlString){
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
