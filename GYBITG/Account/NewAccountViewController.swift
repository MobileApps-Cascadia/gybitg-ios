//
//  NewAccountViewController.swift
//  GYBITG
//
//  Created by Student Account on 5/23/19.
//

import UIKit

class NewAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordVerify: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var highSchoolName : UITextField!
    @IBOutlet weak var clubTeam : UITextField!

    @IBOutlet weak var graduationYear: UIPickerView!
    
    @IBOutlet weak var state: UIPickerView!
    
    var usersRepository = UsersRepository()
    var graduationYearData:[String] = [String]()
    var stateData:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.graduationYear.delegate = self
        //self.graduationYear.dataSource = self
        //self.state.delegate = self
        //self.state.dataSource = self
        
        graduationYearData = ["2019", "2020", "2021", "2022", "2023", "2024"];
        stateData = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND","OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count: Int = 0
        if (pickerView == graduationYear) {
            count = graduationYearData.count
        } else if (pickerView == state) {
            count = stateData.count
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var returnValue:String = ""
        if (pickerView == graduationYear) {
            returnValue = graduationYearData [row]
        } else if (pickerView == state) {
            returnValue = stateData [ row]
        }
        return returnValue
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountTapped(_ sender: UIButton) {
        
        if (emailAddress.text == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter an email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (password.text == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter a password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (password.text != passwordVerify.text) {
            let alert = UIAlertController(title: "Alert", message: "Passwords do not match", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (firstName.text == "") {
            let alert = UIAlertController(title: "Alert", message: "Please enter your first name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            _ = usersRepository.addUser(userToAdd: User(userId: emailAddress.text!, password: password.text!, createDate: Date(), lastLoginDate: Date(), firstName: firstName.text!, lastName: "", highSchoolName: "", clubTeam: "", graduationYear: "", state: ""))
            self.dismiss(animated: true, completion: nil)
        }
    }
}


