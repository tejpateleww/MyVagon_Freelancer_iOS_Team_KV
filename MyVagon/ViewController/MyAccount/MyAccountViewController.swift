//
//  MyAccountViewController.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import UIKit
import DropDown

class MyAccountSection {
    
    var TitleName:String?
    var HaslanguageButton : Bool?
    init(Name:String,isLanguageButton:Bool) {
        self.TitleName = Name
        self.HaslanguageButton = isLanguageButton
    }
}

class MyAccountViewController: BaseViewController, CloseSettingTabbarDelgate {
    
    
    
    //MARK: - Properties
    @IBOutlet weak var AccountTableView: UITableView!
    @IBOutlet weak var lblVersion: themeLabel!
    
    var customTabBarController: CustomTabBarVC?
    var MyAccountDetails : [MyAccountSection] = []
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var arrLanguage : [LocalizationLanguage] = []
    var vhatListViewModel = chatListViewModel()
    var selectedLangCode : String = ""
    var TempLangCode : String = ""
    
    //MARK: - LifeCycle methods
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Account", leftImage: NavItemsLeft.none.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.AccountTableView.delegate = self
        self.AccountTableView.dataSource = self
        self.setDataInArray()
        self.setupToolbar()
    }
    
    func setupData(){
        let Version = "Version : \(Bundle.main.releaseVersionNumber ?? "")(\(Bundle.main.buildVersionNumber ?? ""))"
        self.lblVersion.text = Version
        
        for data in SingletonClass.sharedInstance.initResModel?.localizationLanguage ?? []{
            self.arrLanguage.append(data)
        }
        
        self.selectedLangCode = (self.arrLanguage.count > 0) ? self.arrLanguage[0].localizationCode ?? "" : ""
        self.AccountTableView.reloadData()
    }
    
    func openSupportPopUp() {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: SupportPopUpVC.storyboardID) as! SupportPopUpVC
        controller.selectCallClosour = {
            self.callSupportAPI(isCall: true)
        }
        controller.selectChatClosour = {
            self.callSupportAPI(isCall: false)
        }
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    func callAdmin(strPhone:String){
        self.customTabBarController?.showTabBar()
        if let url = URL(string: "tel://\(strPhone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: "Calling not supported.")
        }
    }
    
    func chatWithAdmin(chatObj:SupportChat){
        AppDelegate.shared.shipperIdForChat = "\(chatObj.id ?? 0)"
        AppDelegate.shared.shipperNameForChat = chatObj.name ?? "Admin"
        AppDelegate.shared.shipperProfileForChat = chatObj.profile ?? ""
        
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
        controller.shipperID = AppDelegate.shared.shipperIdForChat
        controller.shipperName = AppDelegate.shared.shipperNameForChat
        AppDelegate.shared.shipperProfileForChat = AppDelegate.shared.shipperProfileForChat
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setDataInArray(){
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Language.StringName, isLanguageButton: true))
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Myprofile.StringName, isLanguageButton: false))
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Payment.StringName, isLanguageButton: false))
        self.MyAccountDetails.append( MyAccountSection(Name: MyAccountSectionTitle.settings.StringName, isLanguageButton: false))
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.statistics ?? 0 == 1{
            self.MyAccountDetails.append( MyAccountSection(Name: MyAccountSectionTitle.Statistics.StringName, isLanguageButton: false))
        }
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.changePassword ?? 0 == 1 {
            self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Changepassword.StringName, isLanguageButton: false))
        }
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.AboutMYVAGON.StringName, isLanguageButton: false))
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.ContactUs.StringName, isLanguageButton: false))
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Logout.StringName, isLanguageButton: false))
    }
    
    func setupToolbar(){
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        
        //        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        //        cancelButton.setTitle("Cancel".uppercased(), for: .normal)
        //        cancelButton.contentHorizontalAlignment = .left=
        //        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        //        cancelButton.backgroundColor = UIColor.clear
        //        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        //        cancelButton.layer.masksToBounds = true
        //        cancelButton.tintColor = UIColor.black
        //        cancelButton.addTarget(self, action: #selector(self.onCancelButtonTapped), for: .touchUpInside)
        //
        let Space = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        Space.setTitle("Select Language".uppercased(), for: .normal)
        Space.contentHorizontalAlignment = .center
        Space.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        Space.backgroundColor = UIColor.clear
        Space.setTitleColor(UIColor.lightGray, for: .normal)
        Space.layer.masksToBounds = true
        Space.tintColor = UIColor.black
        //
        //        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        //        doneButton.setTitle("Done".uppercased(), for: .normal)
        //        doneButton.contentHorizontalAlignment = .right
        //        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        //        doneButton.backgroundColor = UIColor.clear
        //        doneButton.setTitleColor(UIColor.systemBlue, for: .normal)
        //        doneButton.layer.masksToBounds = true
        //        doneButton.tintColor = UIColor.black
        //        doneButton.addTarget(self, action: #selector(self.onDoneButtonTapped), for: .touchUpInside)
        //
        toolBar.items = [
            //    UIBarButtonItem(customView: cancelButton),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: Space),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            //   UIBarButtonItem(customView: doneButton),
        ]
    }
    
    @objc func onCancelButtonTapped() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
            self.customTabBarController?.showTabBar()
        }
    }
    
    @objc func onDoneButtonTapped() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
            self.customTabBarController?.showTabBar()
        }
        
        if(TempLangCode == ""){
            self.selectedLangCode = self.arrLanguage[0].localizationCode ?? ""
        }else{
            self.selectedLangCode = self.TempLangCode
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        self.AccountTableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func setupPicker(cell : MyAccountCell) {
        self.TempLangCode = ""
        self.picker.delegate = self
        self.picker.backgroundColor = UIColor.white
        self.picker.autoresizingMask = .flexibleWidth
        self.picker.contentMode = .center
        self.picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
        
        let index1 = arrLanguage.firstIndex(where: {$0.name == cell.BtnLanguage.title(for: .normal)})
        self.picker.selectRow(index1 ?? 0, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.4, animations: {
            self.view.addSubview(self.picker)
            self.view.addSubview(self.toolBar)
            self.picker.alpha = 1
            self.toolBar.alpha = 1
        }) { status in
        }
    }
    
    func showLangPicker(cell: MyAccountCell){
        let dropDown = DropDown()
        dropDown.direction = .any
        dropDown.backgroundColor = .white
        dropDown.anchorView = cell.BtnLanguage
        
        var temp : [String] = []
        for item in self.arrLanguage{
            temp.append(item.name ?? "")
        }
        dropDown.dataSource = temp
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            self.selectedLangCode = self.arrLanguage[index].localizationCode ?? ""
            let indexPath = IndexPath(item: 0, section: 0)
            self.AccountTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func confirmLogout(){
        Utilities.showAlertWithTitleFromVC(vc: self, title: AppName, message: "Are you sure want to Logout?", buttons: ["Cancel", "Logout"]) { index in
            if index == 1 {
                appDel.Logout()
            }
        }
    }
    
}

//MARK: - UIPickerView Methods
extension MyAccountViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrLanguage.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrLanguage[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.TempLangCode = self.arrLanguage[row].localizationCode ?? ""
        
        
        //dismiss and reload
        self.AccountTableView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            
            self.picker.removeFromSuperview()
            self.customTabBarController?.showTabBar()
        }
        
        if(TempLangCode == ""){
            self.selectedLangCode = self.arrLanguage[0].localizationCode ?? ""
        }else{
            self.selectedLangCode = self.TempLangCode
        }
        
        let indexPath = IndexPath(item: 0, section: 0)
        self.AccountTableView.reloadRows(at: [indexPath], with: .none)
    }
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension MyAccountViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyAccountDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = AccountTableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as! MyAccountCell
        cell.BtnLanguage.superview?.isHidden = (MyAccountDetails[indexPath.row].HaslanguageButton == true) ? false : true
        cell.TitleLabel.text = MyAccountDetails[indexPath.row].TitleName?.capitalized
        
        if(!(cell.BtnLanguage.superview?.isHidden ?? false)){
            for data in SingletonClass.sharedInstance.initResModel?.localizationLanguage ?? []{
                if(data.localizationCode == self.selectedLangCode){
                    cell.BtnLanguage.setTitle(data.name, for: .normal)
                }
            }
        }
        
        cell.btnLanguageTapCousure = {
            if(self.arrLanguage.count > 0){
                self.AccountTableView.isUserInteractionEnabled = false
                self.customTabBarController?.hideTabBar()
                self.setupPicker(cell: cell)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MyAccountDetails[indexPath.row].TitleName {
        case MyAccountSectionTitle.Language.StringName:
            break
        case MyAccountSectionTitle.Myprofile.StringName:
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: MyProfileViewController.storyboardID) as! MyProfileViewController
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.Payment.StringName:
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: PaymentsVC.storyboardID) as! PaymentsVC
            controller.hidesBottomBarWhenPushed = true
            controller.isFromEdit = true
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.settings.StringName:
            let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SettingVC.storyboardID) as! SettingVC
            controller.hidesBottomBarWhenPushed = true
            controller.strNavTitle = "Notifications"
            self.navigationController?.pushViewController(controller, animated: true)
        case MyAccountSectionTitle.Changepassword.StringName:
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: SetNewPasswordViewController.storyboardID) as! SetNewPasswordViewController
            controller.hidesBottomBarWhenPushed = true
            controller.isFromForgot = false
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.Statistics.StringName:
            let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: StatisticsOneVC.storyboardID) as! StatisticsOneVC
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.AboutMYVAGON.StringName:
            let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: AboutUsVC.storyboardID) as! AboutUsVC
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            break
        case MyAccountSectionTitle.ContactUs.StringName:
            self.customTabBarController?.hideTabBar()
            self.openSupportPopUp()
            break
        case MyAccountSectionTitle.Logout.StringName:
            self.confirmLogout()
            break
        default:
            break
        }
    }
    
    
}

