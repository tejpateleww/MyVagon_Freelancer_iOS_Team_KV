//
//  SplashVC.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit
import CoreLocation

    

class SplashVC: UIViewController, CLLocationManagerDelegate {

    
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var lbl_myvagon: UILabel!
    @IBOutlet weak var img_myvagon: UIImageView!
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = UserDefault.getUserData()
     
        
        WebServiceForpackageListing()
        WebServiceForTruckType()
        WebServiceForTruckUnit()
        WebServiceForTruckBrand()
        WebServiceForTruckFeatures()
        observeAnimationAndVersionChange()
        WebServiceForCanclletionReasone()
     
        
        // Do any additional setup after loading the view.
    }

    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func WebServiceForpackageListing(){
        WebServiceSubClass.PackageListing{_, _, _, _ in}
    }
    func WebServiceForTruckType(){
        WebServiceSubClass.TruckType {_, _, _, _ in}
    }
    func WebServiceForTruckUnit(){
        WebServiceSubClass.TruckUnit {_, _, _, _ in}
    }
    func WebServiceForTruckBrand(){
        WebServiceSubClass.TruckBrand {_, _, _, _ in}
    }
    func WebServiceForTruckFeatures(){
        WebServiceSubClass.TruckFeatures {_, _, _, _ in}
    }
    func WebServiceForCanclletionReasone(){
        WebServiceSubClass.cancellationReasoneList {_, _, _, _ in}
    }
    func openForceUpdateAlert(msg: String){
        Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: msg, buttons: [UrlConstant.Ok]) { (ind) in
            if ind == 0{
                if let url = URL(string: AppURL) {
                    UIApplication.shared.open(url)
                }
                self.openForceUpdateAlert(msg: msg)
            }
        }
    }
    private func observeAnimationAndVersionChange() {
        let group = DispatchGroup()
        group.enter()
        // call closure only once need to set root viewController
        webserviceInit {
            group.leave()
        }
//
//        group.enter()
//        WebServiceSubClass.PackageListing { (_, _, _, _) in
//            group.leave()
//        }
//
//        group.enter()
//        WebServiceSubClass.TruckType { (_, _, _, _) in
//            group.leave()
//        }
//
//        group.enter()
//        WebServiceSubClass.TruckUnit { (_, _, _, _) in
//            group.leave()
//        }
//
//        group.enter()
//        WebServiceSubClass.TruckBrand { (_, _, _, _) in
//            group.leave()
//        }
//
//        group.enter()
//        WebServiceSubClass.TruckFeatures { (_, _, _, _) in
//            group.leave()
//        }
      
        group.notify(queue: .main) {
            self.setRootViewController()
        }
       
    }
    func setRootViewController(){
    let UserLogin = UserDefault.bool(forKey: UserDefaultsKey.isUserLogin.rawValue)
    if UserLogin {
        let CheckLoginType = UserDefault.value(forKey: UserDefaultsKey.LoginUserType.rawValue) as? String ?? ""
        if CheckLoginType == LoginType.company.rawValue {
            appDel.NavigateToDispatcher()
        } else if CheckLoginType == LoginType.freelancer.rawValue {
            appDel.NavigateToHome()
        }else if CheckLoginType == LoginType.driver.rawValue {
            appDel.NavigateToHome()
        }
    } else {
        let CheckIntro = UserDefault.bool(forKey: UserDefaultsKey.IntroScreenStatus.rawValue)
        if CheckIntro {
            appDel.NavigateToLogin()
            
        } else {
            UserDefault.setValue(true, forKey: UserDefaultsKey.IntroScreenStatus.rawValue)
            appDel.NavigateToIntroScreen()
        }
    }
    }
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func webserviceInit(completion: @escaping EmptyClosure){
        WebServiceSubClass.InitApi { (status, message, response, error) in
            if let dic = error as? [String: Any], let msg = dic["The request timed out"] as? String, msg == UrlConstant.NoInternetConnection || msg == UrlConstant.SomethingWentWrong || msg == UrlConstant.RequestTimeOut{
              
                Utilities.showAlertWithTitleFromVC(vc: self, title: AppName, message: msg, buttons: [UrlConstant.Retry], isOkRed: false) { (ind) in
                    self.webserviceInit(completion: completion)
                }
                return
            }

            if status {
                SingletonClass.sharedInstance.initResModel = response?.data
                
                if (response?.data?.bookingData?.trucks?.locations?.count ?? 0) != 0{
                    let arrLocation = response?.data?.bookingData?.trucks?.locations
                    for i in 0...((arrLocation?.count ?? 0) - 1) {
                        if ((arrLocation?[i].arrivedAt ?? "") == "") || ((arrLocation?[i].StartLoading ?? "") == "") || ((arrLocation?[i].startJourney ?? "") == "") {
                            SingletonClass.sharedInstance.CurrentTripSecondLocation = arrLocation?[i]
                            break
                        }
                    }
                    SingletonClass.sharedInstance.CurrentTripShipperID = "\(response?.data?.bookingData?.shipperDetails?.id ?? 0)"
                }
                
       
                if let responseDic = error as? [String:Any], let _ = responseDic["update"] as? Bool{
                    Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: message, buttons: [UrlConstant.Ok,UrlConstant.Cancel]) { (ind) in
                        if ind == 0{
                            if let url = URL(string: AppURL) {
                                UIApplication.shared.open(url)
                            }
                        }else {
                            completion()
                        }
                    }
                }else{
                    completion()
                }
            }else{
                if let responseDic = error as? [String:Any], let _ = responseDic["maintenance"] as? Bool{
                    Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: message, buttons: []) {_ in}
                }else{
                    if let responseDic = error as? [String:Any], let _ = responseDic["update"] as? Bool{
                        self.openForceUpdateAlert(msg: message)
                    }else{
                        Utilities.showAlertOfAPIResponse(param: error, vc: self)
                    }
                }
            }
        }
    }
}
