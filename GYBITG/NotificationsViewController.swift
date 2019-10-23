//
//  NotificationsViewController.swift
//  GYBITG
//
//  Created by James Hayes on 10/14/19.
//

import UIKit
import CoreData

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var statDraftsTableView: UITableView!
    var gameRepo: GameStatRepo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        statDraftsTableView.rowHeight = 75
//        statDraftsTableView.estimatedRowHeight = 75
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statDraftsTableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (gameRepo?.allGameStatDrafts.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = statDraftsTableView.dequeueReusableCell(withIdentifier: "GameStatDraftCell", for: indexPath) as! GameStatDraftTableViewCell
        
        let item = gameRepo!.allGameStatDrafts[indexPath.row]
        
        // Date formatter for converting "yyyy-MM-dd HH:mm:ss +0000" to "MM/dd/yyyy"
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/YY"
        
        // fill in the cell with the format: "Vs. <opposing team name> @ <home/away> - <game date>"
        if let date = dateFormatterGet.date(from: String(describing: item.gameDate)) {
            cell.cellLabel.text = "Draft started on: \(dateFormatterPrint.string(from:date))"
        } else {
            print("There was an error decoding the string")
        }
        return cell
    }
}

class GameStatDraftTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellLabel.adjustsFontForContentSizeCategory = true
    }
}
