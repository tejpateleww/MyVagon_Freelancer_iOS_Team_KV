//
//  MyAccountViewController.swift
//  MyVagon
//
//  Created by Apple on 03/08/21.
//

import UIKit
import DropDown

class MyAccountVC: BaseViewController, CloseSettingTabbarDelgate {
    
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
        self.addObserver()
    }
    
    //MARK: - Custom methods
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    @objc func changeLanguage(){
        self.MyAccountDetails.removeAll()
        self.setDataInArray()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Account", leftImage: NavItemsLeft.none.value, rightImages: [], isTranslucent: true, ShowShadow: true, isHomeTitle: true)
        self.AccountTableView.delegate = self
        self.AccountTableView.dataSource = self
        self.setDataInArray()
        self.setupToolbar()
    }
    
    func setupData(){
        let Version = "\("Version".localized) : \(Bundle.main.releaseVersionNumber ?? "")(\(Bundle.main.buildVersionNumber ?? ""))"
        self.lblVersion.text = Version
        self.arrLanguage.removeAll()
        for data in SingletonClass.sharedInstance.initResModel?.localizationLanguage ?? []{
            self.arrLanguage.append(data)
        }
        self.selectedLangCode = UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el"
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
            Utilities.ShowAlertOfInfo(OfMessage: "Calling not supported.".localized)
        }
    }
    
    func chatWithAdmin(chatObj:SupportChat){
        AppDelegate.shared.shipperIdForChat = "\(chatObj.id ?? 0)"
        AppDelegate.shared.shipperNameForChat = chatObj.name ?? "Admin"
        AppDelegate.shared.shipperProfileForChat = chatObj.profile ?? ""
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ChatVC.storyboardID) as! ChatVC
        controller.shipperID = AppDelegate.shared.shipperIdForChat
        controller.shipperName = AppDelegate.shared.shipperNameForChat
        AppDelegate.shared.shipperProfileForChat = AppDelegate.shared.shipperProfileForChat
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setDataInArray(){
        self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Language.StringName, isLanguageButton: true))
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.myProfile ?? 0 == 1{
            self.MyAccountDetails.append(MyAccountSection(Name: MyAccountSectionTitle.Myprofile.StringName, isLanguageButton: false))
        }
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.setting ?? 0 == 1{
            self.MyAccountDetails.append( MyAccountSection(Name: MyAccountSectionTitle.settings.StringName, isLanguageButton: false))
        }
//        if SingletonClass.sharedInstance.UserProfileData?.permissions?.statistics ?? 0 == 1{
//            self.MyAccountDetails.append( MyAccountSection(Name: MyAccountSectionTitle.Statistics.StringName, isLanguageButton: false))
//        }
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
        let cancelButton = self.cancleButton()
        let Space = createSpaceBtn()
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(customView: Space),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
               UIBarButtonItem(customView: cancelButton),
        ]
    }
    
    func cancleButton() -> UIButton{
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cancelButton.setTitle("Cancel".localized.uppercased(), for: .normal)
        cancelButton.contentHorizontalAlignment = .right
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.systemBlue, for: .normal)
        cancelButton.layer.masksToBounds = true
        cancelButton.tintColor = UIColor.black
        cancelButton.addTarget(self, action: #selector(self.onCancelButtonTapped), for: .touchUpInside)
        return cancelButton
    }
    
    func createSpaceBtn() -> UIButton{
        let Space = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        Space.setTitle("Select Language".localized.uppercased(), for: .normal)
        Space.contentHorizontalAlignment = .center
        Space.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        Space.backgroundColor = UIColor.clear
        Space.setTitleColor(UIColor.lightGray, for: .normal)
        Space.layer.masksToBounds = true
        Space.tintColor = UIColor.black
        return Space
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
        TempLangCode = arrLanguage[index1 ?? 0].localizationCode ?? ""
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
        Utilities.showAlertWithTitleFromVC(vc: self, title: AppName, message: "Are you sure want to Logout?".localized, buttons: ["Cancel".localized, "Logout".localized]) { index in
            if index == 1 {
                SingletonClass.sharedInstance.callApiForLogout()
            }
        }
    }
}

//MARK: - UIPickerView Methods
extension MyAccountVC : UIPickerViewDelegate, UIPickerViewDataSource {
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
        self.AccountTableView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.4, animations: {
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        }) { _ in
            self.toolBar.removeFromSuperview()
            self.picker.removeFromSuperview()
            self.customTabBarController?.showTabBar()
            self.setupToolbar()
        }
        var selectedLanguage = self.arrLanguage[row].localizationCode ?? ""
        if(selectedLanguage == ""){
            selectedLanguage = self.arrLanguage[0].localizationCode ?? ""
        }
        AppDelegate.shared.changeLanguage(LangCode: selectedLanguage) {
            self.selectedLangCode = selectedLanguage
            self.TempLangCode = selectedLanguage
            Localize.setCurrentLanguage(self.selectedLangCode)
            let indexPath = IndexPath(item: 0, section: 0)
            appDel.NavigateToHome()
//            NotificationCenter.default.post(name: Notification.Name(rawValue: LocalizeTabbarItems), object: nil)
            self.AccountTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension MyAccountVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyAccountDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AccountTableView.dequeueReusableCell(withIdentifier: "MyAccountCell", for: indexPath) as! MyAccountCell
        cell.BtnLanguage.superview?.isHidden = (MyAccountDetails[indexPath.row].HaslanguageButton == true) ? false : true
        cell.TitleLabel.text = MyAccountDetails[indexPath.row].TitleName
        if(!(cell.BtnLanguage.superview?.isHidden ?? false)){
            for data in SingletonClass.sharedInstance.initResModel?.localizationLanguage ?? []{
                if(data.localizationCode == self.selectedLangCode){
                    cell.BtnLanguage.setTitle(data.name, for: .normal)
                }
            }
        }
        cell.btnLanguageTapCousure = {
            if(self.arrLanguage.count > 0){
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
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: NewEditProfile.storyboardID) as! NewEditProfile
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
            controller.strNavTitle = "Notifications".localized
            self.navigationController?.pushViewController(controller, animated: true)
        case MyAccountSectionTitle.Changepassword.StringName:
            let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: ChangePasswordVC.storyboardID) as! ChangePasswordVC
            controller.hidesBottomBarWhenPushed = true
            controller.isFromForgot = false
            self.navigationController?.pushViewController(controller, animated: true)
            break
//        case MyAccountSectionTitle.Statistics.StringName:
//            let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: StatisticsVC.storyboardID) as! StatisticsVC
//            controller.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(controller, animated: true)
//            break
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

//MARK: - call support api
extension MyAccountVC{
    func callSupportAPI(isCall : Bool = false) {
        self.vhatListViewModel.myAccountViewController = self
        self.vhatListViewModel.WebServiceSupportAPIForSetting(isCall: isCall)
    }
}

//MARK: -onCloseTap
extension MyAccountVC{
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


