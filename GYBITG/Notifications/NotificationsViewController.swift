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
        
        gameRepo?.getAllGameStatsByUserId(userId: Constants.TEST_USERID)
        statDraftsTableView.reloadData()
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "GameStat", bundle: nil)
        let newGameStatViewController = storyboard.instantiateViewController(withIdentifier: "NewGameStatViewController") as! NewGameStatViewController
        newGameStatViewController.mGameStat = gameRepo!.allGameStatDrafts[indexPath.row]
        
        let navVC = UINavigationController(rootViewController: newGameStatViewController)
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
