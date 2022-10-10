//
//  CustomMarker.swift
//  MyVagon
//
//  Created by Tej P on 23/05/22.
//

import Foundation
import UIKit

class MarkerPinView: UIView {
    @IBInspectable var markerImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        let imageview = UIImageView()
        imageview.image = markerImage
        imageview.frame = self.frame
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(imageview)
    }
}

class MarkerCarView: UIView {
    @IBInspectable var markerImage: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let imageview = UIImageView()
        imageview.image = markerImage
        imageview.frame = self.frame
        imageview.contentMode = .scaleAspectFit
        imageview.clipsToBounds = true
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.addSubview(imageview)
    }
}
