// This is the view controller that handles all the logic for the game stat table view
//
//  GameStatHistoryViewController.swift
//  GYBITG
//  Created by James Hayes on 5/9/19.
//

import UIKit

// These are the gamestat repo protocol methods that will be used to store, add, remove, and retrieve a gamestat entity
protocol GameStatProtocol {
    @discardableResult func createRandomGameStat() -> GameStat
    var allGameStats: [GameStat] { get set }
    func removeGameStat(gameStat: GameStat)
    func removeGameStatByStatId(statId: Int)
    func addGameStat(gameStat: GameStat)
    func getGameStatByStatId(statId: Int) -> GameStat
    func getAllGameStatsByUserId(userId: String) -> [GameStat]
}

class GameStatHistoryViewController: UITableViewController {
    
    // reference to the gamestat protocol
    var gameRepo: GameStatProtocol!
    
    
    var allGameStats: [GameStat] {
        return gameRepo?.allGameStats ?? []
    }
    
    override func viewDidLoad() {        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload the gamestat data in the table each time the view is shown
        tableView.reloadData()
    }
    
    /*
    // This required method by the UITableViewController class
    // It returns the number of cells that should be inserted in to the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGameStats.count
    }

    // This function is required by the UITableViewController class
    // Here is where each GameStat is added to the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStatCellReuseID", for: indexPath) as! GameStatCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = allGameStats[indexPath.row]
        
        // Date formatter for converting "yyyy-MM-dd HH:mm:ss +0000" to "MM/dd/yyyy"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy"
        
        // fill in the cell with the format: "Vs. <opposing team name> @ <home/away> - <game date>"
        if let date = dateFormatterGet.date(from: String(describing: item.gameDate)) {
            cell.gameLabel.text = "Vs. \(item.opposingTeamName) @ \(item.homeOrAway) - \(dateFormatterPrint.string(from:date))"
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
            let gameStat = allGameStats[indexPath.row]
            
            // remove the gamestat from the repo
            gameRepo.removeGameStat(gameStat: gameStat)
            
            // also remove that row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    */

    @IBAction func cancel(_ unwindSegue: UIStoryboardSegue) { }
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
        if let newGameStatViewController = unwindSegue.source as? NewGameStatViewController {
            print("saving new game stat")
        }
    }
}
