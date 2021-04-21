//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 17.04.2021.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController {

    @IBOutlet weak var travelLocationsMapView: MKMapView!
    var selectedCoordinate: CLLocationCoordinate2D?
    var dataController: DataController!
    var listDataSource: ListDataSource<Pin>!
    private let regionKey = "regionKey"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotoAlbumSegue" {
            guard let photoAlbumVC = segue.destination as? PhotoAlbumViewController else {
                return
            }
            
            photoAlbumVC.coordinate = selectedCoordinate
        }
    }
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        listDataSource = ListDataSource(managedObjectContext: dataController.viewContext, fetchRequest: fetchRequest, cacheName: "pins")
    }
    
    func handleDataSourceLoad() {
        guard let pins = listDataSource.objects() else {
            return
        }
        
        travelLocationsMapView.addAnnotations(pins)
    }
    
}

extension TravelLocationsViewController: MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        handleDataSourceLoad()
        prepareMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let region = MKCoordinateRegion.load(fromDefaults: UserDefaults.standard, withKey: regionKey) {
            travelLocationsMapView.region = region
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        travelLocationsMapView.region.write(toDefaults: UserDefaults.standard, withKey: regionKey)
    }
    
    fileprivate func prepareMapView() {
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
        
        savePin(myCoordinate.latitude, myCoordinate.longitude)
        addPinToMap(myCoordinate)
    }
    
    fileprivate func addPinToMap(_ coordinate: CLLocationCoordinate2D) {
        let myPin: MKPointAnnotation = MKPointAnnotation()
        myPin.coordinate = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        travelLocationsMapView.addAnnotation(myPin)
    }
    
    fileprivate func savePin(_ latitude: Double, _ longitude: Double) {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = latitude
        pin.longitude = longitude
        pin.id = UUID()
        try? dataController.viewContext.save()
    }
}
