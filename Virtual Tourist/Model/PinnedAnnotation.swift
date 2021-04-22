//
//  MKPointAnnotation+Extension.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 22.04.2021.
//

import Foundation
import MapKit

class PinnedAnnotation: MKPointAnnotation {
    var pin: Pin!
    
    init(pin: Pin) {
        super.init()
        self.pin = pin
        self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
    }
    
}
