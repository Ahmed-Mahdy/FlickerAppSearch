//
//  coreDataManager.swift
//  FlickrAppSearch
//
//  Created by Ahmed Mahdy on 20/09/2021.
//

import CoreData
import UIKit

class coreDataManager {

    private var latestSearchTerms: [NSManagedObject] = []

    var appDelegate: AppDelegate?
    var managedContext: NSManagedObjectContext?
    var entity: NSEntityDescription?

    init() {
        appDelegate =
            UIApplication.shared.delegate as? AppDelegate

        managedContext =
            appDelegate?.persistentContainer.viewContext

        entity =
            NSEntityDescription.entity(forEntityName: "Search",
                                       in: managedContext!)!
    }

    func save(name: String) {
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Search")
        fetchRequest.predicate = NSPredicate(format: "searchTerm = %@", name)
        do {
            if  try managedContext?.fetch(fetchRequest).count == 0 {
                let search = NSManagedObject(entity: entity!,
                                             insertInto: managedContext)
                search.setValue(name, forKeyPath: "searchTerm")
                do {
                    try managedContext?.save()
                    latestSearchTerms.append(search)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func getLastSearchTerms() -> [String] {

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Search")

        do {
            latestSearchTerms = try (managedContext?.fetch(fetchRequest))!
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return latestSearchTerms.map{ $0.value(forKey: "searchTerm") as! String }
    }
}
