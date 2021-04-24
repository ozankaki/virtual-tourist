//
//  UIViewController.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 19.04.2021.
//

import UIKit

extension UIViewController {

    func showAlert(title: String = Constants.Messages.alertTitle, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil ))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}
