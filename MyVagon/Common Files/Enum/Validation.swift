//
//  Validation.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import Foundation

class ValidationError: Error {
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
}

protocol ValidatorConvertible {
    func validated(_ value: String) -> (Bool,String)
}

enum ValidatorType {
    case email
    case password(field: String)
    case username(field: String,MaxChar:Int)
    case requiredField(field: String)
    case Upload(field: String)
    case age
    case phoneNo(MinDigit: Int,MaxDigit:Int)
    case Select(field: String)
    case plateNumber(field: String)
}

enum VaildatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .password(let fieldName): return PasswordValidator(fieldName)
        case .username(let fieldName,let maxchar): return UserNameValidator(field: fieldName,maxChar: maxchar)
        case .requiredField(let fieldName): return RequiredFieldValidator(fieldName)
        case .age: return AgeValidator()
        case .phoneNo(let MinimumDigit,let MaximumDigit): return PhoneNoValidator(MinDigit: MinimumDigit, MaxDigit: MaximumDigit)
        case .Select(let fieldName): return ValueSelection(fieldName)
        case .Upload(let fieldName): return UploadDocument(fieldName)
        case .plateNumber(let fieldName): return checkPlateNumber(fieldName)
        }
    }
}
class AgeValidator: ValidatorConvertible {
    
    func validated(_ value: String) -> (Bool, String)
    {
        guard value.count > 0 else{return (false,ValidationError("Age is required").message)}
        guard let age = Int(value) else {return (false,ValidationError("Age must be a number!").message)}
        guard value.count < 3 else {return (false,ValidationError("Invalid age number!").message)}
        guard age >= 18 else {return (false,ValidationError("You have to be over 18 years old to user our app :)").message)}
        return (true, "")
    }
}
class ValueSelection: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String) -> (Bool, String)
    {
        guard value != "" else {return (false,ValidationError("Please select \(fieldName)").message)}
        return (true , "")
    }
}
class UploadDocument: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    func validated(_ value: String) -> (Bool, String)
    {
        guard value != "" else {return (false,ValidationError("Please upload \(fieldName)").message)}
        return (true , "")
    }
}

struct checkPlateNumber: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field
    }
    
    func validated(_ value: String) -> (Bool, String) {
        var letter = false
        var number = false
        for i in value{
            if i.isLetter{
                letter = true
            }
            if i.isNumber{
                number = true
            }
        }
        if letter && number{
            return (true , "")
        }else{
            return (false,ValidationError("\("Invalid".localized) \(fieldName), \(fieldName) \("should contain characters and digits".localized)").message)
        }
    }
}

struct RequiredFieldValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field.localized
    }
    
    func validated(_ value: String) -> (Bool, String) {
        guard !value.isEmpty else {
            return (false,ValidationError("Error_PleaseEnter".localized + fieldName).message)
        }
        return (true,"Error_PassBlankSpace".localized)
    }
}
struct UserNameValidator: ValidatorConvertible {
    private let fieldName: String
    private let MaximumChar: Int
    init( field: String, maxChar:Int) {
        fieldName = field.localized
        MaximumChar = maxChar
    }
    func validated(_ value: String) -> (Bool, String) {
        
        let pleaseEnter = "Error_PleaseEnter".localized
        let Error_EnterValid = "Error_EnterValid".localized
        let Error_Contains = "Error_Contains".localized
        let characters = "characters".localized
        
        guard value != "" else {return (false,ValidationError("\(pleaseEnter)\(fieldName)").message)}
        
        guard value.count >= 2 else {
            return (false,ValidationError("\(Error_EnterValid) \(fieldName)").message)
            // ValidationError("Username must contain more than three characters" )
        }
        guard value.count <= MaximumChar else {
            return (false , ValidationError("\(fieldName.firstCharacterUpperCase() ?? "") \(Error_Contains) \(MaximumChar) \(characters)").message)
            // throw ValidationError("Username shoudn't conain more than 18 characters" )
        }
        
        do {
            if try NSRegularExpression(pattern: "[!\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~]+", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) != nil {
                return (false,ValidationError("Invalid \(fieldName), \(fieldName) should not contain numbers or special characters").message)
            }
        } catch {
            return (false,ValidationError("Invalid \(fieldName), \(fieldName) should not contain numbers or special characters").message)
        }
        return (true , "")
        // return value
    }
    
