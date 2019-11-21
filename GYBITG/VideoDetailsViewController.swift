//
//  VideoDetailsViewController.swift
//  GYBITG
//
//  Created by Student Account on 11/20/19.
//

import UIKit

class VideoDetailsViewController: UIViewController {
    
    @IBOutlet weak var Title_Text: UITextField!
    
    static func instantiate() -> VideoDetailsViewController? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(VideoDetailsViewController.self)") as? VideoDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
