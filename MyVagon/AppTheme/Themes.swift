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
import FSCalendar
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
    @IBInspectable public var IsUnderline : Bool = false
    @IBInspectable public var IsRegualar : Bool = false
    @IBInspectable public var CornerRadius : CGFloat = 0.0
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
        self.layer.cornerRadius = CornerRadius
        
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
        self.titleLabel?.font  =  CustomFont.PoppinsRegular.returnFont(14.0)
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
        label.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
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
        self.titleLabel?.font  = CustomFont.PoppinsRegular.returnFont(13.0)
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

        
        self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(13.0)
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
        self.titleLabel?.font  = CustomFont.PoppinsRegular.returnFont(16.0)
          
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
        self.font =  CustomFont.PoppinsRegular.returnFont(20.0)
        self.placeholderFont = CustomFont.PoppinsRegular.returnFont(20.0)
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
       
        self.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
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
        
        self.titleLabel?.font  = CustomFont.PoppinsSemiBold.returnFont(18.0)
       
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
        self.titleLabel?.font  = CustomFont.PoppinsSemiBold.returnFont(Font_Size)
     if isbordered {
        self.titleLabel?.font  = isSemibold == true ? CustomFont.PoppinsSemiBold.returnFont(Font_Size) : CustomFont.PoppinsRegular.returnFont(Font_Size)
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
        self.font = CustomFont.PoppinsRegular.returnFont(14)
        
    }
    
}






//MARK:- Gray theme Textfiled =======


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
    @IBInspectable public var CornerRadius: CGFloat = 0.0
    @IBInspectable public var Font_Size: CGFloat = FontSize.size15.rawValue
    @IBInspectable public var PlaceholderColor: UIColor = UIColor.appColor(ThemeColor.ThemePlaceHolderTextColor)
    @IBInspectable public var FontColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            if let image = rightImage {
                rightViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                
                imageView.tintColor = tintColor
                imageView.isUserInteractionEnabled = false
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 30, height: 20))
                view.isUserInteractionEnabled = false
                view.addSubview(imageView)
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
               
                let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.contentMode = .scaleAspectFit
                
                imageView.tintColor = tintColor
                imageView.isUserInteractionEnabled = false
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 30, height: 20))
                view.isUserInteractionEnabled = false
                view.addSubview(imageView)
                leftView = view
            }else{
                leftViewMode = .never
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = CornerRadius
        self.borderStyle = .none
        self.font = CustomFont.PoppinsRegular.returnFont(Font_Size)
    
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: PlaceholderColor] )
        self.textColor = FontColor
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        
        if LeftImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10 + 30, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        } else if rightImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 + 30)
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
        } else if rightImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 + 30)
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
        } else if rightImage != nil {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10 + 30)
            return bounds.inset(by: padding)
        } else {
            let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return bounds.inset(by: padding)
        }
        
    }
}

class ThemeViewRounded : UIView {
    @IBInspectable public var IsCustomBorder: Bool = false
    @IBInspectable public var borderWidth: CGFloat = 0.0
    @IBInspectable public var CornerRadius: CGFloat = 0.0
    @IBInspectable public var BorderColor: UIColor = .white
    override func awakeFromNib() {
        super.awakeFromNib()
        if IsCustomBorder {
            self.layer.borderColor = BorderColor.cgColor
            self.layer.borderWidth = borderWidth
            self.layer.cornerRadius = CornerRadius
            self.clipsToBounds = true
        } else {
            self.layer.borderColor = UIColor.black.withAlphaComponent(0.14).cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 0
            self.clipsToBounds = true
        
        }
        
    }
}

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

class ThemeButtonVerify : UIButton {
    
    @IBInspectable var isselectedbtn :  Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(isselectedbtn == true ? UIColor(hexString: "189B25"): UIColor.appColor(.themelightBlue), for: .normal)
         
        self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(16.0)
        }
      
    
    }

class GeneralPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var generalPickerDelegate: GeneralPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)


        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.generalPickerDelegate?.didTapDone()
    }

    
}
protocol GeneralPickerViewDelegate: AnyObject {
    func didTapDone()
    func didTapCancel()
}
class BlurView : UIView {
    
    @IBInspectable var isLight : Bool = false
    
    override func awakeFromNib() {
        self.backgroundColor = .clear
        setUpBlurView()
    }
    func setUpBlurView() {
        
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = .black
        }
        
