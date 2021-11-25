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
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = UserDefault.getUserData()
     
        
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
        WebServiceForpackageListing()
        WebServiceForTruckType()
        WebServiceForTruckUnit()
        WebServiceForTruckBrand()
        WebServiceForTruckFeatures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
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
            
             //SignInVC
        })
        
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
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                let controller:BoardingVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: BoardingVC.storyboardID) as! BoardingVC
                
                self.navigationController?.pushViewController(controller,animated: true) //SignInVC
            })
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            
            manager.startUpdatingLocation()
            break
        case .restricted:
            manager.requestAlwaysAuthorization()
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            manager.requestAlwaysAuthorization()
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
    
    
    
   

}
