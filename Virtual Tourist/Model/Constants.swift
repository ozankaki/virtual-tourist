//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 23.04.2021.
//

import Foundation

struct Constants {
    
    static let cancel = "Cancel"
    
    struct Flickr {
        static let apiKey = "a40fe040c503a13e36e2ab89e4b6447f"
        static let secretKey = "66e03ecb5df71247"
        static let totalPhotoLimit = 4000
        static let pagePhotoLimit = 20
    }
    
    struct Messages {
        static let alertTitle = "Opps.."
        static let noPhoto = "Sorry, no photos found in this location."
    }
    
    struct Error {
        static let notImplementedTitle = "Not Implemented"
        static let notImpleementedMessage = "Function not Implemented"
    }
}