   /*
        //        self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        
        //If iOS 13 is available, add blur effect:
        if #available(iOS 13.0, *) {
            //check if transparency is reduced in system accessibility settings..
            if UIAccessibility.isReduceTransparencyEnabled == true {
                
            } else {
                let backView = UIView(frame: self.bounds)
                backView.backgroundColor =  colors.submitButtonTextColor.value.withAlphaComponent(0.2)//UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)

                self.addSubview(backView)
                
                let blurEffect = UIBlurEffect(style: .dark)
                let bluredEffectView = UIVisualEffectView(effect: blurEffect)
                bluredEffectView.frame = self.bounds
                
                let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                vibrancyEffectView.frame = bluredEffectView.bounds
                
                bluredEffectView.layer.masksToBounds = true
                bluredEffectView.contentView.addSubview(vibrancyEffectView)
                self.addSubview(bluredEffectView)

                self.bringSubviewToFront(self)
                //self.bringSubviewToFront(vwMain)
            }
        } else {
            if UIAccessibility.isReduceTransparencyEnabled == true {
                
            } else {
                
                let backView = UIView(frame: self.bounds)
                backView.backgroundColor =  colors.submitButtonTextColor.value.withAlphaComponent(0.2) //UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)
                self.addSubview(backView)
                let blurEffect = UIBlurEffect(style: .dark)
                let bluredEffectView = UIVisualEffectView(effect: blurEffect)
                bluredEffectView.frame = self.bounds
                
                let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                vibrancyEffectView.frame = bluredEffectView.bounds
                
                bluredEffectView.layer.masksToBounds = true
                bluredEffectView.contentView.addSubview(vibrancyEffectView)
                self.addSubview(bluredEffectView)
                self.bringSubviewToFront(self)
               // self.view.bringSubviewToFront(vwMain)
            }
        }
        if isLight {
            if #available(iOS 13.0, *) {
                //check if transparency is reduced in system accessibility settings..
                if UIAccessibility.isReduceTransparencyEnabled == true {
                    
                } else {
                    let backView = UIView(frame: self.bounds)
                    backView.backgroundColor =  colors.submitButtonTextColor.value.withAlphaComponent(0.2)//UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)

                    self.addSubview(backView)
                    
                    let blurEffect = UIBlurEffect(style: .light)
                    let bluredEffectView = UIVisualEffectView(effect: blurEffect)
                    bluredEffectView.frame = self.bounds
                    
                    let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                    vibrancyEffectView.frame = bluredEffectView.bounds
                    
                    bluredEffectView.layer.masksToBounds = true
                    bluredEffectView.contentView.addSubview(vibrancyEffectView)
                    self.addSubview(bluredEffectView)

                    self.bringSubviewToFront(self)
                    //self.bringSubviewToFront(vwMain)
                }
            } else {
                if UIAccessibility.isReduceTransparencyEnabled == true {
                    
                } else {
                    
                    let backView = UIView(frame: self.bounds)
                    backView.backgroundColor =  colors.submitButtonTextColor.value.withAlphaComponent(0.2) //UIColor(red: 8/255, green: 93/255, blue: 127/255, alpha: 0.67)
                    self.addSubview(backView)
                    let blurEffect = UIBlurEffect(style: .light)
                    let bluredEffectView = UIVisualEffectView(effect: blurEffect)
                    bluredEffectView.frame = self.bounds
                    
                    let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
                    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
                    vibrancyEffectView.frame = bluredEffectView.bounds
                    
                    bluredEffectView.layer.masksToBounds = true
                    bluredEffectView.contentView.addSubview(vibrancyEffectView)
                    self.addSubview(bluredEffectView)
                    self.bringSubviewToFront(self)
                   // self.view.bringSubviewToFront(vwMain)
                }
            }
        }
        
       
       */
    }
}
class ThemeView : UIView {
    @IBInspectable var CornerRadius : CGFloat = 0.0
    override func awakeFromNib() {
        self.layer.cornerRadius = CornerRadius
        self.clipsToBounds = true
    }
}
class SeperatorView : UIView {
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hexString: "#D2D2D9")
    }
}
class dashedLineView : UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.lightGray.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: self.bounds.minX, y: self.bounds.minY), CGPoint(x: self.bounds.maxX, y: self.bounds.minY)])
            shapeLayer.path = path
            self.layer.addSublayer(shapeLayer)
        }
    
}

@IBDesignable class DottedVertical: UIView {

    @IBInspectable var dotColor: UIColor = UIColor(hexString: "#9A9AA9")
    @IBInspectable var lowerHalfOnly: Bool = false

    override func draw(_ rect: CGRect) {

        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 8 + 8 - 1
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)

        let path = UIBezierPath()

        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)

        path.move(to: top)
        path.addLine(to: bottom)

        path.lineWidth = width
        //DASHED SIMPLE LINE
        //let dashes: [CGFloat] = [itemLength, itemLength]
        //path.setLineDash(dashes, count: dashes.count, phase: 0)

        // for ROUNDED dots, simply change to....
        let dashes: [CGFloat] = [0.0, itemLength * 1.1]
        path.lineCapStyle = CGLineCap.round
        path.setLineDash(dashes, count: dashes.count, phase: 0)

        dotColor.setStroke()
        path.stroke()
    }
}
class ThemeCalender : FSCalendar {
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hexString: "#F7F1FD")
        //UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
//        self.frame = CGRect(x: 100, y: 0, width: self.frame.width, height: self.frame.height)
        self.calendarHeaderView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        self.calendarWeekdayView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        self.appearance.todaySelectionColor = UIColor.appColor(.themeColorForButton)
        
        self.appearance.headerTitleColor = UIColor(hexString: "#1F1F41")
        self.appearance.headerTitleFont = CustomFont.PoppinsRegular.returnFont(14.0)
        self.appearance.titleFont = CustomFont.PoppinsRegular.returnFont(12.0)
        self.appearance.weekdayFont = CustomFont.PoppinsMedium.returnFont(12.0)
        self.appearance.selectionColor = UIColor.appColor(.themeColorForButton);      self.appearance.titleSelectionColor = colors.white.value

        self.appearance.headerDateFormat = "MMMM, yyyy"
        self.appearance.headerMinimumDissolvedAlpha = 0.0
     
        self.scope = .week
        self.firstWeekday = 1
       // self.weekdayHeight = 40
        self.weekdayHeight = 40
        self.headerHeight = 30
        self.rowHeight = 40
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
    }
}
class MyProfileTextField : SkyFloatingLabelTextField {
    override func awakeFromNib() {
        self.lineColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
        self.titleColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
                self.lineHeight = 1.0
                self.selectedTitleColor = colors.black.value
                self.selectedLineColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
        //        self.placeHolderColor = colors.textfieldColor.value
                self.textColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1)
                self.titleFormatter = { $0 }
        self.titleFont = CustomFont.PoppinsRegular.returnFont(10)
        self.font = CustomFont.PoppinsRegular.returnFont(12)
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
