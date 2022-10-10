//
//  SplashVC.swift
//  MyVagon
//
//  Created by iMac on 15/07/21.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var animationView: AnimationView!
    var customTabBarController: CustomTabBarVC?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playAnimation()
    }
    
    //MARK: - Custom mathod
    func playAnimation(){
        animationView.contentMode = .scaleAspectFit
        animationView.play(
            fromProgress: animationView.currentProgress,
            toProgress: 1,
            loopMode: .playOnce,
            completion: { [weak self] completed in
                self?.callWebservice()
            }
        )
    }
    
    func openForceUpdateAlert(msg: String){
        Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: msg, buttons: ["Update".localized]) { (ind) in
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
        webserviceInit {
            group.leave()
        }
        group.notify(queue: .main) {
            self.setRootViewController()
        }
    }
    
    func setRootViewController(){
        Utilities.setRootViewController()
    }
    
}

// MARK: - Webservice Methods
extension SplashVC{
    
    func callWebservice(){
        let _ = UserDefault.getUserData()
        WebServiceForpackageListing()
        WebServiceForTruckType()
        WebServiceForTruckUnit()
        WebServiceForTruckBrand()
        WebServiceForTruckFeatures()
        observeAnimationAndVersionChange()
        WebServiceForCanclletionReasone()
    }
    
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
    
    func webserviceInit(completion: @escaping EmptyClosure){
        WebServiceSubClass.InitApi { (status, message, response, error) in
            if let dic = error as? [String: Any], let msg = dic["The request timed out"] as? String, msg == UrlConstant.NoInternetConnection.localized || msg == UrlConstant.SomethingWentWrong.localized || msg == UrlConstant.RequestTimeOut.localized{
                Utilities.showAlertWithTitleFromVC(vc: self, title: AppName, message: msg, buttons: [UrlConstant.Retry], isOkRed: false) { (ind) in
                    self.webserviceInit(completion: completion)
                }
                return
            }
            
            if status {
                SingletonClass.sharedInstance.initResModel = response?.data
                if response?.maintenance ?? false{
                    Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: message, buttons: []) {_ in}
                }else if response?.forceUpdate ?? false{
                    self.openForceUpdateAlert(msg: message)
                }else if response?.update ?? false{
                    Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: message, buttons: ["Update".localized,"Cancel".localized]) { (ind) in
                        if ind == 0{
                            if let url = URL(string: AppURL) {
                                UIApplication.shared.open(url) {_ in
                                    print("open url")
                                    SingletonClass.sharedInstance.splashComplete = true
                                }
                            }
                        }else{
                            completion()
                        }
                    }
                }else{
                    completion()
                }
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: message)
            }
        }
    }
}
