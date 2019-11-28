//
//  NotificationsViewController.swift
//  GYBITG
//
//  Created by James Hayes on 10/14/19.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var statDraftsTableView: UITableView!
    var gameRepo: GameStatProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // use our repo method to retrieve all gamestat drafts of the signed in user
        gameRepo?.getAllGameStatsByUserId(userId: Constants.TEST_USERID)
        statDraftsTableView.reloadData()
    }
    
    // function for returning a defualt text if no game location has been set by user
    func convertGameLoc(gameLoc: String) -> String {
        switch(gameLoc) {
        case "Home":
            return "vs "
        case "Away":
            return "@ "
        case "":
            return "(no location set) "
        default:
            return ""
        }
    }
    
    // function for returning a defualt text if no opposing team has been set by user
    func convertOppTeam(oppTeam: String) -> String {
        if (oppTeam == "") {
            return "(opposing team not set)"
        } else {
            return oppTeam
        }
    }
    
}

// MARK: - UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (gameRepo?.allGameStatDrafts.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = statDraftsTableView.dequeueReusableCell(withIdentifier: "GameStatDraftCell", for: indexPath) as! GameStatDraftTableViewCell
        
        let item = gameRepo!.allGameStatDrafts[indexPath.row]
        
        // Date formatter for converting "yyyy-MM-dd HH:mm:ss +0000" to "MM/dd/yyyy"
        let date = item.gameDate
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YY"
        
        // begin building out the celllabel string text
        cell.cellLabel.text = "\(convertGameLoc(gameLoc: item.homeOrAway ?? "") )"
        cell.cellLabel.text?.append(convertOppTeam(oppTeam: item.opposingTeamName ?? "") )
        cell.cellLabel.text?.append(" on \(formatter.string(from: date!))")
        
        return cell
    }
    
    // This gets called when the user clicks on a gamestat draft in the notifications view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get a reference to the GameStat storyboard
        let storyboard = UIStoryboard(name: "GameStat", bundle: nil)
        // get a reference to the NewGameStatViewController
        let newGameStatViewController = storyboard.instantiateViewController(withIdentifier: "NewGameStatViewController") as! NewGameStatViewController
        // prepare the gamestat that was selected in the table
        newGameStatViewController.mGameStat = gameRepo!.allGameStatDrafts[indexPath.row]
        newGameStatViewController.isUpdate = true
        
        // attach a navigation controller to our newgamestat view controller
        let navVC = UINavigationController(rootViewController: newGameStatViewController)
        // present the form with the selected gamestat's info
        self.present(navVC, animated: true, completion: nil)
    }
}


// The Custome cell class for the table view
class GameStatDraftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellLabel.adjustsFontForContentSizeCategory = true
    }
}
