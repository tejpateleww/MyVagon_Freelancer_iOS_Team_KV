//
//  AppDelegate.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        checkAndSetDefaultLanguage()
        
        
        
        // Override point for customization after application launch.
        return true
    }

    func NavigateToLogin(){
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SignInContainerVC.storyboardID) as! SignInContainerVC
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = false
        self.window?.rootViewController = nav
    }
    
    func NavigateToRegister(){
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SignupContainerVC.storyboardID) as! SignupContainerVC
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = false
        self.window?.rootViewController = nav
    }
    
    func NavigateToIntroScreen(){
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: BoardingVC.storyboardID) as! BoardingVC
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = false
        self.window?.rootViewController = nav
    }
    func checkAndSetDefaultLanguage() {
        if UserDefault.value(forKey: UserDefaultsKey.SelectedLanguage.rawValue) == nil {
        
            setLanguageEnglish()
        } else {
            if "\(UserDefault.value(forKey: UserDefaultsKey.SelectedLanguage.rawValue) ?? "")" == "en" {
                SingletonClass.sharedInstance.SelectedLanguage = "0"
            } else if "\(UserDefault.value(forKey: UserDefaultsKey.SelectedLanguage.rawValue) ?? "")" == "el" {
                SingletonClass.sharedInstance.SelectedLanguage = "1"
            } else {
                SingletonClass.sharedInstance.SelectedLanguage = "0"
            }
        }
    }
    func setLanguageEnglish() {
        UserDefault.setValue("en", forKey: UserDefaultsKey.SelectedLanguage.rawValue)
        SingletonClass.sharedInstance.SelectedLanguage = "0"
    }
    func SetLanguageGreek() {
        UserDefault.setValue("el", forKey: UserDefaultsKey.SelectedLanguage.rawValue)
        SingletonClass.sharedInstance.SelectedLanguage = "1"
    }
}

