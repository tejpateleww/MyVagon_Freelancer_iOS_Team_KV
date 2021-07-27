//
//  Themes.swift
//  Danfo_Rider
//
//  Created by Hiral on 15/03/21.
//

import Foundation
import UIKit
import CountryPickerView
import SkyFloatingLabelTextField

//==========================
//MARK: ====== Button ======
//==========================


class themButtonNext: UIButton {
    
    @IBInspectable public var Font_Size: CGFloat = FontSize.size19.rawValue
    @IBInspectable public var isbordered: Bool = false
    @IBInspectable public var background : UIColor = UIColor.appColor(ThemeColor.themeButtonBlue)
    @IBInspectable public var fontColor: UIColor = .white
    @IBInspectable public var radius: CGFloat = 0.0
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = fontColor
    }
    
}

class themeButton: UIButton {
    @IBInspectable public var IsSubmit : Bool = false
    @IBInspectable public var IsBlack : Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if IsSubmit {
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            self.backgroundColor = UIColor.appColor(ThemeColor.themeButtonBlue)
            self.setTitleColor(UIColor.white, for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
        } else if IsBlack {
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.black, for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        } else {
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.appColor(ThemeColor.themeColorForButton), for: .normal)
            self.titleLabel?.font = CustomFont.PoppinsBold.returnFont(16)
        }
        
    }
}




//class themeButton: UIButton {
//
//    @IBInspectable public var Font_Size: CGFloat = FontSize.size19.rawValue
//    @IBInspectable public var isGoldBG_shadow: Bool = false
//    @IBInspectable public var isbordered: Bool = false
//    @IBInspectable public var radius: CGFloat = 0.7
//    @IBInspectable public var background : UIColor = UIColor.appColor(ThemeColor.themeButtonBlue)
//    @IBInspectable public var fontColor: UIColor = .white
//    @IBInspectable public var isBlackBorder: Bool = false
//    @IBInspectable public var isSemibold : Bool = false
//
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.tintColor = fontColor
//        self.titleLabel?.font  = isSemibold == true ? FontBook.semibold.of(size: Font_Size) : FontBook.regular.of(size: Font_Size)
//
//
//
//     if isbordered {
//            self.setTitleColor(isBlackBorder == true ? .black : .white, for: .normal)
//            self.backgroundColor = .clear
//            self.titleLabel?.font  = isSemibold == true ? FontBook.semibold.of(size: Font_Size) : FontBook.regular.of(size: Font_Size)
//            self.layer.borderColor =  isBlackBorder == true ? UIColor.black.cgColor : UIColor.white.cgColor
//        self.layer.borderWidth = 1.0
//            self.layer.cornerRadius = 10
//
//        }else{
//            self.layer.cornerRadius = radius
//            self.backgroundColor = background
//        }
//    }
//}
//

class ThemeCompleteButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
            self.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.23), for: .normal)
            self.backgroundColor = .clear
            self.titleLabel?.font  =  FontBook.regular.of(size: 14.0)
            self.layer.borderColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.23).cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 10
            

    }
}




class themeWhiteRoundBtn : UIButton {
    
    @IBInspectable var isRed : Bool = false
    @IBInspectable var isCornerRound : Bool = false
    override func awakeFromNib() {
           super.awakeFromNib()
        self.layer.cornerRadius = isCornerRound == true ? 8 : self.frame.height / 2
           self.clipsToBounds = true
        self.backgroundColor = isRed == true ? UIColor(hexString: "C94B4B") : .white
        
       }
       
}

class themeCustomShadowButton : UIControl {
    @IBInspectable public var front_image: UIImage = UIImage(named: "s") ?? UIImage()
    @IBInspectable public var Font_Size: CGFloat = FontSize.size19.rawValue
    @IBInspectable public var fontColor: UIColor = UIColor.appColor(.themeGold)
    @IBInspectable public var Title: String = ""
    @IBInspectable public var isYellowBG : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSoftUIEffectForView(yellowBG: isYellowBG)
        
        let imageView = UIImageView(image: front_image)
//        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width - 10, height: self.frame.height - 10)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.addSubview(imageView)
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: imageView.frame.width - 10, height: imageView.frame.height - 10))
        label.text = Title
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.font = FontBook.regular.of(size: Font_Size)
        label.textColor = fontColor
        imageView.addSubview(label)
        
        if isYellowBG {
            label.textColor = .black
        }
        
        
    }
}

