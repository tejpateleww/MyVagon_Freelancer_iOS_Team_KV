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
        
        SingletonClass.sharedInstance.AppVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0.0"
        
        SingletonClass.sharedInstance.GetRegisterData()
        
        
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
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: RegisterAllInOneViewController.storyboardID) as! RegisterAllInOneViewController
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
    func NavigateToHome(){
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
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

class CustomTabBar: UITabBar {

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.clipsToBounds = false
//        layer.masksToBounds = true
        layer.cornerRadius = 0
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
//        layer.shadowOffset = CGSize(width: -3, height: 0)
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.3
    }

    
    override func layoutSubviews() {
          super.layoutSubviews()
          self.isTranslucent = true
          var tabFrame            = self.frame
          tabFrame.size.height    = 55 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero)
          tabFrame.origin.y       = self.frame.origin.y +   ( self.frame.height - 55 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero))
          self.layer.cornerRadius = 0
          self.frame            = tabFrame

          self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })


      }

}

var selectedTabIndex = 1

extension CustomTabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        lastSelectedIndex = tabBarController.selectedIndex
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        selectedTabIndex = tabBarController.selectedIndex
        self.tabBar.items?.forEach({ element in
            element.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
        let topEdge = self.tabBar.items![0].imageInsets.top - 10
        let leftEdge = self.tabBar.items![0].imageInsets.left
        let rightEdge = self.tabBar.items![0].imageInsets.right
        
        
        DispatchQueue.main.async {
            self.tabBar.items![tabBarController.selectedIndex].imageInsets = UIEdgeInsets(top: topEdge, left: leftEdge, bottom: 10, right: rightEdge)
            print(self.tabBar.items![tabBarController.selectedIndex].imageInsets)
        }
        
      
    }
}
class CustomTabBarVC: UITabBarController {
    var lastSelectedIndex = 0
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 0
        // Do any additional setup after loading the view.
        addcoustmeTabBarView()
        hideTabBarBorder()
        self.tabBar.items?.forEach({ element in
            element.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
        
        
        let topEdge = self.tabBar.items![0].imageInsets.top - 10
        let leftEdge = self.tabBar.items![0].imageInsets.left
        let rightEdge = self.tabBar.items![0].imageInsets.right
        
       
        self.tabBar.items![selectedIndex].imageInsets = UIEdgeInsets(top: topEdge, left: leftEdge, bottom: 10, right: rightEdge)
       // tabBarFirstTimeHeight = tabBar.frame.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    private func addcoustmeTabBarView() {

    }
    
    func hideTabBarBorder()  {
        let tabBar = self.tabBar
        tabBar.backgroundImage = UIImage.from(color: .clear)
//        tabBar.layer.shadowColor = UIColor.black.cgColor
       
      
    }
    
    func hideTabBar() {
        self.tabBar.isHidden = true
       // coustmeTabBarView.isHidden = true
    }

    func showTabBar() {
        self.tabBar.isHidden = false
        //coustmeTabBarView.isHidden = false
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
