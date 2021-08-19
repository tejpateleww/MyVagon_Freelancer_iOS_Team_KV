//
//  UILabel+Extension.swift
//  MyVagon
//
//  Created by Apple on 18/08/21.
//

import Foundation
import UIKit
extension UILabel {
    func drawLineOnBothSides(labelWidth: CGFloat, color: UIColor) {

        let size = (self.text?.sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)))
        
        let widthOfString = size?.width ?? 0.0

        let height = CGFloat(0.6)

        let leftLine = UIView(frame: CGRect(x: 0, y: self.frame.height/2 - height/2, width: labelWidth/2 - widthOfString/2 - 40, height: height))
        leftLine.backgroundColor = color
        self.addSubview(leftLine)

        let rightLine = UIView(frame: CGRect(x: labelWidth/2 + widthOfString/2 + 40, y: self.frame.height/2 - height/2, width: labelWidth/2 - widthOfString/2 - 40, height: height))
        rightLine.backgroundColor = color
        self.addSubview(rightLine)
    }
}
