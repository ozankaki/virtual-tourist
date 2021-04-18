//
//  SearchResponse.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension Photo {
    var imagePath: String {
        get {
            return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
        }
    }
}
