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
        let annotations = pins.map { pin -> PinnedAnnotation in
            let annotation = PinnedAnnotation(pin: pin)
            return annotation
        }
        
        self.addAnnotations(annotations)
    }
}
