//
//  ThemeShadow.swift
//  Danfo_Rider
//
//  Created by Hiral on 15/03/21.
//

import Foundation
import UIKit

final class innerShadow : UIView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
    }
//    private func addInnerShadow() {
//        let innerShadow = CALayer()
//        innerShadow.frame = bounds
//
//        // Shadow path (1pt ring around bounds)
//        let radius = self.frame.size.height/2
//        self.clipsToBounds = true
//        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: -3, dy:-3), cornerRadius:radius)
//        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
//
//
//        path.append(cutout)
//        innerShadow.shadowPath = path.cgPath
//        innerShadow.masksToBounds = true
//        // Shadow properties
//        innerShadow.shadowColor = UIColor.black.cgColor
//        innerShadow.shadowOffset = CGSize(width: -4, height: 3)
//        innerShadow.shadowOpacity = 0.7
//        innerShadow.shadowRadius = 3
//        innerShadow.cornerRadius = self.frame.size.height/2
//        layer.addSublayer(innerShadow)
//    }
  
}

final class outerShadow : UIView {
    private var shadowLayer: CAShapeLayer!
    @IBInspectable public var isRounded : Bool = false
    @IBInspectable public var Corner_Radius: CGFloat = 5.0
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .clear
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: isRounded ? (self.frame.size.height/2) : Corner_Radius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
            shadowLayer.shadowOpacity = 0.12
            shadowLayer.shadowRadius = 3.0
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
extension UIView{
    ///cornerRadius: CGFloat = 15.0, themeColor: UIColor = UIColor(red: 241/255, green: 243/255, blue: 246/255, alpha: 1.0)
    public func addSoftUIEffectForView(yellowBG : Bool) {
        self.layer.cornerRadius = 10//self.frame.height/2
        self.layer.masksToBounds = false
//        self.layer.shadowRadius = 2
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize( width: 2, height: 2)
//        self.layer.shadowColor = UIColor.black.cgColor//UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor
        
        self.layer.shadowColor = UIColor.yellow.cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = UIColor(hexString: "#303030").cgColor// UIColor.gray.cgColor//themeColor.cgColor
        shadowLayer.shadowColor = UIColor(white: 1, alpha: 0.2).cgColor
        shadowLayer.cornerRadius = 10 // self.frame.height/2
//        shadowLayer.shadowOffset = CGSize(width: -2.0, height: -2.0)
//        shadowLayer.shadowOpacity = 1
//        shadowLayer.shadowRadius = 2
        
        if yellowBG {
            shadowLayer.backgroundColor = UIColor(hexString: "#FECD00").cgColor
        }
       
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear, // curveLinear,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
                        
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
    
    func translationAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: .curveLinear, // curveLinear,
                       animations: { [weak self] in
//                        self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
//                        self?.transform = CGAffineTransform.init(translationX: 0, y: (self?.frame.height)!)
                        
                       }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .autoreverse,
                           animations: { [weak self] in
//                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        
//                            self?.transform = CGAffineTransform.init(translationX: 0, y: -(self?.frame.height)!)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
    
    func shake(duration: TimeInterval = 0.05, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - xValue, y: self.center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + xValue, y: self.center.y - yValue))
        self.layer.add(animation, forKey: "shake")
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
              let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
              let mask = CAShapeLayer()
              mask.path = path.cgPath
              layer.mask = mask
          }
    func roundCornerssingleSide(corners: CACornerMask) {
            self.isCircle()
              layer.maskedCorners = corners
          }
}
