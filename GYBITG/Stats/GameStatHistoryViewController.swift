// This is the view controller that handles all the logic for the game stat table view
//
//  GameStatHistoryViewController.swift
//  GYBITG
//  Created by James Hayes on 5/9/19.
//

import UIKit

// These are the gamestat repo protocol methods that will be used to store, add, remove, and retrieve a gamestat entity
protocol GameStatProtocol: Repo {
    @discardableResult func createRandomGameStat() -> GameStat
    var allGameStats: [GameStat] { get set }
    var allGameStatDrafts: [GameStat] { get set }
    func removeGameStat(gameStat: GameStat)
    func removeGameStatByStatId(statId: Int)
    func addGameStat(gameStat: GameStat)
    func saveGameStatDraft(gameStat: GameStat)
    func getGameStatByStatId(statId: Int) -> GameStat
    func getAllGameStatsByUserId(userId: String) -> [GameStat]
    func getAllDrafts() -> [GameStat]
    func getAllGameStatDraftsByUserId(userId: String) -> [GameStat]
    func updateGameState(gamestat: GameStat)
}

class GameStatHistoryViewController: UITableViewController {
    
    // Reference to the gamestat protocol that is instanitated in the appdelegate file
    var gameRepo: GameStatProtocol?
    
    
    // This function is ran only once when the view is initially loaded
    override func viewDidLoad() {        
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 75
    }
    
    // This function is called everytime the view is loaded
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // update the badge number for the Notifications tab icon
        if let tabItems = tabBarController?.tabBar.items {
            let x : Int = (gameRepo?.allGameStatDrafts.count)!
            let count = String(x)
            
            // In this case we want to modify the badge number of the third (Notifications) tab:
            let tabItem = tabItems[2]
            tabItem.badgeValue = (x > 0 ? count : nil)
        }
        
        // Reloads the gamestat data in the table each time the view is shown
        tableView.reloadData()
    }
    
    
    // This required method by the UITableViewController class
    // It returns the number of cells that should be inserted in to the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (gameRepo?.allGameStats.count)!
    }

    // This function is required by the UITableViewController class
    // Here is where each GameStat is added to the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStatCellReuseID", for: indexPath) as! GameStatCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = gameRepo!.allGameStats[indexPath.row]
        
        // Date formatter for converting "yyyy-MM-dd HH:mm:ss +0000" to "MM/dd/yyyy"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/YY"
        
        // fill in the cell with the format: "Vs. <opposing team name> @ <home/away> - <game date>"
        if let date = dateFormatterGet.date(from: String(describing: item.gameDate)) {
            cell.gameLabel.text = "Vs. \(item.opposingTeamName!) @ \(item.homeOrAway!) - \(dateFormatterPrint.string(from:date))"
        } else {
            print("There was an error decoding the string")
        }
        return cell
    }
    
    // Provide a indexPath to the cell you want to delete
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let gameStat = gameRepo!.allGameStats[indexPath.row]
            
            // remove the gamestat from the repo
            gameRepo!.removeGameStat(gameStat: gameStat)
            
            // also remove that row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
 
    // Segue forward to the NewGameStatViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Use the enum in the UIStoryboard file to grab the segue identifier; segueModalGameStatForm
        if(segue.identifier == UIStoryboardSegue.AppSegue.segueModalGameStatForm.rawValue) {
            // The 'forward' method is located in the UIStoryboardSegue file
            segue.forward(gameRepo!, to: segue.destination)
        }
        // This is triggered when the user clicks on a Game Stat cell in the table view
        // it will take them to the Game Stat form with the selected Game Stat data filled in.
        // This allows the user to edit/update the game stat
        if(segue.identifier == UIStoryboardSegue.AppSegue.segueModalEditGameStat.rawValue) {
            if let navController = segue.destination as? UINavigationController {
                if let newGameStatviewController = navController.topViewController as? NewGameStatViewController {
                    let index = tableView.indexPathForSelectedRow?.row
                    
                    newGameStatviewController.mGameStat = gameRepo!.allGameStats[index!]
                    newGameStatviewController.isUpdate = true
                    segue.forward(gameRepo!, to: segue.destination)
                }
            }
        }
    }

    // This action method performs an unwind segue, returning the user from the game stat form back to the game stat history table view
    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) { tableView.reloadData() }
    
    // This action method performs an unwind segue, returning the user from the game stat form back to the game stat history table iew and saves (adds) the new game stat to the repository data array    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
        if let newGameStatViewController = unwindSegue.source as? NewGameStatViewController {
            // check whethere the user is updating or creating a new Game Stat
            if (newGameStatViewController.isUpdate) {
                gameRepo?.updateGameState(gamestat: newGameStatViewController.mGameStat!)
            } else {
                if (newGameStatViewController.saveAsDraft) {
                    gameRepo!.saveGameStatDraft(gameStat: newGameStatViewController.mGameStat!)
                }
                else {
                    gameRepo!.addGameStat(gameStat: newGameStatViewController.mGameStat!)
                }
            }
            tableView.reloadData()
        }
    }
}
