//
//  Date+Extension.swift
//  Qwnched-Customer
//
//  Created by Hiral on 19/02/21.
//  Copyright © 2021 Hiral's iMac. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> (String,Int,OffSetType) {
        if years(from: date) > 0 {
            if years(from: date) > 1 {
                return ("\(years(from: date)) years",years(from: date),.Year)
            } else {
                return ("\(years(from: date)) year",years(from: date),.Year)
            }
        }
       
        if months(from: date) > 0 {
            if months(from: date) > 1 {
                return ("\(months(from: date)) months",months(from: date),.Month)
            } else {
                return ("\(months(from: date)) month",months(from: date),.Month)
            }
        }
        
        if weeks(from: date) > 0 {
            if weeks(from: date) > 1 {
                return ("\(weeks(from: date)) weeks",weeks(from: date),.Weeks)
            } else {
                return ("\(weeks(from: date)) week",weeks(from: date),.Weeks)
            }
        }
        
        if days(from: date) > 0 {
            if days(from: date) > 1 {
                return ("\(days(from: date)) days",days(from: date),.Day)
            } else {
                return ("\(days(from: date)) day",days(from: date),.Day)
            }
        }
        
        if hours(from: date) > 0 {
            if hours(from: date) > 1 {
                return ("\(hours(from: date)) hours",hours(from: date),.Hours)
            } else {
                return ("\(hours(from: date)) hour",hours(from: date),.Hours)
            }
        }
        
        if minutes(from: date) > 0 {
            if minutes(from: date) > 1 {
                return ("\(minutes(from: date)) minutes",minutes(from: date),.Minute)
            } else {
                return ("\(minutes(from: date)) minute",minutes(from: date),.Minute)
            }
        }
        
        if seconds(from: date) > 0 {
            if seconds(from: date) > 1 {
                return ("\(seconds(from: date)) seconds",seconds(from: date),.Second)
            } else {
                return ("\(seconds(from: date)) second",seconds(from: date),.Second)
            }
        }
        
        return ("0 second",0,.Second)
    }
    func CheckHours(from date: Date) -> (String,Int,OffSetType) {
        if years(from: date) > 0 {
            if years(from: date) > 1 {
                return ("\(years(from: date)) years",years(from: date),.Year)
            } else {
                return ("\(years(from: date)) year",years(from: date),.Year)
            }
        }
       
        if months(from: date) > 0 {
            if months(from: date) > 1 {
                return ("\(months(from: date)) months",months(from: date),.Month)
            } else {
                return ("\(months(from: date)) month",months(from: date),.Month)
            }
        }
        
        if weeks(from: date) > 0 {
            if weeks(from: date) > 1 {
                return ("\(weeks(from: date)) weeks",weeks(from: date),.Weeks)
            } else {
                return ("\(weeks(from: date)) week",weeks(from: date),.Weeks)
            }
        }
        
        if days(from: date) > 0 {
            if days(from: date) > 1 {
                return ("\(days(from: date)) days",days(from: date),.Day)
            } else {
                return ("\(days(from: date)) day",days(from: date),.Day)
            }
        }
        
        if hours(from: date) > 0 {
            if hours(from: date) > 1 {
                return ("\(hours(from: date)) hours",hours(from: date),.Hours)
            } else {
                return ("\(hours(from: date)) hour",hours(from: date),.Hours)
            }
        }
        return ("0 hour",0,.Hours)
    }
 
}

extension UIDatePicker {
    /// Returns the date that reflects the displayed date clamped to the `minuteInterval` of the picker.
    /// - note: Adapted from [ima747's](http://stackoverflow.com/users/463183/ima747) answer on [Stack Overflow](http://stackoverflow.com/questions/7504060/uidatepicker-with-15m-interval-but-always-exact-time-as-return-value/42263214#42263214})
    public var clampedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}
extension Date {
    func convertToString(format:String) -> String {
        let formatter1 = DateFormatter()
         formatter1.dateStyle = .medium
         formatter1.dateFormat = format
         
         let DateinString = formatter1.string(from: self)
        return DateinString
    }
    
}
extension Date {

    func ConvertDataToHeaderDate() -> String {
        let onlyDate = DateFormatter()
        onlyDate.dateFormat = "dd'\(self.daySuffix())' MMM"
        let datewithMonth = onlyDate.string(from: self)
        onlyDate.dateFormat = "yy"
        let datewithyear = onlyDate.string(from: self)
        return "\(datewithMonth)'\(datewithyear)"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}

enum OffSetType : String {
    case Year,Month,Day,Weeks,Hours,Minute,Second
}
extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}
