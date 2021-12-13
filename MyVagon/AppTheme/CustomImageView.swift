//
//  CustomImageView.swift
//  MyVagon
//
//  Created by Apple on 13/12/21.
//

import Foundation
import UIKit
class ThemeImageView: UIImageView {
    @IBInspectable var isBorder : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        if isBorder == true {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.appColor(ThemeColor.themeGold).cgColor
        }
    }
}
class RoundedImageView: UIImageView {
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
       
    }
}
