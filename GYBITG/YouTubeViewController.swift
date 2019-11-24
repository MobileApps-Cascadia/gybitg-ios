//
//  YouTubeViewController.swift
//  GYBITG
//
//  Created by juanita aguilar on 11/23/19.
//

import UIKit
import WebKit



class YouTubeViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {

   
   /* @IBOutlet weak var myWKWebView: WKWebView!{
        didSet{
           myWKWebView.uiDelegate = self
                myWKWebView.navigationDelegate = self
        }
    }*/
    
    let vidID:String? = "annoymous"
    
    //let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          let myURL = URL(string:"https://www.apple.com")
                  let myRequest = URLRequest(url: myURL!)
                  webView.load(myRequest)
          // getVideo(v"ideoID: vidID)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let testurlstring = "https://www.apple.com"
       // webView.load(testurlstring)
        print("THIS is prinitn from viewDidAppear: \(testurlstring)"  )
        let myURL = URL(string:"https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
  /*  override func loadView() {
        self.view = webView
          webView.uiDelegate = self
        //getVideo(videoID: vidID)
    }*/
    var webView: WKWebView!
       
       override func loadView() {
           let webConfiguration = WKWebViewConfiguration()
           webView = WKWebView(frame: .zero, configuration: webConfiguration)
           webView.uiDelegate = self
           view = webView
       }
     /*  override func viewDidLoad() {
           super.viewDidLoad()
           
           let myURL = URL(string:"https://www.apple.com")
           let myRequest = URLRequest(url: myURL!)
           webView.load(myRequest)
       }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //Purpose: To load and play the Youtube video passed in
    //Precondition: The video is a youtube video and the user clicks on the cell that has the corresponding youtube video information
    //Postcondition: The WKWebView will play the youtube video
    func getVideo(videoID: String?){
        if let vidID = videoID{
            let url = URL(string: "https://www.youtube.com/embed/\(vidID)")!
            print(url)
            
           // myWKWebView.load(URLRequest(url: url))
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
