//
//  CustomTextField.swift
//  MyVagon
//
//  Created by Apple on 13/12/21.
//

import Foundation
import UIKit
import SkyFloatingLabelTextField

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
class CurrencyTextField: themeTextfield, UITextFieldDelegate {
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //If using in SBs
        setup()
    }
    
    //6
    private func setup() {
//        self.textAlignment = .center
        self.keyboardType = .asciiCapableNumberPad
        self.contentScaleFactor = 0.5
        delegate = self

        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        //self.text = "\(Currency)0.00"
    }
    
    //AFTER entered string is registered in the textField
    @objc private func textFieldDidChange(textField:UITextField) {
        let cur = textField.text?.currencyInputFormatting()
        let trimmed = cur?.components(separatedBy: .whitespaces).joined(separator: "")
        textField.text = trimmed
        
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