class ThemeGrayButton : UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.backgroundColor =  UIColor(hexString: "414141")
        self.titleLabel?.font  = FontBook.regular.of(size: 13.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1.0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        
        
    }
}

class CustomShadowButton: UIButton {

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!

        backgroundColor =  UIColor(hexString: "#707070")
        
    }

    override func draw(_ rect: CGRect) {
        updateLayerProperties()
    }

    func updateLayerProperties() {
        layer.masksToBounds = true
        layer.cornerRadius = self.frame.height / 2

        //superview is your optional embedding UIView
        if let superview = superview {
            superview.backgroundColor = UIColor.clear
            superview.layer.shadowColor = UIColor.darkGray.cgColor
            superview.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 12.0).cgPath
            superview.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            superview.layer.shadowOpacity = 0.5
            superview.layer.shadowRadius = 2
            superview.layer.masksToBounds = true
            superview.clipsToBounds = false
        }
    }

}


class ThemeGradientButton: UIButton {

 
    public let buttongradient: CAGradientLayer = CAGradientLayer()

    override var isSelected: Bool {  // or isHighlighted?
        didSet {
            updateGradientColors()
        }
    }

    func updateGradientColors() {
        let colors: [UIColor]

        
        self.titleLabel?.font = FontBook.regular.of(size:13.0)
        self.setTitleColor(UIColor.white, for: .normal)
        colors = [UIColor(hexString: "2F2F2F") , UIColor(hexString: "414141")]
        
        buttongradient.colors = colors.map { $0.cgColor }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateGradient()
    }

    func setupGradient() {
        buttongradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        buttongradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.insertSublayer(buttongradient, at: 0)

        updateGradientColors()
    }

    func updateGradient() {
        buttongradient.frame = self.bounds
       
    }
}



//==========================
//MARK: === Label ===
//==========================

//class themeLabel: UILabel{
//    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
//    @IBInspectable public var isBold: Bool = false
//    @IBInspectable public var isSemibold: Bool = false
//    @IBInspectable public var isLight: Bool = false
//    @IBInspectable public var fontColor: UIColor = .white
//    @IBInspectable public var isThemeColour : Bool = false
//    @IBInspectable public var is50Oppacity : Bool = false
//    @IBInspectable public var is8ppacity : Bool = false
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.font = isBold ? FontBook.bold.of(size : Font_Size) :
//            (isSemibold ? FontBook.semibold.of(size : Font_Size)  :
//                (isLight ? FontBook.light.of(size : Font_Size) : FontBook.regular.of(size : Font_Size) ))
//
////        print(self.font.familyName)
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if is50Oppacity == true {
//            self.textColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
//        }
//        else if is8ppacity == true {
//            self.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha:0.13)
//        }
//        else {
//             self.textColor = isThemeColour == true ? UIColor.appColor(ThemeColor.themeGold) : fontColor
//        }
//
//    }
//}

//==========================
//MARK: === Textfield ===
//==========================

//class themeTextfield : UITextField{
//    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        self.font = FontBook.regular.of(size : Font_Size)
//        self.textColor = .white
//    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "themeTextfield Error",
//                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
//    }
//}


class ThemeUnderLineButton : UIButton {
    
    @IBInspectable public var Btntitle : String = ""
    
    
    override func awakeFromNib() {
        
       super.awakeFromNib()
         guard let title = title(for: .normal) else { return }
        
        self.titleLabel?.textColor =  .white
        self.titleLabel?.font  = FontBook.regular.of(size: FontSize.size16.rawValue)
          
          let titleString = NSMutableAttributedString(string: title)
         titleString.addAttribute(
          .underlineStyle,
          value: NSUnderlineStyle.single.rawValue,
          range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(titleString, for: .normal)
    
    }
    
}



class ThemeSkyTextfield : SkyFloatingLabelTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.font =  FontBook.regular.of(size : FontSize.size20.rawValue)
        self.placeholderFont = FontBook.regular.of(size : FontSize.size20.rawValue)
        self.lineColor = UIColor.clear
        self.selectedLineColor = UIColor.clear
        self.selectedTitleColor = UIColor.appColor(.themeGrayText)
        self.titleColor = UIColor.appColor(.themeGrayText)
            //UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        self.placeholderColor = UIColor.white
        self.textColor = UIColor.white
        
    }
}
class themeVehicleDetailTextfield : UITextField{
    
