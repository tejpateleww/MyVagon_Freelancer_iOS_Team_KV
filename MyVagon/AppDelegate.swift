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
}

