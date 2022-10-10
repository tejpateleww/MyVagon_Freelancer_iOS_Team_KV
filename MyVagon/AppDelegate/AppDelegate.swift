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
    var timerLocUpdate : Timer?
    var shipperIdForChat:String = ""
    var shipperNameForChat:String = ""
    var shipperProfileForChat:String = ""

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        checkAndSetDefaultLanguage()
        registerForPushNotifications()
        GMSServices.provideAPIKey(AppInfo.Google_API_Key)
        GMSPlacesClient.provideAPIKey(AppInfo.Google_API_Key)
        SingletonClass.sharedInstance.AppVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0.0.0"
        locationManager.UpdateLocationStart()
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("become active")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if SingletonClass.sharedInstance.splashComplete{
            SingletonClass.sharedInstance.splashComplete = false
            Utilities.setRootViewController()
        }
    }
    
    func NavigateToLogin(){
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: LoginVC.storyboardID) as! LoginVC
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
  
    func NavigateToHome(){
        self.sendLangToServer()
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.searchLoads ?? 0 == 0 {
            removeViewController(restorationId: "search", controller: controller)
        }
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.myLoads ?? 0 == 0 {
            removeViewController(restorationId: "schedule", controller: controller)
        }
        // Remove MyFleet Tab
        removeViewController(restorationId: "MyFleet", controller: controller)
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.isHidden = true
        self.window?.rootViewController = nav
    }
    
    func sendLangToServer() {
        let lang = Localize.currentLanguage()
        AppDelegate.shared.changeLanguage(LangCode: lang) { }
    }
    
    func removeViewController(restorationId : String,controller: CustomTabBarVC){
        if let indexToRemove = controller.viewControllers?.firstIndex(where: {$0.restorationIdentifier == restorationId}){
            if indexToRemove < controller.viewControllers?.count ?? 0 {
                var viewControllers = controller.viewControllers
                viewControllers?.remove(at: indexToRemove)
                controller.viewControllers = viewControllers
            }
        }
    }
    
    func NavigateToSchedual(){
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.myLoads ?? 0 == 0 {
            NavigateToHome()
        }else{
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CustomTabBarVC.storyboardID) as! CustomTabBarVC
            controller.selectedIndex = 1
            let nav = UINavigationController(rootViewController: controller)
            removeViewController(restorationId: "MyFleet", controller: controller)
            nav.navigationBar.isHidden = true
            self.window?.rootViewController = nav
        }
    }
    
    func Logout() {
        UserDefault.set(false, forKey: UserDefaultsKey.isUserLogin.rawValue)
        SingletonClass.sharedInstance.ClearSigletonClassForLogin()
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            if key == UserDefaultsKey.DeviceToken.rawValue || key == UserDefaultsKey.IntroScreenStatus.rawValue || key == "LCLCurrentLanguageKey" {
                
            }else{
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        appDel.NavigateToLogin()
    }
    
    func checkAndSetDefaultLanguage() {
        let currentLang = Localize.currentLanguage()
        Localize.setCurrentLanguage(currentLang)
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

//Change language API
extension AppDelegate {
    func changeLanguage(LangCode: String, complition:@escaping (()->())) {
        let reqModel = LanguageChangeReqModel ()
        reqModel.driverId = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.language = LangCode
        self.changelanguageAPI(ReqModel: reqModel) {
            complition()
        }
    }
    
    func changelanguageAPI(ReqModel:LanguageChangeReqModel,complition: @escaping (()->())){
        Utilities.showHud()
       WebServiceSubClass.changeLanguage(reqModel: ReqModel) { (status, apiMessage, response, error) in
           Utilities.hideHud()
            if status{
                complition()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
    
}

class CustomTabBar: UITabBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius  = 10
        layer.borderColor = (UIColor.lightGray.withAlphaComponent(0.3)).cgColor
        layer.borderWidth = 0.3
        layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isTranslucent      = true
        var tabFrame            = self.frame
        tabFrame.size.height    = 55 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero)
        tabFrame.origin.y       = self.frame.origin.y +   ( self.frame.height - 55 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? CGFloat.zero))
        self.layer.cornerRadius = 0
        self.frame              = tabFrame
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
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LocalizeTabbarItems), object: nil)
        self.setLocalization()
        // tabBarFirstTimeHeight = tabBar.frame.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBottom()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setBottom(){
        let topEdge = CGFloat(-10)
        let leftEdge = self.tabBar.items![0].imageInsets.left
        let rightEdge = self.tabBar.items![0].imageInsets.right
        self.tabBar.items![selectedIndex].imageInsets = UIEdgeInsets(top: topEdge, left: leftEdge, bottom: 10, right: rightEdge)
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
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        for (count,controller) in (self.viewControllers ?? []).enumerated(){
            self.tabBar.items![count].title = (controller.restorationIdentifier?.capitalized ?? "").localized
        }
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
