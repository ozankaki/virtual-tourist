//
//  MKCoordinateRegion+Extension.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 22.04.2021.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
  public func write(toDefaults defaults:UserDefaults, withKey key:String) {
    let locationData = [center.latitude, center.longitude,
                        span.latitudeDelta, span.longitudeDelta]
    defaults.set(locationData, forKey: key)
  }

  public static func load(fromDefaults defaults:UserDefaults, withKey key:String) -> MKCoordinateRegion? {
    guard let region = defaults.object(forKey: key) as? [Double] else { return nil }
    let center = CLLocationCoordinate2D(latitude: region[0], longitude: region[1])
    let span = MKCoordinateSpan(latitudeDelta: region[2], longitudeDelta: region[3])
    return MKCoordinateRegion(center: center, span: span)
  }
}
