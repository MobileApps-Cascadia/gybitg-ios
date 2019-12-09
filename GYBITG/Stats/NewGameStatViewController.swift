// This is the view controller that handles all the logic for the game stat form view
//
//  NewGameStatViewController.swift
//  GYBITG
//
//  Created by James Hayes on 5/28/19.
//

import UIKit

class NewGameStatViewController: UIViewController {
    
    // All the outlets for the elements in the game stat form view
    @IBOutlet weak var gameDatePicker: UIDatePicker!
    @IBOutlet weak var pointsField: UITextField!
    @IBOutlet weak var reboundsField: UITextField!
    @IBOutlet weak var assistsField: UITextField!
    @IBOutlet weak var stealsField: UITextField!
    @IBOutlet weak var blocksField: UITextField!
    @IBOutlet weak var minutesPlayedField: UITextField!
    @IBOutlet weak var opposingTeamField: UITextField!
    @IBOutlet weak var homeOrAwaySegmentedControl: UISegmentedControl!
    
    // initialize the home/away variable for use in the GameStat entity later on when adding to repo data array
    var homeOrAway: String?
    
    // referencing the protocol
    var gameRepo: GameStatProtocol?
    
    // Reference a new game stat entity that will be initialized on the 'Save' segue
    var mGameStat: GameStat?
    
    // Used to keep track of whether we're updating a current Game Stat or not
    // initial value of 'false'
    var isUpdate: Bool = false
    
    // Used to keep track of whether the GameStat is a draft or not
    // Initial Value: true - every GameStat begins as a draft. Once the user saves the GameStat then isDraft = false.
    var isDraft: Bool = false
    
    // Purpose: track whether the user wants to save the gamestat as a draft or not
    // initial value of 'false'
    var saveAsDraft: Bool = false
    
    var window: UIWindow?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If we're updating a current Game Stat then fill in the text fields with
        // the current game stat's data
        if (mGameStat != nil) {
            if(isUpdate || mGameStat?.isDraft == true) {
                gameDatePicker.date = mGameStat!.gameDate!
                if let points = mGameStat?.points {
                    pointsField.text = String(points)
                }
                if let rebounds = mGameStat?.rebounds {
                    reboundsField.text = String(rebounds)
                }
                if let assists = mGameStat?.assists {
                    assistsField.text = String(assists)
                }
                if let steals = mGameStat?.steals {
                    stealsField.text = String(steals)
                }
                if let blocks = mGameStat?.blocks {
                    blocksField.text = String(blocks)
                }
                if let minutesPlayed = mGameStat?.minutesPlayed {
                    minutesPlayedField.text = String(minutesPlayed)
                }
                if let opposingTeam = mGameStat?.opposingTeamName {
                    opposingTeamField.text = String(opposingTeam)
                }
                if (mGameStat?.homeOrAway == "Home") {
                    homeOrAwaySegmentedControl.selectedSegmentIndex = 0
                    homeOrAway = "Home"
                } else if (mGameStat?.homeOrAway == "Away") {
                    homeOrAwaySegmentedControl.selectedSegmentIndex = 1
                    homeOrAway = "Away"
                } else {
                    homeOrAwaySegmentedControl.selectedSegmentIndex = -1
                }
            }
        }
        
        // These are for changing the placeholder text color progromatically
        gameDatePicker.setValue(UIColor.lightText, forKey: "textColor")
        
