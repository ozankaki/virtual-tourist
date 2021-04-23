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

        case searchPhotos(Double, Double, Int32)

        var path: String {
            switch self {
            case .searchPhotos(let latitude, let longitude, let pageCount): return """
                \(Endpoints.base)\(Endpoints.apiKeyParam)&method=flickr.photos.search&format=json\
                &nojsoncallback=?&per_page=20&lat=\(latitude)&lon=\(longitude)&page=\(getPageNumber(pageCount))
                """
            }
        }

        var url: URL {
            return URL(string: path)!
        }
    }
    
    fileprivate class func getPageNumber(_ pageCount: Int32) -> Int32 {
        if pageCount <= 1 {
            return 1
        }
        return (1...pageCount).randomElement()!
    }
    
    func searchPhotos(latitude: Double, longitude: Double, pageCount: Int32, completion: @escaping ([LocationPhoto], Int32, Error?) -> Void) {
        super.taskForGETRequest(url: Endpoints.searchPhotos(latitude, longitude, pageCount).url,
                                responseType: SearchResponse.self) { response, error in
            if response?.stat == "ok" {
                guard let photos = response?.photos else {
                    completion([], Int32.min, error)
                    return
                }
                
                completion(photos.photo, photos.pages, nil)
            } else {
                let errorResponse = response! as Error
                completion([], Int32.min, errorResponse)
            }
        }
    }
}
