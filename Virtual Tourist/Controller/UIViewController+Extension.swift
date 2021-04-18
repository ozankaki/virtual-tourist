//
//  UIViewController.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 19.04.2021.
//

import UIKit

extension UIViewController {

    func showAlert(title: String = "Oops..", message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        present(alert, animated: true, completion: nil)
    }

}