        pointsField.attributedPlaceholder = NSAttributedString(string: "Points",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        reboundsField.attributedPlaceholder = NSAttributedString(string: "Rebounds",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        assistsField.attributedPlaceholder = NSAttributedString(string: "Assists",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        stealsField.attributedPlaceholder = NSAttributedString(string: "Steals",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        blocksField.attributedPlaceholder = NSAttributedString(string: "Blocks",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        minutesPlayedField.attributedPlaceholder = NSAttributedString(string: "Minutes Played",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
        opposingTeamField.attributedPlaceholder = NSAttributedString(string: "Opposing Team",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightText])
    }
    
    
    // A method that is triggered when the background view is tapped
    // This method will call resignFirstResponder() on the text field outlets to hide the keyboard
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        pointsField.resignFirstResponder()
        reboundsField.resignFirstResponder()
        assistsField.resignFirstResponder()
        stealsField.resignFirstResponder()
        blocksField.resignFirstResponder()
        minutesPlayedField.resignFirstResponder()
        opposingTeamField.resignFirstResponder()
        
    }
    // This method gets called when the user selects either 'home' or 'away' on the segmented control
    // The segmened control uses indexes so in this case, 0 = "home" and 1 = "away"
    // The homeOrAway variable initialized earlier is used to store the game location 
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl) {
        switch homeOrAwaySegmentedControl.selectedSegmentIndex {
        case 0:
            homeOrAway = "Home"
        case 1:
            homeOrAway = "Away"
        default:
            break
        }
    }
    
    @IBAction func closeStatModal(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // IBAction func linked to the 'Save' button on the Game Stat form
    // Check if the user left any fields blank
    // If a field is left blank, show an alert, warning user it will be entered as a '0'.
    // The user can save the gamestat as a draft then go and finish filling out later
    @IBAction func checkForEmptyFields(_ sender: UIBarButtonItem) {
        // check if the alert should be displayed
        if (homeOrAwaySegmentedControl.selectedSegmentIndex == -1 || pointsField.text == "" || reboundsField.text == "" || assistsField.text == "" || stealsField.text == "" || blocksField.text == "" || minutesPlayedField.text == "" || opposingTeamField.text == "") {
            
            // set the alert message and title
            let alert = UIAlertController(title: "You have blank stat(s) fields.", message: "Blank fields are recorded as zero", preferredStyle: UIAlertController.Style.alert)
            
            
            // Purpose: The YesAction sets the GameStat with values of 0 for fields that are not filled out
            // If the user decides to save the game stat w/ out filling all the fields, we sill need to
            // save the game stat properties with a value of '0'.
            let YesAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
                (_)in
                self.isDraft = false
                if (self.pointsField.text == ""){
                    self.pointsField.text = "0"
                }
                if (self.reboundsField.text == "") {
                    self.reboundsField.text = "0"
                }
                if (self.assistsField.text == "") {
                    self.assistsField.text = "0"
                }
                if (self.stealsField.text == "") {
                    self.stealsField.text = "0"
                }
                if (self.blocksField.text == "") {
                    self.blocksField.text = "0"
                }
                if (self.minutesPlayedField.text == "") {
                    self.minutesPlayedField.text = "0"
                }
                if (self.opposingTeamField.text == "") {
                    self.opposingTeamField.text = ""
                }
                if (self.homeOrAway != "Home" && self.homeOrAway != "Away") {
                    self.homeOrAway = ""
                    self.homeOrAwaySegmentedControl.selectedSegmentIndex = -1
                }
                
                // Perform the unwind segue ->
                // return to the gamestathistoryviewcontroller and save the gamestat
                self.performSegue(withIdentifier: UIStoryboardSegue.AppSegue.unwindSegueShowGameStatHistory.rawValue, sender: self)
            })
    
            // Close the alert dialog and stay on the game stat form
            let NoAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            // Save the GameStat as a draft to fill out later
            let SaveDraftAction = UIAlertAction(title: "Save as Draft", style: UIAlertAction.Style.default, handler: { (_) in
                self.saveAsDraft = true
                self.performSegue(withIdentifier: UIStoryboardSegue.AppSegue.unwindSegueShowGameStatHistory.rawValue, sender: self)
            })
            
            // show the alert
            alert.addAction(YesAction)
            alert.addAction(NoAction)
            if (self.isUpdate == false) {
                alert.addAction(SaveDraftAction)
            }
            self.present(alert, animated: true, completion: nil)
        } else {
            if (self.isDraft) {
                dismiss(animated: true, completion: nil)
            }
            else {
                // If all the fields have been filled out then proceed to the unwind segue
                self.performSegue(withIdentifier: UIStoryboardSegue.AppSegue.unwindSegueShowGameStatHistory.rawValue, sender: self)
            }
        }
    }
    
    
    // This segue is connected to the 'Save' button, unwind segue,
    // it initializes a game stat entity with the filled in form data.
    // Then passes it to the unwind segue in the GameStatHistoryViewController to add it to the data array
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mGameStatId: Int
        let mGameStatUserId: String
        // check whether we should update a current game stat or create a new one
        if (isUpdate) {
            mGameStatId = mGameStat!.statId!
            mGameStatUserId = mGameStat!.userId!
        } else {
            mGameStatId = (gameRepo!.allGameStats.count) + 1
            mGameStatUserId = Constants.TEST_USERID
        }
        // the user has chosen to save as draft
        if (saveAsDraft) {
            mGameStat = GameStat(statId: mGameStatId, userId: mGameStatUserId, gameDate: gameDatePicker.date, isDraft: true)
            
            // build the rest of the GameStat
            if (self.pointsField.text != ""){
                mGameStat?.addPoints(points: Int(self.pointsField.text!)!)
            }
            if (self.reboundsField.text != "") {
                mGameStat?.addRebounds(rebounds: Int(self.reboundsField.text!)!)
            }
            if (self.assistsField.text != "") {
                mGameStat?.addAssists(assists: Int(self.assistsField.text!)!)
            }
            if (self.stealsField.text != "") {
                mGameStat?.addSteals(steals: Int(self.stealsField.text!)!)
            }
            if (self.blocksField.text != "") {
                mGameStat?.addBlocks(blocks: Int(self.blocksField.text!)!)
            }
            if (self.minutesPlayedField.text != "") {
                mGameStat?.addMinPlayed(minPlayed: Double(minutesPlayedField.text!)!)
            }
            if (self.opposingTeamField.text != "") {
                mGameStat?.addOppTeam(oppTeam: self.opposingTeamField.text!)
            }
            if (self.homeOrAway != "Home" && self.homeOrAway != "Away") {
                self.homeOrAway = ""
                self.homeOrAwaySegmentedControl.selectedSegmentIndex = -1
            }
            
        } else {
            // check to see if all the form fields have been filled out
            if let mGameDate = gameDatePicker?.date,
            let mPoints = Int(pointsField.text!),
            let mRebounds = Int(reboundsField.text!),
            let mAssists = Int(assistsField.text!),
            let mSteals = Int(stealsField.text!),
            let mBlocks = Int(blocksField.text!),
            let mMinutesPlayed = Double(minutesPlayedField.text!),
            let mOpposingTeam = opposingTeamField?.text!,
            let mHomeOrAway: String = homeOrAway {
                // If we make it here, it means the user has filled out all the fields and we can save the GameStat straight up.
                // This also means that the user has chosen to not save a "draft" so we can set isDraft to false.
                mGameStat = GameStat(statId: mGameStatId, userId: mGameStatUserId, gameDate: mGameDate, isDraft: false, points: mPoints, rebounds: mRebounds, assists: mAssists, steals: mSteals, blocks: mBlocks, minutesPlayed: mMinutesPlayed, opposingTeamName: mOpposingTeam, homeOrAway: mHomeOrAway)
            }
        }
    }
    
}

