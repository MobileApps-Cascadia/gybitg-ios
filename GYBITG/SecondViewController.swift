//
//  SecondViewController.swift
//  GYBITG
//
//  Created by Student Account on 4/25/19.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var loginID: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginUser(_ sender: UIButton) {
        if (loginID.text == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter your login id", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (password.text == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter your password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

