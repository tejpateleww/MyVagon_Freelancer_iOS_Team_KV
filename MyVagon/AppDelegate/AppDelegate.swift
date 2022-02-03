//
//  AppDelegate.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import CoreLocation
import Firebase
import FirebaseMessaging
import FirebaseCore
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{
    var window: UIWindow?

    var locationManager =  UpdateLocationClass()
    static var pushNotificationObj : NotificationObjectModel?
    static var pushNotificationType : String?
    
    var shipperIdForChat:String = ""
    var shipperNameForChat:String = ""
    var shipperProfileForChat:String = ""

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        FirebaseApp.configure()
        registerForPushNotifications()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        checkAndSetDefaultLanguage()
        GMSServices.provideAPIKey(AppInfo.Google_API_Key)
        GMSPlacesClient.provideAPIKey(AppInfo.Google_API_Key)
        SingletonClass.sharedInstance.AppVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0.0"
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
    
    func NavigateToDispatcher(){
        let controller = AppStoryboard.Dispatcher.instance.instantiateViewController(withIdentifier: DriversViewController.storyboardID) as! DriversViewController
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
        
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.searchLoads ?? 0 == 0 && SingletonClass.sharedInstance.UserProfileData?.permissions?.myLoads ?? 0 == 0 {
            let indexToRemove = 0
            if indexToRemove < controller.viewControllers?.count ?? 3 {
                var viewControllers = controller.viewControllers
                viewControllers?.remove(at: indexToRemove)
                controller.viewControllers = viewControllers
            }
            
            let FirstIndex = 1
            if FirstIndex < controller.viewControllers?.count ?? 3 {
                var viewControllers = controller.viewControllers
                viewControllers?.remove(at: FirstIndex - 1)
                controller.viewControllers = viewControllers
            }
        } else {
            if SingletonClass.sharedInstance.UserProfileData?.permissions?.searchLoads ?? 0 == 0 {
                let indexToRemove = 0
                if indexToRemove < controller.viewControllers?.count ?? 3 {
                    var viewControllers = controller.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    controller.viewControllers = viewControllers
                }
            } else if SingletonClass.sharedInstance.UserProfileData?.permissions?.myLoads ?? 0 == 0 {
                let indexToRemove = 1
                if indexToRemove < controller.viewControllers?.count ?? 3 {
                    var viewControllers = controller.viewControllers
                    viewControllers?.remove(at: indexToRemove)
                    controller.viewControllers = viewControllers
                }
            }
        }

        // Remove MyFleet Tab
        let indexToRemove = 3
        if indexToRemove < controller.viewControllers?.count ?? 3 {
            var viewControllers = controller.viewControllers
            viewControllers?.remove(at: indexToRemove)
            controller.viewControllers = viewControllers
        }
        
        
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
    }
    
    func NavigateToSchedual(){
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
        controller.selectedIndex = 1
        
        
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
    }
    
    func Logout() {
        UserDefault.set(false, forKey: UserDefaultsKey.isUserLogin.rawValue)
        SingletonClass.sharedInstance.ClearSigletonClassForLogin()
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            if key == UserDefaultsKey.DeviceToken.rawValue || key == UserDefaultsKey.IntroScreenStatus.rawValue {
                
            }else{
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        self.NavigateToLogin()
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
    
    func GetSafeAreaHeightFromBottom() -> CGFloat {
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
            return bottomSafeAreaHeight
        }
        return 0.0
    }
    
}

class CustomTabBar: UITabBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.clipsToBounds = false
        //        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        //        layer.shadowOffset = CGSize(width: -3, height: 0)
        //        layer.shadowColor = UIColor.black.cgColor
        //        layer.shadowOpacity = 0.3
        
        //        self.backgroundImage = UIImage.from(color: .white)
        
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
        self.tabBar.barTintColor = .white
        
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
        if #available(iOS 13.0, *) {
            
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
            
        } else {
            // Fallback on earlier versions
        };
        
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
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage()
    }
}

extension CLLocationCoordinate2D {
    //distance in meters, as explained in CLLoactionDistance definition
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
