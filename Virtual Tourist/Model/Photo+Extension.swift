//
//  Photo+Extension.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 23.04.2021.
//

import UIKit

extension Photo {
    func setToImage(_ imageView: UIImageView) {
        imageView.image = UIImage(named: "Placeholder")
        let url = URL(string: self.path!)!
        
        if self.data == nil {
            if UIApplication.shared.canOpenURL(url) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        self.data = data
                        try? self.managedObjectContext?.save()
                        
                        self.setImage(imageView)
                    }
                }
            }
        } else {
            setImage(imageView)
        }
        
    }
    
    fileprivate func setImage(_ imageView: UIImageView) {
        if let image = UIImage(data: self.data!) {
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
    }
}
