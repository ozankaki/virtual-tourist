//
//  BaseClient.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import Foundation

class BaseClient: Loadable {

    func taskForGETRequest<ResponseType: Decodable>(
        url: URL, responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void) {
        startLoading()
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.stopLoading()
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    self.stopLoading()
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    self.stopLoading()
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
