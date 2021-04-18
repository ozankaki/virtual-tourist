//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import Foundation

class FlickrClient: BaseClient {
    
    static let apiKey = "a40fe040c503a13e36e2ab89e4b6447f"
    static let secretKey = "66e03ecb5df71247"
    
    enum Endpoints {
        static let base = "https://api.flickr.com/services/rest"
        static let apiKeyParam = "?api_key=\(FlickrClient.apiKey)"

        case searchPhotos(Double, Double)

        var path: String {
            switch self {
            case .searchPhotos(let latitude, let longitude): return "\(Endpoints.base)\(Endpoints.apiKeyParam)&method=flickr.photos.search&format=json&nojsoncallback=?&per_page=20&lat=\(latitude)&lon=\(longitude)"
            }
        }

        var url: URL {
            return URL(string: path)!
        }
    }
    
    func searchPhotos(latitude: Double, longitude: Double, completion: @escaping ([LocationPhoto], Error?) -> Void) {
        super.taskForGETRequest(url: Endpoints.searchPhotos(latitude, longitude).url, responseType: SearchResponse.self) { response, error in
            if response?.stat == "ok" {
                guard let photos = response?.photos else {
                    completion([], error)
                    return
                }
                
                var locationPhotos = [LocationPhoto]()
                for photo in photos.photo {
                    let locationPhoto = LocationPhoto(path: photo.imagePath)
                    locationPhotos.append(locationPhoto)
                }
                
                completion(locationPhotos, nil)
            } else {
                let errorResponse = response! as Error
                completion([], errorResponse)
            }
        }
    }
}
