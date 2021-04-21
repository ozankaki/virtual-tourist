//
//  ListDataSource.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 21.04.2021.
//

import Foundation
import CoreData

class ListDataSource<EntityType: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<EntityType>
    
    init(managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>, cacheName: String) {
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: cacheName)
        super.init()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func object(at: IndexPath) -> EntityType {
        return fetchedResultsController.object(at: at)
    }
    
    func objects() -> [EntityType]? {
        return fetchedResultsController.fetchedObjects ?? nil
    }
    
    func deleteEntity(at indexPath: IndexPath) {
        let entityToDelete = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(entityToDelete)
        try? fetchedResultsController.managedObjectContext.save()
    }
}
