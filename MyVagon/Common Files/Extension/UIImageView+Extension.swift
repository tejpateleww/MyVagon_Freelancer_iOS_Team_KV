//
//  UIImageView+Extension.swift
//  Qwnched-Customer
//
//  Created by Hiral's iMac on 16/10/20.
//  Copyright © 2020 Hiral's iMac. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}


extension UIView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension UIView {

/// Remove UIBlurEffect from UIView
func removeBlurEffect() {
   let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
   blurredEffectViews.forEach{ blurView in
    blurView.removeFromSuperview()
  }
}
}


extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    func rounded(with color: UIColor, width: CGFloat) -> UIImage? {
        
        guard let cgImage = cgImage?.cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : .zero, y: isPortrait ? ((size.height-size.width)/2).rounded(.down) : .zero), size: breadthSize)) else { return nil }
        
        let bleed = breadthRect.insetBy(dx: -width, dy: -width)
        let format = imageRendererFormat
        format.opaque = false
        
        return UIGraphicsImageRenderer(size: bleed.size, format: format).image { context in
            UIBezierPath(ovalIn: .init(origin: .zero, size: bleed.size)).addClip()
            var strokeRect =  breadthRect.insetBy(dx: -width/2, dy: -width/2)
            strokeRect.origin = .init(x: width/2, y: width/2)
            UIImage(cgImage: cgImage, scale: 1, orientation: imageOrientation)
            .draw(in: strokeRect.insetBy(dx: width/2, dy: width/2))
            context.cgContext.setStrokeColor(color.cgColor)
            let line: UIBezierPath = .init(ovalIn: strokeRect)
            line.lineWidth = width
            line.stroke()
        }
    }
    
    func radiusImageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        var result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        result = result?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return result
    }
    
    func getImageSize() -> Float{
        if let imgData = self.jpegData(compressionQuality: 1){
            let nsData = NSData(data: imgData)
            return Float(nsData.count)
        }else{
            return 0
        }
    }

}

// Reference https://stackoverflow.com/questions/34262791/how-to-get-image-file-size-in-swift

extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> Double {

        guard let data = self.pngData() else {
            return 0.0
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }
        print("This is size of image from extnesion \(size) and this is float one \(size)")
        return Double(String(format: "%.2f", size)) ?? 0.0
    }
}



struct AppPlaceHolderImages{
    static let User = #imageLiteral(resourceName: "ic_Person")
    static let Gallary = #imageLiteral(resourceName: "ic_GallaryPls")
    static let Url = #imageLiteral(resourceName: "Ic_DeliveryPartnerPlaceHolder")
}

extension UIImageView{
    //MARK:- Set Sd Image
    func loadImage(url: String, placeHolder: UIImage = AppPlaceHolderImages.User, completion: ((UIImage) -> Void)? = nil){
        
        self.sd_setImage(with: URL(string: url), placeholderImage: placeHolder, options: .refreshCached) { (image, _, _, _) in
            if let obj = completion, let img = image{
                obj(img)
            }
        }
    }
}
