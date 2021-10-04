//
//  UIView+Extension.swift
//  MyVagon
//
//  Created by Apple on 16/08/21.
//

import Foundation
import UIKit
extension UIView {
    
//    @IBInspectable
//    var cornerRadius: CGFloat {
//      get {
//        return layer.cornerRadius
//      }
//      set {
//        layer.cornerRadius = newValue
//      }
//    }
    
    func isCircle() {
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
 var hairlineImageView: UIImageView? {
    return hairlineImageView(in: self)
}

 func hairlineImageView(in view: UIView) -> UIImageView? {
    if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
        return imageView
    }

    for subview in view.subviews {
        if let imageView = self.hairlineImageView(in: subview) { return imageView }
    }
    return nil
  }
}
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
