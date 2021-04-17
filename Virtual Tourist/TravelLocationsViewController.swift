//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 17.04.2021.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController {

    @IBOutlet weak var travelLocationsMapView: MKMapView!
    var selectedCoordinate: CLLocationCoordinate2D?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoAlbumSegue" {
            guard let photoAlbumVC = segue.destination as? PhotoAlbumViewController else {
                return
            }
            
            photoAlbumVC.coordinate = selectedCoordinate
        }
    }
}

extension TravelLocationsViewController: MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        travelLocationsMapView.delegate = self
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 1.5
        
        travelLocationsMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.setSelected(false, animated: true)
        selectedCoordinate = view.annotation?.coordinate
        performSegue(withIdentifier: "showPhotoAlbumSegue", sender: nil)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }
        
        let location = gestureRecognizer.location(in: travelLocationsMapView)
        let myCoordinate: CLLocationCoordinate2D = travelLocationsMapView.convert(location, toCoordinateFrom: travelLocationsMapView)
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = myCoordinate
        
        travelLocationsMapView.addAnnotation(myPin)
    }
}
