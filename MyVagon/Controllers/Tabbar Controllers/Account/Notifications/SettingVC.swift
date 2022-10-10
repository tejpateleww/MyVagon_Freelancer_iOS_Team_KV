//
//  SettingVC.swift
//  MyVagon
//
//  Created by iMac on 8/19/21.
//

import UIKit

class SettingVC: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var tblSettings: UITableView!
    
    var settingViewModel = SettingViewModel()
    var customTabBarController: CustomTabBarVC?
    var strNavTitle = ""
    var arrNotification: GetSettingResModel?
    var hiddenSections = Set<Int>()
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    
    //MARK: - Custom method
    func setUI(){
        self.tblSettings.showsVerticalScrollIndicator = false
        self.tblSettings.showsHorizontalScrollIndicator = false
        self.tblSettings.dataSource = self
        self.tblSettings.delegate = self
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: strNavTitle, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.CallWebServiceForGetData()
    }
}

//MARK: - WebService method
extension SettingVC{
    func CallWebServiceForGetData() {
        self.settingViewModel.settingVC = self
        let ReqModelForGetSettings = GetSettingReqModel()
        ReqModelForGetSettings.driverId = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        self.settingViewModel.GetSettingList(ReqModel: ReqModelForGetSettings)
    }
    
    func CallWebServiceForChange(key: String,value: Int) {
        self.settingViewModel.settingVC = self
        let reqModel = EditSettingsReqModel()
        reqModel.settingKey = key
        reqModel.settingValue = "\(value)"
        reqModel.driverId = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        settingViewModel.UpdateSetting(ReqModel: reqModel)
    }
}

// MARK: - TableView dataSource and delegate
extension SettingVC : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.hiddenSections.contains(section) {
            return 0
        }
        if section == 0{
            return arrNotification?.data?.pushNotification?.count ?? 0
        }else{
            return arrNotification?.data?.emailNotification?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"settingTblCell", for: indexPath) as! settingTblCell
        var data = arrNotification?.data?.emailNotification
        if indexPath.section == 0 {
            data = arrNotification?.data?.pushNotification
        }
        cell.lblTitle.text = data?[indexPath.row].name ?? ""
        cell.btnSwitch.isOn = (data?[indexPath.row].value == 1) ? true : false
        cell.btnSwitch.isUserInteractionEnabled = (SingletonClass.sharedInstance.UserProfileData?.permissions?.setting ?? 0 == 1) ? true : false
        cell.getSelectedStatus = {
            let value = data?[indexPath.row].value == 0 ? 1 : 0
            self.CallWebServiceForChange(key: data?[indexPath.row].key ?? "", value: value)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.white
        let sectionButton = UIButton()
        sectionButton.backgroundColor = .clear
        sectionButton.setImage(UIImage(named: "ic_dropdown"), for: .normal)
        sectionButton.tag = section
        sectionButton.addTarget(self,action: #selector(self.hideSection(sender:)),for: .touchUpInside)
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width - 30, height: headerView.frame.height)
        label.text = (section == 0) ? "Push Notification".localized : "Email Notification".localized
        label.font = CustomFont.PoppinsSemiBold.returnFont(FontSize.size17.rawValue)
        label.textColor = .black
        headerView.addSubview(label)
        headerView.addSubview(sectionButton)
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,constant: -15).isActive = true
        sectionButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        animeteButton(flag: self.hiddenSections.contains(section), btn: sectionButton)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc private func hideSection(sender: UIButton) {
        let section = sender.tag
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            var data:Int = (arrNotification?.data?.emailNotification?.count ?? 0)
            if section == 0 {
                data = (arrNotification?.data?.pushNotification?.count ?? 0)
            }
            for row in 0..<data {
                indexPaths.append(IndexPath(row: row,section: section))
            }
            return indexPaths
        }
        if self.hiddenSections.contains(section) {
            self.hiddenSections.remove(section)
            self.animeteButton(flag: false, btn: sender)
            self.tblSettings.insertRows(at: indexPathsForSection(),with: .fade)
        } else {
            self.hiddenSections.insert(section)
            self.animeteButton(flag: true, btn: sender)
            self.tblSettings.deleteRows(at: indexPathsForSection(),with: .fade)
        }
    }
    
    func animeteButton(flag: Bool,btn: UIButton){
        UIView.animate(withDuration: 0.2) {
            if flag{
                btn.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
            }else{
                btn.transform = .identity
            }
        }
    }
}
