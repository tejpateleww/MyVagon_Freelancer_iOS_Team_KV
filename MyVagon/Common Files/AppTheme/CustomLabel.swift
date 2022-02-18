//
//  CustomLabel.swift
//  MyVagon
//
//  Created by Apple on 13/12/21.
//

import Foundation
import UIKit
class themeLabel: UILabel{
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
    @IBInspectable public var isBold: Bool = false
    @IBInspectable public var isSemibold: Bool = false
    @IBInspectable public var isLight: Bool = false
    @IBInspectable public var isMedium: Bool = false
    @IBInspectable public var isThemeColour : Bool = false
    @IBInspectable public var is50Oppacity : Bool = false
    @IBInspectable public var is8ppacity : Bool = false
    @IBInspectable public var IsMyVagonLogo : Bool = false
    @IBInspectable public var IsRoudned : Bool = false
    @IBInspectable public var fontColor: UIColor = .white

    override func awakeFromNib() {
        super.awakeFromNib()
        if IsMyVagonLogo {
            let myString = "MYVAGON"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:CustomFont.PoppinsSemiBold.returnFont(Font_Size)])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors.splashtitleColor.value, range: NSRange(location:0,length:2))
            self.attributedText = myMutableString
        } else {
            if isBold {
                self.font = CustomFont.PoppinsBold.returnFont(Font_Size)
            } else if isSemibold {
                self.font = CustomFont.PoppinsSemiBold.returnFont(Font_Size)
            } else if isMedium {
                self.font = CustomFont.PoppinsMedium.returnFont(Font_Size)
            } else if isLight {
                self.font = CustomFont.PoppinsLight.returnFont(Font_Size)
            } else {
                self.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
            }
          
        }
        if IsRoudned {
            self.layer.cornerRadius = self.frame.size.height / 2
        }
        
       
//        print(self.font.familyName)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if IsMyVagonLogo {
            
        } else {
            if is50Oppacity == true {
                self.textColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
            }
            else if is8ppacity == true {
                self.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.13)
            }
            else {
                 self.textColor = isThemeColour == true ? UIColor.appColor(ThemeColor.themeGold) : fontColor
            }
        }
        
       
    }
}
