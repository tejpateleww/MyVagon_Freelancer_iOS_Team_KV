//
//  CustomButton.swift
//  MyVagon
//
//  Created by Apple on 13/12/21.
//

import Foundation
import UIKit


//MARK: ====== themeButton ======
class themeButton: UIButton {
    private var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    @IBInspectable public var IsSubmit : Bool = false
    @IBInspectable public var IsBlack : Bool = false
    @IBInspectable public var IsUnderline : Bool = false
    @IBInspectable public var IsRegualar : Bool = false
    @IBInspectable public var CornerRadiusForButton : CGFloat = 0.0
    @IBInspectable public var TextColor : UIColor = UIColor.white
    @IBInspectable public var FontSize : CGFloat = 16.0
    override func awakeFromNib() {
        super.awakeFromNib()
      
        if IsSubmit {
           
            self.backgroundColor = UIColor.appColor(ThemeColor.themeButtonBlue)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
        } else if IsBlack {
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.black, for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(14)
        } else if IsRegualar {
            
            self.setTitleColor(TextColor, for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(FontSize)
        }  else {
            
            self.setTitleColor(UIColor.appColor(ThemeColor.themeColorForButton), for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
        }
        if IsUnderline {
            self.setunderline(title: self.titleLabel?.text ?? "", color: UIColor.appColor(ThemeColor.themeButtonBlue), font: CustomFont.PoppinsMedium.returnFont(16))
        }
        self.layer.cornerRadius = CornerRadiusForButton
        
    }
    

    func showLoading() {
        originalButtonText = self.titleLabel?.text
        self.setTitle("", for: .normal)
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }

    func hideLoading() {
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}




class ThemeBidRequestButton : UIButton {
    
    @IBInspectable var isBorderTheme : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isBorderTheme == true {
            self.setTitleColor(hexStringToUIColor(hex: "#9B51E0"), for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(FontSize.size12.rawValue)
            self.layer.borderWidth = 1
            self.layer.borderColor = hexStringToUIColor(hex: "#9B51E0").cgColor
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
        else {
            self.setTitleColor(hexStringToUIColor(hex: "#D56969"), for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(FontSize.size14.rawValue)
            self.layer.borderWidth = 1
            self.layer.borderColor = hexStringToUIColor(hex: "#D56969").cgColor
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
        
    }
}
