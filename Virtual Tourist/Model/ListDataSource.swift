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
    var handleAfterInsert: (EntityType, IndexPath) -> Void
    var handleAfterDelete: (IndexPath) -> Void
    
    init(managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<EntityType>, cacheName: String,
         configure: @escaping ([EntityType]) -> Void, handleAfterInsert: @escaping (EntityType, IndexPath) -> Void,
         handleAfterDelete: @escaping (IndexPath) -> Void) {
        
        self.handleAfterInsert = handleAfterInsert
        self.handleAfterDelete = handleAfterDelete
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil, cacheName: cacheName)
        super.init()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            guard let pins = objects() else {
                return
            }
            
            configure(pins)
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
    
    func fetchedCount(section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func deleteEntity(at indexPath: IndexPath) {
        let entityToDelete = fetchedResultsController.object(at: indexPath)
        fetchedResultsController.managedObjectContext.delete(entityToDelete)
        try? fetchedResultsController.managedObjectContext.save()
    }
    
    func deleteAll() {
        if let entitiesToDelete = fetchedResultsController.fetchedObjects {
            if entitiesToDelete.isEmpty {
                return
            }
            var objectIDs = [NSManagedObjectID]()
            for entityToDelete in entitiesToDelete {
                objectIDs.append(entityToDelete.objectID)
            }
            
            let deleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
            do {
                try fetchedResultsController.managedObjectContext.execute(deleteRequest)
                try fetchedResultsController.performFetch()
            } catch {
                print(error)
            }
            
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            handleAfterDelete(indexPath!)
        case .insert:
            handleAfterInsert((anObject as? EntityType)!, newIndexPath!)
        default:
            break
        }
    }
}
