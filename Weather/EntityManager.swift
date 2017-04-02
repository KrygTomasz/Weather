//
//  EntityManager.swift
//  Weather
//
//  Created by Kryg Tomasz on 31.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit
import CoreData

class EntityManager {
    
    static func fetch(from entity: String) -> [NSManagedObject] {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Wrong AppDelegate")
            return []
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        do {
            let results = try context.fetch(fetchRequest)
            guard let fetchedObjects: [NSManagedObject] = results as? [NSManagedObject] else {
                print("Fetch failed.")
                return []
            }
            return fetchedObjects
        } catch let error as NSError {
            print("Couldn't fetch objects due to \(error).")
            return []
        }
    }
    
    static func remove(_ object: NSManagedObject, from entity: String) {
        guard let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Couldn't remove object from entity \(entity).")
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(object)
        print("Object successfully deleted from entity \(entity).")
    }
    
}
