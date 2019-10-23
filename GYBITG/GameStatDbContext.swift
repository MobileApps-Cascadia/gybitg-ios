//
//  GameStatDbContext.swift
//  GYBITG
//
//  Created by James Hayes on 10/23/19.
//

import UIKit
import Foundation
import CoreData

public class GameStatDbContext {
    
    var instance: GameStatDbContext?
    
    init() {
        self.instance = GetInstance()
    }
    
    private func GetInstance() -> GameStatDbContext {
        if (self.instance == nil) {
            self.instance = GameStatDbContext()
        }
        return instance!
    }
    
    func save(stat: GameStat) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "GStat", in: managedContext)!
        let newGameStat = NSManagedObject(entity: entity, insertInto: managedContext)
        
    
    }
}
