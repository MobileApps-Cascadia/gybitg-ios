//
//  GameStatHistoryViewController.swift
//  GYBITG
//
//  Created by Student Account on 5/9/19.
//

import UIKit

protocol GameStatRepoProtocol {
    @discardableResult func createGameStat() -> GameStat
    var allGameStats: [GameStat] { get set }
    func removeItem(gameStat: GameStat)
    func addGameStat(gameStat: GameStat)
}

class GameStatHistoryViewController: UITableViewController {
    
    var gameRepo: GameStatRepoProtocol!
    
    override func viewDidLoad() {
        gameRepo = GameStatRepo()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameRepo.allGameStats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameStatCellReuseId", for: indexPath) as! GameStatCell
        
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        let item = gameRepo.allGameStats[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let date = dateFormatterGet.date(from: String(describing: item.gameDate)) {
            cell.gameLabel.text = "Game #\(item.statId) played on \(dateFormatterPrint.string(from: date))"
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
            let gameStat = gameRepo.allGameStats[indexPath.row]
            // remove the gamestat from the repo
            gameRepo.removeItem(gameStat: gameStat)
            
            // also remove that row from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
