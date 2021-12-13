//
//  String+Extensions.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
extension String{
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
    var trimmedString: String { return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
    
    var length: Int { return self.trimmedString.count}
    
    //MARK: -  ================================
    //MARK: URL Encoding
    //MARK: ==================================
    func urlencoding() -> String {
        var output: String = ""
        
        for thisChar in self {
            if thisChar == " " {
                output += "+"
            }
            else if thisChar == "." ||
                thisChar == "-" ||
                thisChar == "_" ||
                thisChar == "~" ||
                (thisChar >= "a" && thisChar <= "z") ||
                (thisChar >= "A" && thisChar <= "Z") ||
                (thisChar >= "0" && thisChar <= "9") {
                let code = String(thisChar).utf8.map{ UInt8($0) }[0]
                output += String(format: "%c", code)
            }
            else {
                let code = String(thisChar).utf8.map{ UInt8($0) }[0]
                output += String(format: "%%%02X", code)
            }
        }
        return output;
    }
    
    //MARK: -  ================================
    //MARK: Contains Alphabets
    //MARK: ==================================
    func containsAlphabets() -> Bool {
        var iscontain : Bool = false
        let characterSet = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyz")
        if self.count > 1 {
            for character in self.lowercased() {
                let string = String.init(character)
                if string.rangeOfCharacter(from: characterSet) != nil {
                    iscontain = true
                    break
                }
            }
        }
        else {
            if self.rangeOfCharacter(from: characterSet) != nil {
                iscontain = true
            }
            else {
                iscontain = false
            }
        }
        return iscontain
    }
    
    //MARK: -  ================================
    //MARK: Contains Numbers
    //MARK: ==================================
    func containsNumbers() -> Bool {
        var iscontain : Bool = false
        let characterSet = CharacterSet(charactersIn:"0123456789")
        if self.count > 1 {
            for character in self {
                let string = String.init(character)
                if string.rangeOfCharacter(from: characterSet) != nil {
                    iscontain = true
                    break
                }
            }
        }
        else {
            if self.rangeOfCharacter(from: characterSet) != nil {
                iscontain = true
            }
            else {
                iscontain = false
            }
        }
        return iscontain
    }
    
    //MARK: -  ================================
    //MARK: Convert String to Dictionary
    //MARK: ==================================
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                Utilities.printOutput(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK: -  ================================
    //MARK: Check if string is Image
    //MARK: ==================================
    public func isImageFromString() -> Bool {
        // Add here your image formats.
        let imageFormats = ["jpg",
                            "png",
                            "gif",
                            "webp",
                            "svg",
                            "ai",
                            "eps",
                            "bmp",
                            "psd",
                            "thm",
                            "pspimage",
                            "tif",
                            "yuv",
                            "drw",
                            "Eps",
                            "ps",
                            "pcd"]
        
        if let ext = self.getExtension() {
            return imageFormats.contains(ext)
        }
        return false
    }
    
    public func getExtension() -> String? {
        let ext = (self as NSString).pathExtension
        if ext.isEmpty {
            return nil
        }
        return ext
    }
    
    //MARK: -  ================================
    //MARK: Replace a Pertucular character
    //MARK: ==================================
    public func replaceCharacter(oldCharacter:String, newCharacter:String)->String{
        return self.replacingOccurrences(of: oldCharacter, with: newCharacter, options: .literal, range: nil)
    }
    
    //MARK: -  ================================
    //MARK: Convert to HTML Text
    //MARK: ==================================
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    //MARK: -  ================================
    //MARK: Get Currency Symbol
    //MARK: ==================================
    func getSymbolForCurrencyCode() -> String? {
        var cod = self
        if cod == ""{
            if Locale.current.currencyCode != nil{
                cod = Locale.current.currencyCode!
            } else{
                cod = "USD"
            }
        }
        let upperCode = cod.uppercased()
        let symbol = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == upperCode }
        let sym = "\((symbol?.currencySymbol?.last)!)"
        return sym
    }
    
    //MARK: -  ================================
    //MARK: Strike Through Words
    //MARK: ==================================
    func strikeThrough(color: UIColor)->NSAttributedString{
            let textRange = NSMakeRange(0, self.count)
            let attributedText = NSMutableAttributedString(string: self)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: textRange)
            attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: color, range: textRange)
            return attributedText
        }
    
    func strikeThrough(color: UIColor, forString:String)->NSAttributedString{
        let textRange = (self as NSString).range(of: forString)
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: color, range: textRange)
        return attributedText
    }
    
    
    //MARK: -  ================================
    //MARK: Remove HTML Tags from string
    //MARK: ==================================
    func removeHTMLTags()->String{
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
    
    //MARK: -  ================================
    //MARK: Convert to Double
    //MARK: ==================================
    func toDouble() -> Double {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return 0.0
        }
    }
    //MARK: -  ================================
    //MARK: Convert to Intger
    //MARK: ==================================
    func toInt() -> Int {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return 0
        }
    }
    
    //MARK: -  ================================
    //MARK: For Coupon codes with spacing
    //MARK: ==================================
    func getAttributedStringWithKern() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: 4, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    //MARK: -  ================================
    //MARK: For localized string
    //MARK: ==================================
    func Localized() -> String {
        guard let lang = UserDefault.value(forKey: UserDefaultsKey.SelectedLanguage.rawValue) as? String else { return "" }
        let path = Bundle.main.path(forResource: lang , ofType: "lproj")
        let bundle = Bundle(path: path!)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    func ConvertDateFormat(FromFormat:String,ToFormat:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FromFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = ToFormat
        return  dateFormatter.string(from: date!)
        
    }
    
  
}
extension String {

    // formatting text for currency textField
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = Currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
    public func removeFormatAmount() -> Double {
               let formatter = NumberFormatter()
               formatter.locale = Locale.current
               formatter.numberStyle = .currency
               formatter.currencySymbol = Currency
               formatter.decimalSeparator = Locale.current.groupingSeparator
               return formatter.number(from: self)?.doubleValue ?? 0.00
           }
}
extension String {
    func Bold(color:UIColor,FontSize:CGFloat)-> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : CustomFont.PoppinsBold.returnFont(FontSize),
            .foregroundColor : color
        ]
        return NSMutableAttributedString(string: self, attributes:attributes)
    }
    
    func Medium(color:UIColor,FontSize:CGFloat)-> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : CustomFont.PoppinsMedium.returnFont(FontSize),
            .foregroundColor : color
        ]
        return NSMutableAttributedString(string: self, attributes:attributes)
    }
    
    func Regular(color:UIColor,FontSize:CGFloat)-> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : CustomFont.PoppinsRegular.returnFont(FontSize),
            .foregroundColor : color
        ]
        return NSMutableAttributedString(string: self, attributes:attributes)
    }

}
extension String {
    func hasAllZero() -> Bool {
        
        let mobileNumberPattern = "^0*$"
        let mobileNumberPred = NSPredicate(format: "SELF MATCHES %@", mobileNumberPattern)

        let matched = mobileNumberPred.evaluate(with: self)
        if matched {
           return true
        } else {
            return false
        }
    }
}
