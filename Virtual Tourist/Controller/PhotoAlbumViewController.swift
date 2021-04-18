//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

    @IBOutlet weak var photoAlbumMapView: MKMapView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var coordinate: CLLocationCoordinate2D!
    var photos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        getLocationPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = coordinate!
        
        photoAlbumMapView.addAnnotation(myPin)
        let center = CLLocationCoordinate2DMake(coordinate!.latitude, coordinate!.longitude)
        photoAlbumMapView.setCenter(center, animated: true)
    }

    @IBAction func newCollectionTapped(_ sender: Any) {
        
    }
    
    func getLocationPhotos() {
        FlickrClient().searchPhotos(latitude: coordinate!.latitude, longitude: coordinate!.longitude, completion: handleGetLocationPhotos(result:error:))
    }
    
    func handleGetLocationPhotos(result: [Photo], error: Error?) {
        if error == nil {
            self.photos = result
            self.photoCollectionView.reloadData()
        } else {
            showAlert(message: error!.localizedDescription)
        }
    }
}

extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
                as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let path = photos?[indexPath.row].path else {
            return cell
        }
        
        cell.photoImageView.setImage(urlPath: path)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photos?.remove(at: indexPath.row)
        photoCollectionView.deleteItems(at: [indexPath])
    }
}