     @IBInspectable public var Font_Size: CGFloat = FontSize.size14.rawValue
     @IBInspectable public var isThemeClr: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.font = FontBook.regular.of(size : Font_Size)
        self.textColor = isThemeClr == true ? UIColor.appColor(.themeGold) : .white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white] )
    }
}


//class ThemeGradientView : GradientView {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//         self.layer.cornerRadius = 12
//         self.clipsToBounds = true
//    }
//}


class ThemeBGView : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hexString: "#2A2A2A")
        
    }
}



class ThemViewLight50OppacityView : UIView {
    
     @IBInspectable var is8Oppacity:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: is8Oppacity == true ? 0.13 : 0.5)
        
    }
}


class ThemeTripHistorySelectdBtn : UIButton {
    @IBInspectable var selectdBtn : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if selectdBtn == true{
            self.setTitleColor(UIColor.appColor(.themeSolidGray), for: .normal)
        }
        else {
            self.setTitleColor(UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 0.5), for: .normal)
        }
        
        self.titleLabel?.font  = FontBook.semibold.of(size:FontSize.size18.rawValue)
       
        self.backgroundColor = .clear
       
    }
    
}

class ThemeLightBlackButton : UIButton {
    
    @IBInspectable var isRound : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.layer.cornerRadius = isRound == true ? self.frame.height / 2 : 20
        self.clipsToBounds = true
    }
}


class ThemeBlackView : UIView {
    
    @IBInspectable var isThemeClr : Bool = false
    @IBInspectable var isRound : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if isThemeClr == true {
            self.layoutIfNeeded()
            self.backgroundColor = UIColor.clear
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.appColor(.themeGold).cgColor
            self.layer.cornerRadius =  isRound == true ? self.frame.height / 2 : 33
            self.clipsToBounds = true
        }
        else {
            self.backgroundColor = UIColor.black
            self.layer.cornerRadius = isRound == true ? self.frame.height / 2 : 20
            self.clipsToBounds = true
        }
        
    }
}

class viewThemeSlider : UIView {
    override func awakeFromNib() {
      super.awakeFromNib()
        self.backgroundColor = UIColor(hexString: "#C3CDD6")
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
    }

}

class themeRoundedCornerButton: UIButton {
    
    @IBInspectable public var Font_Size: CGFloat = FontSize.size14.rawValue
    @IBInspectable public var isbordered: Bool = false
    @IBInspectable public var radius: CGFloat = 0.7
    @IBInspectable public var background : UIColor = UIColor.appColor(ThemeColor.themeGold)
    @IBInspectable public var fontColor: UIColor = .white
    @IBInspectable public var isSemibold : Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.tintColor = fontColor
        self.titleLabel?.font  = FontBook.semibold.of(size: Font_Size)
     if isbordered {
        self.titleLabel?.font  = isSemibold == true ? FontBook.semibold.of(size: Font_Size) : FontBook.regular.of(size: Font_Size)
            self.backgroundColor = .clear
            self.layer.borderColor = UIColor.white.cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 12
            
        }else{
            self.layer.cornerRadius = radius
            self.backgroundColor = background
        }
    }
}



class ThemeVehicleRoundView : UIView {
    @IBInspectable var radius10 : Bool = false
    override func awakeFromNib() {
      super.awakeFromNib()
        self.layer.cornerRadius = radius10 == true ? 10 : 20
        self.clipsToBounds = true
        
    }

}

class ThemevehicleDetailLbl : UILabel {
    override func awakeFromNib() {
         super.awakeFromNib()
        
        self.textColor = UIColor.white
        self.font = FontBook.regular.of(size : FontSize.size14.rawValue)
        
    }
    
}

class ThemeLightText : UILabel {
        @IBInspectable public var Font_Size: CGFloat = FontSize.size14.rawValue
        @IBInspectable public var isBold: Bool = false
        @IBInspectable public var isSemibold: Bool = false
        @IBInspectable public var isLight: Bool = false
        @IBInspectable public var fontColor: UIColor = UIColor.appColor(ThemeColor.themeLightGrayText)
        
