//
//  LoadingView.swift
//  Virtual Tourist
//
//  Created by Ozan Kaki on 18.04.2021.
//

import UIKit

class LoadingView: UIActivityIndicatorView {
    func setupLayout(targetView: UIView) {
        targetView.isUserInteractionEnabled = false
        targetView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: targetView.frame.size.width).isActive = false
        heightAnchor.constraint(equalToConstant: targetView.frame.size.height).isActive = false
        centerYAnchor.constraint(equalTo: targetView.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: targetView.centerXAnchor).isActive = true
        
        setupLayout()
        startAnimating()
    }
    
    func setupLayout() {
        style = .large
        color = UIColor.blue
    }
}
