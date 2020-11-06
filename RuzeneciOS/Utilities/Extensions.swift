//
//  Extensions.swift
//  RuzeneciOS
//
//  Created by Petr Hracek on 27/10/2020.
//  Copyright © 2020 Petr Hracek. All rights reserved.
//

import Foundation
import AVKit
import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: [UIView]) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

func ResizeImage(image: UIImage, scaleToHeight: CGFloat) -> UIImage {
    let oldHeight = image.size.height
    let scaleFactor = scaleToHeight / oldHeight
    
    let newHeight = image.size.height * scaleFactor
    let newWidth = image.size.width * scaleFactor
    
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}
