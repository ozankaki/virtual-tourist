//
//  MKMapView+Extension.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 21.04.2021.
//

import Foundation
import MapKit

extension MKMapView {
    
    func addAnnotations(_ pins: [Pin]) {
        let annotations = pins.map { pin -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            return annotation
        }
        
        self.addAnnotations(annotations)
    }
}
