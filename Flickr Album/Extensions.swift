//
//  Extensions.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation
import UIKit

// MARK: - UIView Extension
extension UIView {

  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1
    layer.shadowOpacity = 0.5
    layer.borderWidth = 1
    layer.borderColor = UIColor.FlickrAlbum_theme.cgColor
  }
}

// MARK: - UIColor Extension
extension UIColor {
    
    static let FlickrAlbum_theme = UIColor(hex: 0x416ED2)
    
    // Create a UIColor from RGB
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    // Create a UIColor from a hex value (E.g 0x000000)
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
}

// MARK: - UIFont Extension
extension UIFont {
    static let FlickAlbum_description = UIFont(name: "Helvetica Neue", size: 14)
    static let FlickAlbum_heading = UIFont(name: "Helvetica Neue Bold", size: 18.0)
}

extension String {

    func compare(_ with : String)->Bool{
        return self.caseInsensitiveCompare(with) == .orderedSame
    }
}
