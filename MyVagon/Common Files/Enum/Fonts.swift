//
//  Fonts.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//
//
import Foundation
import UIKit





enum CustomFont
{
    case PoppinsThinItalic,PoppinsBold,PoppinsLight,PoppinsMedium,PoppinsRegular,PoppinsSemiBold,PoppinsItalic,PoppinsLightItalic
  //  PoppinsBlack,PoppinsBlackItalic,,Poppins-BoldItalic,Poppins-ExtraBold,Poppins-ExtraBoldItalic,Poppins-ExtraLight,Poppins-ExtraLightItalic,Poppins-Italic,Poppins-Light,Poppins-LightItalic,Poppins-Medium,Poppins-MediumItalic,Poppins-Regular,Poppins-SemiBold,Poppins-SemiBoldItalic,Poppins-Thin,
    func returnFont(_ font:CGFloat)->UIFont
    {
        switch self
        {
        
        
        case .PoppinsThinItalic:
                return UIFont(name: "Poppins-ThinItalic", size: font)!
        
        case .PoppinsBold:
                return UIFont(name: "Poppins-Bold", size: font)!
        
        case .PoppinsLight:
                return UIFont(name: "Poppins-Light", size: font)!
        
        case .PoppinsMedium:
                return UIFont(name: "Poppins-Medium", size: font)!
        
        case .PoppinsRegular:
                return UIFont(name: "Poppins-Regular", size: font)!
        
        case .PoppinsSemiBold:
                return UIFont(name: "Poppins-SemiBold", size: font)!
        
        case .PoppinsItalic:
                return UIFont(name: "Poppins-Italic", size: font)!
        case .PoppinsLightItalic:
                return UIFont(name: "Poppins-LightItalic", size: font)!
        
        }
        
      /*
        <key>UIAppFonts</key>
                <array>
                    <string>Poppins-Black.ttf</string>
                    <string>Poppins-BlackItalic.ttf</string>
                    <string>Poppins-Bold.ttf</string>
                    <string>Poppins-BoldItalic.ttf</string>
                    <string>Poppins-ExtraBold.ttf</string>
                    <string>Poppins-ExtraBoldItalic.ttf</string>
                    <string>Poppins-ExtraLight.ttf</string>
                    <string>Poppins-ExtraLightItalic.ttf</string>
                    <string>Poppins-Italic.ttf</string>
                    <string>Poppins-Light.ttf</string>
                    <string>Poppins-LightItalic.ttf</string>
                    <string>Poppins-Medium.ttf</string>
                    <string>Poppins-MediumItalic.ttf</string>
                    <string>Poppins-Regular.ttf</string>
                    <string>Poppins-SemiBold.ttf</string>
                    <string>Poppins-SemiBoldItalic.ttf</string>
                    <string>Poppins-Thin.ttf</string>
                    <string>Poppins-ThinItalic.ttf</string>
                    </array>
        
         */
        
        
    }
}

enum FontsSize
{
    static let ExtraLarge : CGFloat = 40
    static let Large : CGFloat = 33
    static let MediumLarge : CGFloat = 26
    static let Medium : CGFloat = 25
    static let Regular : CGFloat = 18
    static let Small : CGFloat = 16
    static let ExtraSmall : CGFloat = 15
    static let Tiny :CGFloat = 14
}

extension UIFont
{
    class func regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Regular", size: size)!
    }
    
    class func medium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Medium", size: size)!
    }
    
    class func bold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Ubuntu-Bold", size: size)!
    }
}