        override func awakeFromNib() {
            super.awakeFromNib()
            self.font = isBold ? FontBook.bold.of(size : Font_Size) :
                (isSemibold ? FontBook.semibold.of(size : Font_Size)  :
                    (isLight ? FontBook.light.of(size : Font_Size) : FontBook.regular.of(size : Font_Size)))
           
    //        print(self.font.familyName)
        }
        override func layoutSubviews() {
            super.layoutSubviews()
            self.textColor = fontColor
           
        }
}


class themeDetinationlabel : UILabel {
    
      @IBInspectable public var isSemibold: Bool = false
     override func awakeFromNib() {
        super.awakeFromNib()
      
        if isSemibold == true {
            self.font = FontBook.regular.of(size : 18.0)
            self.textColor = .white
           
        }
        else {
            self.font = FontBook.regular.of(size : 16.0)
             self.textColor =  UIColor(hexString: "#7F7F7F")
        }
    }
}

//MARK:- Gray theme Textfiled =======
class GraythemeTextfield : UITextField{
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
    @IBInspectable public var isWhitePlaceHolder : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.font = FontBook.regular.of(size : Font_Size)
        self.textColor = .white
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "themeTextfield Error",
                                                        attributes: [NSAttributedString.Key.foregroundColor: isWhitePlaceHolder == true ? UIColor.white : UIColor.appColor(ThemeColor.themeLightGrayText)] )
    }
}


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

class CustomDarkRoundView: ViewCustomClass {
       
        override func awakeFromNib() {
            super.awakeFromNib()
            
            
            DispatchQueue.main.async {
                self.layoutIfNeeded()
                self.layer.shadowColor = UIColor.black.cgColor
                self.shadowRadius = 8
                self.backgroundColor = UIColor.appColor(.themeDarkGray)
                self.roundCorners(corners: [.topLeft, .topRight], radius: 40)
                self.clipsToBounds = true
            }
    }
     
}

class ThemeChatReceiverView: UIView {
    override func awakeFromNib() {
            super.awakeFromNib()
            
            
            DispatchQueue.main.async {
                self.layoutIfNeeded()
                self.roundCorners(corners: [.topLeft, .topRight , .bottomRight], radius: 5)
                self.clipsToBounds = true
            }
    }
}


class ThemeChatSenderView: UIView {
    override func awakeFromNib() {
            super.awakeFromNib()
            
            
            DispatchQueue.main.async {
                self.layoutIfNeeded()
                self.roundCorners(corners: [.topLeft, .topRight , .bottomLeft], radius: 5)
                self.clipsToBounds = true
            }
    }
}





class CustomGrayroundView : UIView {
    
    @IBInspectable var isBGColour : Bool = false
    @IBInspectable var isCircleCorner : Bool = false
    @IBInspectable var isTopRoundView : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = isBGColour == true ? UIColor.appColor(ThemeColor.themeLightBG) : UIColor.clear
        if isTopRoundView == true {
           
            DispatchQueue.main.async {
                 self.layoutIfNeeded()
                 self.backgroundColor = UIColor.appColor(ThemeColor.themeLightBG)
                  self.roundCorners(corners: [.topLeft, .topRight], radius: 40)
            }
          
        }
        else if isCircleCorner == true {
           self.layer.cornerRadius = self.layer.frame.height / 2
        }
        else {
            self.layer.cornerRadius = 8
        }
        
        self.clipsToBounds = true
//        self.layer.borderColor = UIColor.white.cgColor
//        self.layer.borderWidth = 1.0
    }
}



class ViewCustomClass: UIView {

 

 @IBInspectable
 var shadowOffset: CGSize {
     get {
         return layer.shadowOffset
     }
     set {
         layer.shadowOffset = newValue
         layer.masksToBounds = false
     }
 }

 @IBInspectable
 var shadowRadius: CGFloat {
     get {
         return layer.shadowRadius
     }
     set {
         layer.shadowRadius = newValue
         layer.masksToBounds = false
     }
 }

