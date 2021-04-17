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
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = coordinate!
        
        photoAlbumMapView.addAnnotation(myPin)
        let center = CLLocationCoordinate2DMake(coordinate!.latitude, coordinate!.longitude)
        photoAlbumMapView.setCenter(center, animated: true)
    }

}
