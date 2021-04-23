//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var photoAlbumMapView: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var pinnedAnnotation: PinnedAnnotation!
    var dataController: DataController!
    var listDataSource: ListDataSource<Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        setupFetchedResultsController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        photoAlbumMapView.addAnnotation(pinnedAnnotation)
        photoAlbumMapView.setCenter(pinnedAnnotation.coordinate, animated: true)
    }

    @IBAction func newCollectionTapped(_ sender: Any) {
        // TODO:
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "pin == %@", pinnedAnnotation.pin)
        fetchRequest.predicate = predicate
        listDataSource = ListDataSource(managedObjectContext: dataController.viewContext,
                                        fetchRequest: fetchRequest, cacheName: "\(pinnedAnnotation.pin.id!)-photos",
                                        configure: handleDataSourceLoad(photos:), handleAfterInsert: handleInsertData(indexPath:),
                                        handleAfterDelete: handleDeleteData(indexPath:))
    }
    
    func handleDataSourceLoad(photos: [Photo]) {
        if photos.count == 0 {
            getLocationPhotos()
        }
    }
    
    func handleInsertData(indexPath: IndexPath) {
        self.photoCollectionView.insertItems(at: [indexPath])
    }
    
    func handleDeleteData(indexPath: IndexPath) {
        self.photoCollectionView.deleteItems(at: [indexPath])
    }
    
    func getLocationPhotos() {
        FlickrClient().searchPhotos(latitude: pinnedAnnotation!.pin.latitude, longitude: pinnedAnnotation!.pin.longitude, completion: handleGetLocationPhotos(result:error:))
    }
    
    func handleGetLocationPhotos(result: [LocationPhoto], error: Error?) {
        if error == nil {
            for photo in result {
                savePhoto(photo.imagePath)
            }
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        } else {
            showAlert(message: error!.localizedDescription)
        }
    }
    
    fileprivate func savePhoto(_ path: String) {
        let photo = Photo(context: dataController.viewContext)
        photo.path = path
        photo.id = UUID().uuidString
        photo.pin = pinnedAnnotation!.pin
        try? dataController.viewContext.save()
    }

}

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = listDataSource.fetchedCount(section: section)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
                as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = listDataSource.object(at: indexPath)
        
        photo.setToImage(cell.photoImageView)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listDataSource.deleteEntity(at: indexPath)
    }
}