 @IBInspectable
   var borderWidth: CGFloat {
       get {
           return layer.borderWidth
       }
       set {
           layer.borderWidth = newValue
           layer.masksToBounds = false
       }
   }


 @IBInspectable
  var borderColor: UIColor? {
      get {
          if let color = layer.borderColor {
              return UIColor(cgColor: color)
          }
          return nil
      }
      set {
          if let color = newValue {
              layer.borderColor = color.cgColor
              layer.masksToBounds = false
          } else {
              layer.borderColor = nil
          }
      }
  }

 @IBInspectable
 var shadowColor: UIColor? {
     get {
         if let color = layer.shadowColor {
             return UIColor(cgColor: color)
         }
         return nil
     }
     set {
         if let color = newValue {
             layer.shadowColor = color.cgColor
             layer.masksToBounds = false
         } else {
             layer.shadowColor = nil
         }
     }
 }

 @IBInspectable
 var shadowOpacity: Float {
     get {
         return layer.shadowOpacity
     }
     set {
         layer.shadowOpacity = newValue
         layer.masksToBounds = false
     }
 }

 @IBInspectable
   var cornerRadius: CGFloat {
     get {
         return layer.cornerRadius
     }
     set {
         layer.cornerRadius = newValue
     }
 }
 
 

 }



class GradientView:  ViewCustomClass{

    @IBInspectable var startColor:   UIColor = UIColor.appColor(.ThemeGradientBlack1) { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor.appColor(.themeSolidGray) { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}

    @IBInspectable override var cornerRadius: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
           }
       }

    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }

    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

class themeTextfield : UITextField{
    
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = .always
                let button = UIButton(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
                //let imageView = UIImageView(frame: )
                button.setImage(image, for: .normal)

                button.contentMode = .scaleAspectFit
                button.tintColor = tintColor
                button.isUserInteractionEnabled = false
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 30, height: 20))
                view.isUserInteractionEnabled = false
                view.addSubview(button)
                rightView = view
            }else{
                rightViewMode = .never
            }
        }
    }

    @IBInspectable var LeftImage: UIImage? {
        didSet {
            if let image = LeftImage {
              //  SetLeftImage(image: image)
                leftViewMode = .always
                let button = UIButton(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
                //let imageView = UIImageView(frame: )
                button.setImage(image, for: .normal)

                button.contentMode = .scaleAspectFit
                button.tintColor = tintColor
                button.isUserInteractionEnabled = false
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 40, height: 20))
                view.isUserInteractionEnabled = false
                view.addSubview(button)
                leftView = view
            }else{
                leftViewMode = .never
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.font = FontBook.regular.of(size : Font_Size)
        
//        self.layer.cornerRadius = 10
        //self.clipsToBounds = true
       // self.layer.borderWidth = 1
        
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(ThemeColor.ThemePlaceHolderTextColor)] )
        
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }
}

class ThemeViewRounded : UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.40).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    
    }
}

class themeLabel: UILabel{
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
    @IBInspectable public var isBold: Bool = false
    @IBInspectable public var isSemibold: Bool = false
    @IBInspectable public var isLight: Bool = false
    @IBInspectable public var fontColor: UIColor = .white
    @IBInspectable public var isThemeColour : Bool = false
    @IBInspectable public var is50Oppacity : Bool = false
    @IBInspectable public var is8ppacity : Bool = false
    @IBInspectable public var IsMyVagonLogo : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        if IsMyVagonLogo {
            let myString = "MYVAGON"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString, attributes: [NSAttributedString.Key.font:CustomFont.PoppinsSemiBold.returnFont(24.0)])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: colors.splashtitleColor.value, range: NSRange(location:0,length:2))
            self.attributedText = myMutableString
        } else {
            self.textColor = UIColor.black
            self.font = isBold ? FontBook.bold.of(size : Font_Size) :
                (isSemibold ? FontBook.semibold.of(size : Font_Size)  :
                    (isLight ? FontBook.light.of(size : Font_Size) : FontBook.regular.of(size : Font_Size) ))
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

class ThemeButtonVerify : UIButton {
    
    @IBInspectable var isselectedbtn :  Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(isselectedbtn == true ? UIColor(hexString: "189B25"): UIColor.appColor(.themelightBlue), for: .normal)
         
        self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(16.0)
        }
      
    
    }