    /* func validated(_ value: String) throws -> String {
     guard value.count >= 3 else {
     throw ValidationError("Username must contain more than three characters" )
     }
     guard value.count < 18 else {
     throw ValidationError("Username shoudn't conain more than 18 characters" )
     }
     
     do {
     if try NSRegularExpression(pattern: "^[a-z]{1,18}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
     throw ValidationError("Invalid username, username should not contain whitespaces, numbers or special characters")
     }
     } catch {
     throw ValidationError("Invalid username, username should not contain whitespaces, or special characters")
     }
     return value
     } */
}
//struct PasswordValidator: ValidatorConvertible {
//    private let fieldName: String
//
//    init(_ field: String) {
//        fieldName = field
//    }
//
//    func validated(_ value: String) -> (Bool,String) {
//        guard value != "" else {return (false,ValidationError("Please enter " + fieldName.lowercased()).message)}
//        guard value.count >= 8 else { return (false,ValidationError( fieldName + " must contain at least 8 characters").message)}
//        guard value.count < 15 else {
//            return (false , ValidationError("\(fieldName) shoudn't contain more than 15 characters").message)
//            // throw ValidationError("Username shoudn't conain more than 18 characters" )
//        }
//        // do {
//        // if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
//        // return (false,ValidationError("Password must be more than 6 characters, with at least one character and one numeric character").message)
//        // }
//        // } catch {
//        // return (false,ValidationError("Password must be more than 6 characters, with at least one character and one numeric character").message)
//        // }
//        return (true, "")
//    }
//}
struct PasswordValidator: ValidatorConvertible {
    private let fieldName: String
    
    init(_ field: String) {
        fieldName = field.localized
    }
    func validated(_ value: String)  -> (Bool,String) {
        
        let errorEmpty = "Error_PleaseEnter".localized
        
        guard value != "" else {return (false,ValidationError("\(errorEmpty)\(fieldName)").message)}
        guard value.count >= 8 else { return (false,ValidationError("Error_PassMinCh".localized).message) }
        guard value.count <= 20 else { return (false,ValidationError("Error_PassMaxCh".localized).message) }
        return (CheckWhiteSpaceOnBeginToEnd(value: value))
        
    }
    func CheckWhiteSpaceOnBeginToEnd(value:String) -> (Bool,String)
    {
        if value.hasPrefix(" ") || value.hasSuffix(" ")
        {
            return (false,"Your password can???t end with a blank space")
        }
//        else if !isValidPassword(str: value) {
//            return (false,"Password should consist of at least a number, a capital letter and a special character")
//        }
        return (true,"")
    }
    func isValidPassword(str:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = str.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "(?:(?:(?=.*?[0-9])(?=.*?[-!@#$%&*??+=_])|(?:(?=.*?[0-9])|(?=.*?[A-Z])|(?=.*?[-!@#$%&*??+=_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%&*??+=_]))[A-Za-z0-9-!@#$%&*??+=_]{8,20}"

        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
}
struct EmailValidator: ValidatorConvertible {
    func validated(_ value: String)  -> (Bool,String) {
        
        if value.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 {
            return (false, "Error_BlankEmail".localized)
        } else {
            do {
                if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                    return (false,ValidationError("Error_ValidEmail".localized).message)
                }
            } catch {
                return (false,ValidationError("Error_ValidEmail".localized).message)
            }
            return (true, "")
        }
        
    }
}
//struct EmailValidator: ValidatorConvertible {
//    func validated(_ value: String) -> (Bool,String) {
//        do {
//            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
//                return (false,ValidationError("Please enter email id").message)
//            }
//        } catch {
//            return (false,ValidationError("Please enter a valid email").message)
//        }
//        return (true, "")
//    }
//}
struct PhoneNoValidator: ValidatorConvertible {
    private let minimumDigit: Int
    private let maximumDigit: Int
    init( MinDigit: Int, MaxDigit:Int) {
        minimumDigit = MinDigit
        maximumDigit = MaxDigit
    }
    
    let minimum = "Error_Minimum".localized
    let minimumdigits = "Error_DigitsReq".localized
    
    func validated(_ value: String) -> (Bool,String) {
        guard value != "" else {return (false,ValidationError("Error_BlankMobile".localized).message)}
        guard value.count >= minimumDigit else { return (false,ValidationError("\(minimum) \(minimumDigit) \(minimumdigits)").message)}
        guard value.count <= maximumDigit else { return (false,ValidationError("Error_ValidMobile".localized).message)}
        guard !value.hasAllZero() else { return (false,ValidationError("Error_ValidMobile".localized).message)}
       
        
//        guard (value.isValidPhoneNumber)() else
//            { return (false,ValidationError("Please enter valid phone number").message)}
        
        
        // do {
        // if try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
        // return (false,ValidationError("Password must be more than 6 characters, with at least one character and one numeric character").message)
        // }
        // } catch {
        // return (false,ValidationError("Password must be more than 6 characters, with at least one character and one numeric character").message)
        // }
        return (true, "")
    }
}
