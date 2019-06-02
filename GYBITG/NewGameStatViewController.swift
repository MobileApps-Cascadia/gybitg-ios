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
    var homeOrAway: String! = ""
    
    // referencing the protocol
    var gameRepo: GameStatProtocol?
    
    // Reference a new game stat entity that will be initialized on the 'Save' segue
    var mGameStat: GameStat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // This segue is connected to the 'Save' button, unwind segue, it initializes a game stat entity with the filled in form data then passes it to the unwind segue in the GameStatHistoryViewController to add it to the data array
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let mGameDate = gameDatePicker?.date,
        let mPoints = Int(pointsField.text!),
        let mRebounds = Int(reboundsField.text!),
        let mAssists = Int(assistsField.text!),
        let mSteals = Int(stealsField.text!),
        let mBlocks = Int(blocksField.text!),
        let mMinutesPlayed = Double(minutesPlayedField.text!),
        let mOpposingTeam = opposingTeamField?.text!,
        let mHomeOrAway: String = homeOrAway {
            let mGameStatId = ((gameRepo?.allGameStats.count)!) + 1
            let mGameStatUserId = "ksmith@gmail.com"
            mGameStat = GameStat(statId: mGameStatId, userId: mGameStatUserId, gameDate: mGameDate, points: mPoints, rebounds: mRebounds, assists: mAssists, steals: mSteals, blocks: mBlocks, minutesPlayed: mMinutesPlayed, opposingTeamName: mOpposingTeam, homeOrAway: mHomeOrAway)
        }
    }
    
}

