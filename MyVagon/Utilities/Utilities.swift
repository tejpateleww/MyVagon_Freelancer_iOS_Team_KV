//
//  Utilities.swift
//  CoreSound
//
//  Created by EWW083 on 04/02/20.
//  Copyright © 2020 EWW083. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
import Lottie
import CoreLocation

extension NSObject {
    static var className : String {
        return String(describing: self)
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class Utilities:NSObject{
    //MARK: Device UDID
    static let deviceId: String = (UIDevice.current.identifierForVendor?.uuidString)!
    
    //MARK: Print Output
    static func printOutput(_ items: Any){
        print(items)
    }
    
    //MARK: ALERT MESSAGE
    class func getMessageFromApiResponse(param: Any) -> String {
        
        if let res = param as? String {
            return res
            
        }else if let resDict = param as? NSDictionary {
            
            if let msg = resDict.object(forKey: "message") as? String {
                return msg
                
            }else if let msg = resDict.object(forKey: "msg") as? String {
                return msg
                
            }else if let msg = resDict.object(forKey: "message") as? [String] {
                return msg.first ?? ""
                
            }
            
        }else if let resAry = param as? NSArray {
            
            if let dictIndxZero = resAry.firstObject as? NSDictionary {
                if let msg = dictIndxZero.object(forKey: "message") as? String {
                    return msg
                    
                }else if let msg = dictIndxZero.object(forKey: "msg") as? String {
                    return msg
                    
                }else if let msg = dictIndxZero.object(forKey: "message") as? [String] {
                    return msg.first ?? ""
                }
                
            }else if let msg = resAry as? [String] {
                return msg.first ?? ""
                
            }
        }
        return ""
    }
    
    static func showAlertWithTitleFromVC(vc:UIViewController, title:String?, message:String?, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void{
        
        let alertController = UIAlertController(title: title?.localized, message: message, preferredStyle: .alert)
        for index in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[index], style: .default, handler: { (alert: UIAlertAction!) in
                if(completion != nil) {
                    completion(index)
                }
            })
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    static func showAlertWithTitleFromVC(vc:UIViewController, title:String?, message:String?, buttons:[String], isOkRed : Bool, completion:((_ index:Int) -> Void)!) -> Void{
        
        let alertController = UIAlertController(title: title?.localized, message: message, preferredStyle: .alert)
        var style : UIAlertAction.Style
        for index in 0..<buttons.count {
            if isOkRed{
                if buttons[index].lowercased() == UrlConstant.Ok.lowercased() || buttons[index].lowercased() == UrlConstant.Yes.lowercased(){
                    style = .destructive
                }else{
                    style = .default
                }
            }else{
                style = .default
            }
            
            let action = UIAlertAction(title: buttons[index], style: style, handler: { (alert: UIAlertAction!) in
                if(completion != nil) {
                    completion(index)
                }
            })
            alertController.addAction(action)
        }
        DispatchQueue.main.async {
            vc.present(alertController, animated: true, completion: nil)
        }
    }
    static func displayAlert(_ title: String, message: String, completion:((_ index: Int) -> Void)?, otherTitles: String? ...) {
        
        if message.trimmedString == "" {
            return
        }
        let alert = UIAlertController(title: title.localized, message: message, preferredStyle: UIAlertController.Style.alert)
        if otherTitles.count > 0 {
            var i = 0
            for title in otherTitles {
                
                if let title = title {
                    alert.addAction(UIAlertAction(title: title, style: .default, handler: { (UIAlertAction) in
                        if (completion != nil) {
                            i += 1
                            completion!(i);
                        }
                    }))
                }
            }
        }
        //        else {
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
            if (completion != nil) {
                completion!(0);
            }
        }))
        //        }
        
        DispatchQueue.main.async {
            AppDelegate.shared.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    static func getDateFromString(strDate:String) -> Date {
        let dateString = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatter.amSymbol = "πμ"
//        dateFormatter.pmSymbol = "μμ"
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        if let dateFromString = dateFormatter.date(from: dateString) {
            return dateFromString
        }else{
            return Date()
        }
    }
    
    static func getDateFromString2(strDate:String) -> Date {
        let dateString = strDate
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        dateFormatter.amSymbol = "πμ"
//        dateFormatter.pmSymbol = "μμ"
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        if let dateFromString = dateFormatter.date(from: dateString) {
            return dateFromString
        }else{
            return Date()
        }
    }
    
    static func getDateDiff(start: Date, end: Date) -> String  {
        let calendar = Calendar(identifier: .iso8601)
        let dateComponents = calendar.dateComponents([Calendar.Component.hour], from: start, to: end)
        let hour = dateComponents.hour
        return String(hour!)
    }
    
    static func GetCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatterString.onlyTime.rawValue
        formatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        let dateString = formatter.string(from: Date())
        print("ATDebug :: \(dateString)")
        return dateString
    }
    
    static func showAlertWithTitleFromWindow(title:String?, andMessage message:String, buttons:[String], completion:((_ index:Int) -> Void)!) -> Void {
        
        let alertController = UIAlertController(title: title?.localized, message: message, preferredStyle: .alert)
        
        for index in 0..<buttons.count
        {
            let action = UIAlertAction(title: buttons[index], style: .default, handler: {
                (alert: UIAlertAction!) in
                
                if(completion != nil) {
                    completion(index)
                }
            })
            
            alertController.addAction(action)
        }
        
        appDel.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    static func displayAlertWithOutAction(_ title: String, message: String, completion:((_ index: Int) -> Void)?, otherTitles: String? ...) {
        
        if message.trimmedString == "" {
            return
        }
        let alert = UIAlertController(title: title.localized, message: message, preferredStyle: UIAlertController.Style.alert)
        if otherTitles.count > 0 {
            var i = 0
            for title in otherTitles {
                
                if let title = title {
                    alert.addAction(UIAlertAction(title: title, style: .default, handler: { (UIAlertAction) in
                        if (completion != nil) {
                            i += 1
                            completion!(i);
                        }
                    }))
                }
            }
        }
        //        else {
        
        //        }
        
        DispatchQueue.main.async {
            AppDelegate.shared.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    static func displayAlert(_ title: String, message: String, completion:((_ index: Int) -> Void)?, acceptTitle:String, otherTitles: String? ...) {
        if message.trimmedString == "" {
            return
        }
        let alert = UIAlertController(title: title.localized, message: message, preferredStyle: UIAlertController.Style.alert)
        var i = 0
        if otherTitles.count > 0 {
            for title in otherTitles {
                if let title = title {
                    let action = UIAlertAction(title: title, style: .default) { (action) in
                        if let tag = action.accessibilityAttributedHint?.string {
                            completion!(tag.toInt())
                        }
                    }
                    action.accessibilityAttributedHint = NSMutableAttributedString(string: "\(i+1)")
                    alert.addAction(action)
                    i += 1
                }
            }
        }
        alert.addAction(UIAlertAction(title: acceptTitle, style: .cancel, handler: { (UIAlertAction) in
            if (completion != nil) {
                completion!(0);
            }
        }))
        
        DispatchQueue.main.async {
            AppDelegate.shared.window?.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    static func displayAlert(_ title: String, message: String) {
        Utilities.displayAlert(title, message: message, completion: nil)
    }
    
    static func displayAlert(_ message: String) {
        Utilities.displayAlert(AppInfo.appName, message: message, completion: nil)
    }
    
    static func displayErrorAlert(_ message: String) {
        Utilities.displayAlert("Error", message: message, completion: nil)
    }
    static func displayAlertForMainantance(_ message: String) {
        Utilities.displayAlertWithOutAction(AppInfo.appName, message: message, completion: nil)
    }
    
    
    
    //MARK: -  ================================
    //MARK: randomString
    //MARK: ==================================
    static func randomstring(_ n: Int) -> String
    {
        let a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var s = ""
        
        for _ in 0..<n
        {
            let r = Int(arc4random_uniform(UInt32(a.count)))
            
            s += String(a[a.index(a.startIndex, offsetBy: r)])
        }
        
        return s
    }
    
    //MARK:- =============================================
    //MARK: Time Duration in Time
    //MARK: ==============================================
    static func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    static func getJurnyType(type:String) -> String{
        switch type{
        case "0":
            return "Short Haul".localized
        case "1":
            return "Medium Haul".localized
        case "2":
            return "Long Haul".localized
        default:
            return ""
        }
    }
    static func setJurnyType(type:String) -> String{
        switch type{
        case "Short Haul".localized:
            return "0"
        case "Medium Haul".localized:
            return "1"
        case "Long Haul".localized:
            return "2"
        default:
            return ""
        }
    }
    
    func isModal(vc: UIViewController) -> Bool {
        
        if let navigationController = vc.navigationController {
            if navigationController.viewControllers.first != vc {
                return false
            }
        }
        
        if vc.presentingViewController != nil {
            return true
        }
        
        if vc.navigationController?.presentingViewController?.presentedViewController == vc.navigationController {
            return true
        }
        
        if vc.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    
    class func TempoFromSeconds(duration: Double, Bpm: Int) -> Double {
        return Double( 1.0 / (Double(Bpm) * 60.0 * 4.0 * duration))
    }
    
    class func ShowAlert(OfMessage : String) {
        let alert = UIAlertController(title: AppInfo.appName.localized, message: OfMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
       // present(alert, animated: true, completion: nil)
        appDel.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    class func ShowAlertOfValidation(OfMessage : String) {
        let messageBar = MessageBarController()
        messageBar.MessageShow(title: OfMessage as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
    }
    
    class func ShowAlertOfInfo(OfMessage : String) {
        let messageBar = MessageBarController()
        messageBar.MessageShow(title: OfMessage as NSString, alertType: MessageView.Layout.cardView, alertTheme: .info, TopBottom: true)
    }
    
    class func ShowAlertOfSuccess(OfMessage : String) {
        let messageBar = MessageBarController()
        messageBar.MessageShow(title: OfMessage as NSString, alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
    }
    
    class func ShowToastMessage(OfMessage : String) {
        let messageBar = MessageBarController()
        messageBar.MessageShow(title: OfMessage as NSString, alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
    }
    
    class func showAlert(_ title: String, message: String, vc: UIViewController) -> Void
    {
        let alert = UIAlertController(title:title.localized,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if(vc.presentedViewController != nil){
            vc.dismiss(animated: true, completion: nil)
        }
        //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
        vc.present(alert, animated: true, completion: nil)
    }
    
    /// Response may be Any Type
    class func showAlertOfAPIResponse(param: Any, vc: UIViewController) {
        
        if let res = param as? String {
            Utilities.showAlert(AppInfo.appName, message: res, vc: vc)
        }
        else if let resDict = param as? NSDictionary {
            if let msg = resDict.object(forKey: "message") as? String {
                Utilities.showAlert(AppInfo.appName, message: msg, vc: vc)
            }
            else if let msg = resDict.object(forKey: "msg") as? String {
                Utilities.showAlert(AppInfo.appName, message: msg, vc: vc)
            }
            else if let msg = resDict.object(forKey: "message") as? [String] {
                Utilities.showAlert(AppInfo.appName, message: msg.first ?? "", vc: vc)
            }
        }
        else if let resAry = param as? NSArray {
            
            if let dictIndxZero = resAry.firstObject as? NSDictionary {
                if let message = dictIndxZero.object(forKey: "message") as? String {
                    Utilities.showAlert(AppInfo.appName, message: message, vc: vc)
                }
                else if let msg = dictIndxZero.object(forKey: "msg") as? String {
                    Utilities.showAlert(AppInfo.appName, message: msg, vc: vc)
                }
                else if let msg = dictIndxZero.object(forKey: "message") as? [String] {
                    Utilities.showAlert(AppInfo.appName, message: msg.first ?? "", vc: vc)
                }
            }
            else if let msg = resAry as? [String] {
                Utilities.showAlert(AppInfo.appName, message: msg.first ?? "", vc: vc)
            }
        }
    }
    class AnimationLoader: NSObject {
        
        static var ViewBG = UIView()
        static var loadingView = AnimationView(name: "LoaderLottie")
        static let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        static let blurEffectView = UIVisualEffectView(effect: blurEffect)
        class func showActivityIndicatory() {
            
            let size:CGSize = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.frame.size ?? CGSize()
            ViewBG.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            ViewBG.center = CGPoint(x: size.width / 2, y: size.height / 2)
            ViewBG.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            loadingView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            loadingView.contentMode = .scaleAspectFit
            loadingView.center = CGPoint(x: size.width / 2, y: size.height / 2)
            loadingView.backgroundColor = .clear
            loadingView.clipsToBounds = true
            loadingView.animationSpeed = 1.0
            loadingView.loopMode = .loop
//          loadingView.layer.cornerRadius = 10
            loadingView.layer.cornerRadius = 10
           
            loadingView.contentMode = .scaleAspectFit
            blurEffectView.alpha = 0.4
            blurEffectView.frame = ViewBG.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if !ViewBG.subviews.contains(blurEffectView){
                ViewBG.addSubview(blurEffectView)
            }
            if !ViewBG.subviews.contains(loadingView){
                ViewBG.addSubview(loadingView)
                ViewBG.bringSubviewToFront(loadingView)
            }
            loadingView.play()
      
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(ViewBG)
            print("ATDebug :: \(ViewBG.frame)")

    //        UIApplication.shared.keyWindow?.addSubview(ViewBG)
        }
        
        class func hideLoader(){
            
            DispatchQueue.main.async(execute: {
                loadingView.stop()
                ViewBG.removeFromSuperview()
            })
        }
    }
      static func showHud(){
        DispatchQueue.main.async {
            AnimationLoader.showActivityIndicatory()
        }
    }
    
    static func hideHud(){
        DispatchQueue.main.async {
            AnimationLoader.hideLoader()
        }
    }
    
    class func CheckLocation(currentVC:UIViewController){
        
        let alertController = UIAlertController(title: "Location Services Disabled".localized, message: "enable_location_msg".localized, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localized, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success)
                    in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(OKAction)
        alertController.addAction(settingsAction)
        OperationQueue.main.addOperation {
            currentVC.present(alertController, animated: true,
                              completion:nil)
        }
        
    }
    
    class func AlwaysAllowPermission(currentVC:UIViewController){
        
        let alertController = UIAlertController(title: "location_access_msg".localized, message: "", preferredStyle: .alert)
        let NotNowAction = UIAlertAction(title: "Not Now".localized, style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings".localized, style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success)
                    
                    in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alertController.addAction(NotNowAction)
        alertController.addAction(settingsAction)
        
        
        OperationQueue.main.addOperation {
            currentVC.present(alertController, animated: true,
                              completion:nil)
        }
    }
    
//    class func showHud()
//    {
//        let activityData = ActivityData(type: .circleStrokeSpin)
//        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
//
//
//    }
    class func ShowLoaderButtonInButton(Button:themeButton,vc:UIViewController) {
        vc.view.isUserInteractionEnabled = false
        Button.showLoading()
    }
    class func HideLoaderButtonInButton(Button:themeButton,vc:UIViewController) {
        vc.view.isUserInteractionEnabled = true
        Button.hideLoading()
    }
//    class func hideHud()
//    {
//        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
//    }
    
    /*
     class func showHUDWithoutLottie(with mainView: UIView?) {
     
     let obj = DataClass.getInstance()
     obj?.viewBackFull = UIView(frame: CGRect(x: 0, y: 0, width: mainView?.frame.size.width ?? 0.0, height: mainView?.frame.size.height ?? 0.0))
     obj?.viewBackFull?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
     let imgGlass = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))//239    115    40
     imgGlass.backgroundColor = UIColor.black.withAlphaComponent(0.0) //UIColor(red: 239/255, green: 115/255, blue: 40/255, alpha: 1.0)//
     //        self._loadAnimationNamed("Loading", view: imgGlass, dataClass: obj)
     imgGlass.center = obj?.viewBackFull?.center ?? CGPoint(x: 0, y: 0)
     imgGlass.layer.cornerRadius = 15.0
     imgGlass.layer.masksToBounds = true
     obj?.viewBackFull?.addSubview(imgGlass)
     mainView?.addSubview(obj?.viewBackFull ?? UIView())
     }
     
     
     class func showHUDWithLottie(with mainView: UIView?) {
     
     let obj = DataClass.getInstance()
     obj?.viewBackFull = UIView(frame: CGRect(x: 0, y: 0, width: mainView?.frame.size.width ?? 0.0, height: mainView?.frame.size.height ?? 0.0))
     obj?.viewBackFull?.backgroundColor = UIColor.black.withAlphaComponent(0.2)
     let imgGlass = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))//239    115    40
     imgGlass.backgroundColor = UIColor.black.withAlphaComponent(0.0) //UIColor(red: 239/255, green: 115/255, blue: 40/255, alpha: 1.0)//
     self._loadAnimationNamed("loadingDog", view: imgGlass, dataClass: obj)
     imgGlass.center = obj?.viewBackFull?.center ?? CGPoint(x: 0, y: 0)
     imgGlass.layer.cornerRadius = 15.0
     imgGlass.layer.masksToBounds = true
     obj?.viewBackFull?.addSubview(imgGlass)
     mainView?.addSubview(obj?.viewBackFull ?? UIView())
     }
     
     class func _loadAnimationNamed(_ named: String?, view mainView: UIView?, dataClass obj: DataClass?) {
     
     obj?.laAnimation = AnimationView(name: named ?? "")
     obj?.laAnimation?.frame = mainView?.frame ?? CGRect(x: 0, y: 0, width: 0, height: 0)//CGRect(x: (mainView?.center.x ?? 0.0) / 2 - 3, y: 20, width: 140, height: 140)
     obj?.laAnimation?.contentMode = .scaleAspectFill
     obj?.laAnimation?.center = mainView?.center ?? CGPoint(x: 0, y: 0)
     obj?.laAnimation?.play(fromProgress: 0,
     toProgress: 1,
     loopMode: LottieLoopMode.loop,
     completion: { (finished) in
     if finished {
     
     } else {
     
     }
     })
     obj?.laAnimation?.layer.masksToBounds = true
     mainView?.setNeedsLayout()
     if let laAnimation = obj?.laAnimation {
     mainView?.addSubview(laAnimation)
     }
     
     }
     
     class func showDataNotFound(text:String,View:UIView,isHidden:Bool) {
     let label = UILabel(frame: CGRect(x:UIScreen.main.bounds.width/2 - 120,y:UIScreen.main.bounds.height/2 - 25,width:240,height: 50))
     label.textAlignment = .center
     label.textColor = .black
     // label.backgroundColor = .yellow
     label.font = UIFont(name:AppExtraBold, size:15.0)
     label.text =  text
     View.addSubview(label)
     View.isHidden = isHidden
     label.isHidden = isHidden
     }
     
     class func hideHUD() {
     let obj = DataClass.getInstance()
     
     DispatchQueue.main.async(execute: {
     obj?.viewBackFull?.removeFromSuperview()
     })
     
     }
     */
    
    //MARK:- Date string format change ========
    class func DateStringChange(Format:String,getFormat:String,dateString:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Format                // Note: S is fractional second
        let dateFromString = dateFormatter.date(from: dateString)      // "Nov 25, 2015, 4:31 AM" as NSDate
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat =  getFormat//"MMM d, yyyy h:mm a"
        
        let stringFromDate = dateFormatter2.string(from: dateFromString!) // "Nov 25, 2015" as String
        return stringFromDate
    }
    
    class func showAlertWithTwoAction(_ title: String, message: String, _ completion: (() -> ())? = nil) -> Void
    {
        let alert = UIAlertController(title: title.localized, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (sct) in
        //
        //        }
        let OkAction = UIAlertAction(title:"Yes" , style: .default) { (sct) in
            completion?()
        }
        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(OkAction)
        alert.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
    }
    class func showAlertWithAction(_ title: String, message: String, _ completion: (() -> ())? = nil) -> Void
    {
        let alert = UIAlertController(title: AppInfo.appName.localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (sct) in
            completion?()
        }))
        appDel.window?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    
    
    class func getReadableDate(timeStamp: TimeInterval , isFromTime : Bool) -> String? {
        let date = Date(timeIntervalSinceNow: timeStamp)//Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInTomorrow(date) {
            dateFormatter.dateFormat = "h:mm a"
            return "Tomorrow at \(dateFormatter.string(from: date))"
            
        } else if Calendar.current.isDateInYesterday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return "Yesterday at \(dateFormatter.string(from: date))"
        } else if dateFallsInCurrentWeek(date: date) {
            if Calendar.current.isDateInToday(date) {
                if isFromTime == true{
                    dateFormatter.dateFormat = "h:mm a"
                    return dateFormatter.string(from: date)
                    
                }
                else{
                    dateFormatter.dateFormat = "h:mm a"
                    return "Today at \(dateFormatter.string(from: date))"
                }
                
            } else {
                dateFormatter.dateFormat = "EEEE h:mm a"
                return dateFormatter.string(from: date)
            }
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
            return dateFormatter.string(from: date)
        }
    }
    class func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
    }
    
    //MARK:- Date string format change ========
    class func getDateTimeString(dateString:String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"                 // Note: S is fractional second
        let dateFromString = dateFormatter.date(from: dateString)      // "Nov 25, 2015, 4:31 AM" as NSDate
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/yyyy"//"MMM d, yyyy h:mm a"
        
        let stringFromDate = dateFormatter2.string(from: dateFromString!) // "Nov 25, 2015" as String
        return stringFromDate
    }
    class func topMostController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        return topController
    }
    
    class func setRootViewController(){
        let UserLogin = UserDefault.bool(forKey: UserDefaultsKey.isUserLogin.rawValue)
        if UserLogin {
            appDel.NavigateToHome()
        } else {
            appDel.NavigateToLogin()
        }
    }
    
    
    //MARK:- Archive UnArchive Data ========
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    class func archiveData(data : Any?)
    {
        guard let documentURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first else { return  }

        let filePath = "MyArchive.data"
        let fileURL = documentURL.appendingPathComponent(filePath)
        
        
        let randomFilename = UUID().uuidString
        let fullPath = getDocumentsDirectory().appendingPathComponent(randomFilename)

        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: data ?? Data(), requiringSecureCoding: false)
            try data.write(to: fullPath)
        } catch {
            print("Couldn't write file")
        }

        // Archive
        if let dataToBeArchived = try? NSKeyedArchiver.archivedData(withRootObject: data ?? Data(), requiringSecureCoding: true) {
            
            do {
                try dataToBeArchived.write(to: fileURL)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
            print("The File URL is \(fileURL)")
        }
        print("Did not go in iflet")
        
    }
    
  
    
    class func sizePerMB(url: URL?) -> Double {
        guard let filePath = url?.path else {
            return 0.0
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    
      //MARK:- Custom Method
    class  func getAudioFromDocumentDirectory(audioStr : String , documentsFolderUrl : URL) -> Data?
        {
            guard let audioUrl = URL(string: audioStr) else { return nil}
            let destinationUrl = documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
              
            if FileManager().fileExists(atPath: destinationUrl.path)
            {
    //            let assets = AVAsset(url: audioUrl)
    //           print(assets)
                do {
                    let GetAudioFromDirectory = try Data(contentsOf: destinationUrl)
                     print("audio : ", GetAudioFromDirectory)
                    return GetAudioFromDirectory
                }catch(let error){
                    print(error.localizedDescription)
                }
            }
            else{
                print("No Audio Found")
            }
            return nil
        }
    
    class func GetDestinationUrlOfSong(audioStr : String , documentsFolderUrl : URL) -> URL?
    {
        guard let audioUrl = URL(string: audioStr) else { return nil}
        return documentsFolderUrl.appendingPathComponent(audioUrl.lastPathComponent)
        
    }
    
    /*
     var instance: DataClass? = nil
     class DataClass {
     
     var str = ""
     
     var laAnimation: AnimationView?
     var viewBackFull: UIView?
     
     
     class func getInstance() -> DataClass? {
     let lockQueue = DispatchQueue(label: "self")
     lockQueue.sync {
     if instance == nil {
     instance = DataClass()
     }
     }
     return instance
     }
     }
     */
    
    public func formattedNumber(number: String, mask:String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    public func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
}


extension UIImage {
    
    func normalizedImage() -> UIImage {

        if (self.imageOrientation == UIImage.Orientation.up) {
          return self;
      }

      UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
      let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)

        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext();
      return normalizedImage;
    }
    
}