extension MyAccountViewController{
    func callSupportAPI(isCall : Bool = false) {
        self.vhatListViewModel.myAccountViewController = self
        self.vhatListViewModel.WebServiceSupportAPIForSetting(isCall: isCall)
    }
}

extension MyAccountViewController{
    func onCloseTap() {
        self.customTabBarController?.showTabBar()
    }
}

//MARK: - UITableViewCell
class MyAccountCell : UITableViewCell {
    @IBOutlet weak var TitleLabel: themeLabel!
    @IBOutlet weak var BtnLanguage: themeButton!
    var btnLanguageTapCousure : (()->())?
    
    @IBAction func BtnLanguageAction(_ sender: themeButton) {
        if let obj = self.btnLanguageTapCousure{
            obj()
        }
    }
}

enum MyAccountSectionTitle {
    case Language,Myprofile,Payment,settings,Statistics,Changepassword,AboutMYVAGON,ContactUs,Logout  //,PrivacyPolicy,TermsandConditions,AboutUs
    
    var StringName:String  {
        switch self {
        case .Language:
            return "Language"
        case .Myprofile:
            return "My profile"
        case .Payment:
            return "Payments"
        case .settings:
            return "Notifications"
        case .Statistics:
            return "Statistics"
        case .Changepassword:
            return "Change password"
        case .AboutMYVAGON:
            return "About MYVAGON"
        case .ContactUs:
            return "Contact us"
        case .Logout:
            return "Log out"
        }
    }
}
