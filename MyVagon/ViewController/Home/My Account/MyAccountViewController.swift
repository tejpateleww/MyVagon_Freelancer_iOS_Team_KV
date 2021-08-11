//
//  MyAccountViewController.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import UIKit
class MyAccountSection {
    var TitleName:String?
    var HaslanguageButton : Bool?
    init(Name:String,isLanguageButton:Bool) {
        self.TitleName = Name
        self.HaslanguageButton = isLanguageButton
    }
}

class MyAccountViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var customTabBarController: CustomTabBarVC?
    var MyAccountDetails : [MyAccountSection] = [MyAccountSection(Name: MyAccountSectionTitle.Language.StringName, isLanguageButton: true),
                                                 MyAccountSection(Name: MyAccountSectionTitle.Myprofile.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.settings.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.Statistics.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.Changepassword.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.PrivacyPolicy.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.TermsandConditions.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.AboutUs.StringName, isLanguageButton: false),
                                                 MyAccountSection(Name: MyAccountSectionTitle.Logout.StringName, isLanguageButton: false)]
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var AccountTableView: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Account", leftImage: NavItemsLeft.none.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        
        AccountTableView.delegate = self
        AccountTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
extension MyAccountViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyAccountDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AccountTableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as! MyAccountCell
        
        cell.BtnLanguage.superview?.isHidden = (MyAccountDetails[indexPath.row].HaslanguageButton == true) ? false : true
        
        cell.TitleLabel.text = MyAccountDetails[indexPath.row].TitleName?.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MyAccountDetails[indexPath.row].TitleName {
        case MyAccountSectionTitle.Language.StringName:
            break
        case MyAccountSectionTitle.Myprofile.StringName:
            break
        case MyAccountSectionTitle.settings.StringName:
            break
        case MyAccountSectionTitle.Changepassword.StringName:
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SetNewPasswordViewController.storyboardID) as! SetNewPasswordViewController
            controller.hidesBottomBarWhenPushed = true
            controller.isFromForgot = false
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.PrivacyPolicy.StringName:
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CommonWebviewVC.storyboardID) as! CommonWebviewVC
            controller.strNavTitle = "Privacy Policy"
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.TermsandConditions.StringName:
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CommonWebviewVC.storyboardID) as! CommonWebviewVC
            controller.hidesBottomBarWhenPushed = true
            controller.strNavTitle = "Terms & Conditions"
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.AboutUs.StringName:
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: CommonWebviewVC.storyboardID) as! CommonWebviewVC
            controller.hidesBottomBarWhenPushed = true
            controller.strNavTitle = "About Us"
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.Logout.StringName:
            break
        default:
            break
        }
    }
    
    
}
class MyAccountCell : UITableViewCell {
    @IBOutlet weak var TitleLabel: themeLabel!
    @IBOutlet weak var BtnLanguage: themeButton!
    
    @IBAction func BtnLanguageAction(_ sender: themeButton) {
        
    }
}
enum MyAccountSectionTitle {
    case Language,Myprofile,settings,Statistics,Changepassword,PrivacyPolicy,TermsandConditions,AboutUs,Logout
    
    var StringName:String  {
        switch self {
        case .Language:
            return "Language"
        case .Myprofile:
            return "My profile"
        case .settings:
            return "settings"
        case .Statistics:
            return "Statistics"
        case .Changepassword:
                return "Change password"
        case .PrivacyPolicy:
            return "Privacy Policy"
        case .TermsandConditions:
            return "Terms and Conditions"
        case .AboutUs:
            return "AboutUs"
        case .Logout:
                return "Log out"
        }
    }
}
