//
//  AppDelegate+PushNotification.swift
//  User
//
//  Created by apple on 6/29/21.
//  Copyright © 2021 EWW071. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import UserNotifications
import GoogleMaps
import UserNotifications

import Firebase
import FirebaseMessaging
import FirebaseCore
import FirebaseCrashlytics

extension AppDelegate{
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_ , _ in })
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let token = fcmToken ?? "No Token found"
        print("Firebase registration token: \(fcmToken ?? "No Token found")")
        SingletonClass.sharedInstance.DeviceToken = token
        
        UserDefault.set(fcmToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
        
        let dataDict:[String: String] = ["token": token]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = token {
                print("Remote instance ID token: \(result)")
                UserDefaults.standard.set(SingletonClass.sharedInstance.DeviceToken, forKey: UserDefaultsKey.DeviceToken.rawValue)
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("fcmToken : \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print(#function, notification)
        let content = notification.request.content
        let userInfo = notification.request.content.userInfo
        NotificationCenter.default.post(name: NotificationBadges, object: content)

        print(#function, notification)
        
        
        if let mainDic = userInfo as? [String: Any]{
            
            let pushObj = NotificationObjectModel()
            if let bookingId = mainDic["gcm.notification.booking_id"]{
                pushObj.booking_id = bookingId as? String ?? ""
            }
            if let type = mainDic["gcm.notification.type"]{
                pushObj.type = type as? String ?? ""
            }
            if let title = mainDic["title"]{
                pushObj.title = title as? String ?? ""
            }
            if let text = mainDic["text"]{
                pushObj.text = text as? String ?? ""
            }
            
            AppDelegate.pushNotificationObj = pushObj
            AppDelegate.pushNotificationType = pushObj.type
            
            if pushObj.type == NotificationTypes.notifLoggedOut.rawValue {
                AppDelegate.shared.Logout()
                Utilities.ShowAlertOfValidation(OfMessage: "SessionExpired".localized)
                completionHandler([])
                return
            }
            
            if pushObj.type == NotificationTypes.cancelShipment.rawValue {
                completionHandler([.alert, .sound])
                return
            }
            
            if pushObj.type == NotificationTypes.cancelDriver.rawValue {
                completionHandler([.alert, .sound])
                return
            }
            
            if pushObj.type == NotificationTypes.newMeassage.rawValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    do {
                        let strDict =  mainDic["gcm.notification.data"] as! String
                        let DictData = try JSONSerialization.jsonObject(with: strDict.data(using: .utf8)!, options: []) as! [String:Any]
                        pushObj.senderId = DictData["sender_id"] as? String ?? ""
                        pushObj.senderName = DictData["sender_name"] as? String ?? ""
                        pushObj.senderImage = DictData["sender_image"] as? String ?? ""
                        if (UIApplication.appTopViewController()?.isKind(of: ChatVC.self) ?? false){
                            if(AppDelegate.shared.shipperIdForChat == pushObj.senderId){
//                                NotificationCenter.default.post(name: .reloadChatScreen, object: nil)
                            }else{
                                completionHandler([.alert, .sound])
                            }
                        }else{
                            completionHandler([.alert, .sound])
                        }
                    }catch{
                        print("Error : detected")
                    }
                }
                return
            }
            
            if pushObj.type == NotificationTypes.general.rawValue {
                completionHandler([.alert, .sound])
                return
            }
            
            if pushObj.type == NotificationTypes.cancellation.rawValue {
                completionHandler([.alert, .sound])
                return
            }
            
            if pushObj.type == NotificationTypes.shipmentProgress.rawValue {
                completionHandler([.alert, .sound])
                return
            }
            
            if pushObj.type == NotificationTypes.newLoadsAvailable.rawValue {
                completionHandler([.alert, .sound])
                return
            }
            completionHandler([.alert, .sound])
        }
    }
    
    func goToChatScreen() {
        print("navigate to chat screen")
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ChatVC.storyboardID) as! ChatVC
        controller.shipperID = AppDelegate.shared.shipperIdForChat
        controller.shipperName = AppDelegate.shared.shipperNameForChat
        controller.hidesBottomBarWhenPushed = true
        UIApplication.appTopViewController()?.navigationController?.pushViewController(controller, animated: true)
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("USER INFo : ",userInfo)
        
        
        if let mainDic = userInfo as? [String: Any]{
            
            let pushObj = NotificationObjectModel()
            if let bookingId = mainDic["gcm.notification.booking_id"]{
                pushObj.booking_id = bookingId as? String ?? ""
            }
            if let type = mainDic["gcm.notification.type"]{
                pushObj.type = type as? String ?? ""
            }
            if let title = mainDic["title"]{
                pushObj.title = title as? String ?? ""
            }
            if let text = mainDic["text"]{
                pushObj.text = text as? String ?? ""
            }
            
            AppDelegate.pushNotificationObj = pushObj
            AppDelegate.pushNotificationType = pushObj.type
          
            if pushObj.type == NotificationTypes.notifLoggedOut.rawValue {
                AppDelegate.shared.Logout()
                completionHandler()
                return
            }
            
            if pushObj.type == NotificationTypes.cancelShipment.rawValue {
                AppDelegate.pushNotificationObj = nil
                AppDelegate.pushNotificationType = nil
                completionHandler()
                return
            }
            
            if pushObj.type == NotificationTypes.cancelDriver.rawValue {
                AppDelegate.pushNotificationObj = nil
                AppDelegate.pushNotificationType = nil
                completionHandler()
                return
            }
            
            if pushObj.type == NotificationTypes.newMeassage.rawValue {
                do {
                    let strDict =  mainDic["gcm.notification.data"] as! String
                    let DictData = try JSONSerialization.jsonObject(with: strDict.data(using: .utf8)!, options: []) as! [String:Any]
                    AppDelegate.shared.shipperIdForChat = DictData["sender_id"] as? String ?? ""
                    AppDelegate.shared.shipperNameForChat = DictData["sender_name"] as? String ?? ""
                    AppDelegate.shared.shipperProfileForChat = DictData["sender_image"] as? String ?? ""
                    if(UIApplication.appTopViewController()?.isKind(of: ChatVC.self) ?? false){
                        if(AppDelegate.shared.shipperIdForChat == pushObj.senderId){
                            AppDelegate.pushNotificationObj = nil
                            AppDelegate.pushNotificationType = nil
                        }else{
//                            NotificationCenter.default.post(name: .reloadNewUserChatScreen, object: nil)
                        }
                    }else{
                        if UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .background{
                            self.goToChatScreen()
                        }else{
                            if !(UIApplication.appTopViewController()?.isKind(of: SplashVC.self) ?? false){
                                self.goToChatScreen()
//                                NotificationCenter.default.post(name: .goToChatScreen, object: nil)
                            }
                        }
                    }
                }catch{
                    print("Error : detected")
                }
            }
            if pushObj.type == NotificationTypes.general.rawValue {
                if(UIApplication.appTopViewController()?.isKind(of: NotificationVC.self) ?? false){
                    AppDelegate.pushNotificationObj = nil
                    AppDelegate.pushNotificationType = nil
                    NotificationCenter.default.post(name: .reloadNotificationScreen, object: nil)
                }else{
                    NotificationCenter.default.post(name: .goToNotificationScreen, object: nil)
                }
            }
            
            if pushObj.type == NotificationTypes.cancellation.rawValue {
                if(UIApplication.appTopViewController()?.isKind(of: NewScheduleVC.self) ?? false){
                    AppDelegate.pushNotificationObj = nil
                    AppDelegate.pushNotificationType = nil
                    NotificationCenter.default.post(name: .PostCompleteTrip, object: nil)
                }else{
                    NotificationCenter.default.post(name: .goToNewScheduleScreen, object: nil)
                }
            }
            
            if pushObj.type == NotificationTypes.shipmentProgress.rawValue {
                if(UIApplication.appTopViewController()?.isKind(of: ScheduleDetailVC.self) ?? false){
                    AppDelegate.pushNotificationObj = nil
                    AppDelegate.pushNotificationType = nil
                }else{
                    NotificationCenter.default.post(name: .goToScheduleDetailsScreen, object: nil)
                }
            }
            
            if pushObj.type == NotificationTypes.newLoadsAvailable.rawValue {
                if(UIApplication.appTopViewController()?.isKind(of: SearchVC.self) ?? false){
                    AppDelegate.pushNotificationObj = nil
                    AppDelegate.pushNotificationType = nil
                    NotificationCenter.default.post(name: .reloadDataForSearch, object: nil)
                }else{
                    NotificationCenter.default.post(name: .goToHomeScreen, object: nil)
                }
            }
        }
    }
}

