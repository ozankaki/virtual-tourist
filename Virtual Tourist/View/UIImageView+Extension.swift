//
//  UIImageView+Extension.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import UIKit

extension UIImageView {

    func setImage(urlPath: String) {
        self.image = UIImage(named: "Placeholder")
        let url = URL(string: urlPath)!
        
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self!.image = image
                        }
                    }
                }
            }
        }
    }
}
