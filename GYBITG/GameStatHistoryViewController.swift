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
    func getGameStat(statId: Int) -> GameStat
}

class GameStatHistoryViewController: UITableViewController {
    
    var gameRepo: GameStatRepoProtocol!
    
    override func viewDidLoad() {
        gameRepo = GameStatRepo()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
}
