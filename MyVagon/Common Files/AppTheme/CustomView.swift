//
//  CustomView.swift
//  MyVagon
//
//  Created by Apple on 13/12/21.
//

import Foundation
import UIKit
//MARK: ====== ViewCustomClass ======
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
class DottedLineView : UIView {
    @IBInspectable public var IsHorizontal: Bool = false
    override func awakeFromNib() {
        if IsHorizontal {
            self.addDashedBorderHorizontal()
        } else {
            self.addDashedBorderVertical()
        }
        
    }
}
class CornerView : UIView {
    override func awakeFromNib() {

        self.roundCorners(corners: [.topLeft,.bottomLeft], radius: self.frame.size.height / 2)
    }
}