extension Notification.Name {
    static let sessionExpire = NSNotification.Name("sessionExpire")
    static let arriveAtPickUpLocation = NSNotification.Name("arriveAtPickUpLocation")
    
    static let goToChatScreen = NSNotification.Name("goToChatScreen")
    static let reloadChatScreen = NSNotification.Name("reloadChatScreen")
    
    static let goToNotificationScreen = NSNotification.Name("goToNotificationScreen")
    static let reloadNotificationScreen = NSNotification.Name("reloadNotificationScreen")
    
    static let goToNewScheduleScreen = NSNotification.Name("goToNewScheduleScreen")
    static let PostCompleteTrip = NSNotification.Name("PostCompleteTrip")
    
    static let goToScheduleDetailsScreen = NSNotification.Name("goToScheduleDetailsScreen")
    
    static let goToHomeScreen = NSNotification.Name("goToHomeScreen")
    static let reloadDataForNewBid = NSNotification.Name("reloadDataForNewBid")
    
    
    static let reloadNewUserChatScreen = NSNotification.Name("reloadNewUserChatScreen")
    static let reloadRegTruckListScreen = NSNotification.Name("reloadRegTruckListScreen")
    
    static let reloadDataForSearch = NSNotification.Name("reloadDataForSearch")
    static let openSupportPopUp = NSNotification.Name("openSupportPopUp")
    static let backToLoadDeatil = NSNotification.Name("backToLoadDeatil")
    
    static let reloadSignInFields = NSNotification.Name("reloadSignInFields")
}

enum NotificationTypes : String {
    case notifLoggedOut = "sessionTimeout"
    case general = "general"
    case newMeassage = "messages"
    case bookingBidding = "booking_bidding"
    case cancellation = "cancellation"
    case shipmentProgress = "shipment_progress"
    case newLoadsAvailable = "new_loads_available"
    
    case cancelShipment = "cancel_shipment"
    case cancelDriver = "cancel_driver"
}

class NotificationObjectModel: Codable {
    var booking_id: String?
    var type: String?
    var title: String?
    var text: String?
    
    var senderId: String?
    var senderName: String?
    var senderImage: String?
}

extension UIApplication {
    class func appTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return appTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return appTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return appTopViewController(controller: presented)
        }
        return controller
    }
}
