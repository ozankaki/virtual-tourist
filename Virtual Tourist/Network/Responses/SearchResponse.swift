//
//  SearchResponse.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import Foundation

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let photos: Photos?
    let stat: String
    let code: Int?
    let message: String?
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int32
    let total: String
    let photo: [LocationPhoto]
}

// MARK: - Photo
struct LocationPhoto: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

extension LocationPhoto {
    var imagePath: String {
        return "https://live.staticflickr.com/\(server)/\(id)_\(secret)_q.jpg"
    }
}

extension SearchResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
