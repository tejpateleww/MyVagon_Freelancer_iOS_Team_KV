//
//  ChangePermissionViewController.swift
//  MyVagon
//
//  Created by Apple on 18/10/21.
//

import UIKit
class PermissionData : NSObject {
    
        var title : String!
        var isSelect : Bool!
        
         init(Title : String , IsSelect : Bool) {
            self.title = Title
            self.isSelect = IsSelect
        }
    }
class ChangePermissionViewController:  BaseViewController {
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var DriverData : DriverListDatum?
    var customTabBarController: CustomTabBarVC?
    var strNavTitle = ""
    var arrPermissionList : [PermissionData] = []
    var driverListViewModel = DriverListViewModel()
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var btnSave: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrPermissionList.append(PermissionData(Title: PermissionTitle.search_loads.rawValue, IsSelect: ((DriverData?.permission?.searchLoads ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.my_loads.rawValue, IsSelect: ((DriverData?.permission?.myLoads ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.my_profile.rawValue, IsSelect: ((DriverData?.permission?.myProfile ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.settings.rawValue, IsSelect: ((DriverData?.permission?.setting ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.statistics.rawValue, IsSelect: ((DriverData?.permission?.statistics ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.change_password.rawValue, IsSelect: ((DriverData?.permission?.changePassword ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.allow_bid.rawValue, IsSelect: ((DriverData?.permission?.allowBid ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.view_price.rawValue, IsSelect: ((DriverData?.permission?.viewPrice ?? 0) == 1) ? true : false))
        
        arrPermissionList.append(PermissionData(Title: PermissionTitle.post_availibility.rawValue, IsSelect: ((DriverData?.permission?.postAvailibility ?? 0) == 1) ? true : false))
       
        
        
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: strNavTitle, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func CallWebService() {
        self.driverListViewModel.changePermissionViewController = self
        
        let ReqModelForSettings = ChangePermissionReqModel()
        ReqModelForSettings.user_id = "\(DriverData?.id ?? 0)"// "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        arrPermissionList.forEach { element in
            
            
                switch element.title {
                case PermissionTitle.search_loads.rawValue:
                    ReqModelForSettings.search_loads = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.my_loads.rawValue:
                    ReqModelForSettings.my_loads = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.my_profile.rawValue:
                    ReqModelForSettings.my_profile = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.settings.rawValue:
                    ReqModelForSettings.settings = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.statistics.rawValue:
                    ReqModelForSettings.statistics = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.change_password.rawValue:
                    ReqModelForSettings.change_password = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.allow_bid.rawValue:
                    ReqModelForSettings.allow_bid = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.view_price.rawValue:
                    ReqModelForSettings.view_price = (element.isSelect == true) ? "1" : "0"
                    break
                case PermissionTitle.post_availibility.rawValue:
                    ReqModelForSettings.post_availibility = (element.isSelect == true) ? "1" : "0"
                    break
                
               
                case .none:
                    break
                case .some(_):
                    break
                }
                
                
            
        }
        
        
        self.driverListViewModel.UpdatePermissionSettings(ReqModel: ReqModelForSettings)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnSaveClick(_ sender: themeButton) {
        CallWebService()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
}
// ----------------------------------------------------
// MARK: - --------- TableView Methods ---------
// ----------------------------------------------------
extension ChangePermissionViewController : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPermissionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"settingTblCell", for: indexPath) as! settingTblCell
        cell.lblTitle.text = arrPermissionList[indexPath.row].title.replacingOccurrences(of: "_", with: " ").capitalized
        
        cell.btnSwitch.isOn = (arrPermissionList[indexPath.row].isSelect == true) ? true : false
        
        cell.getSelectedStatus = {
           // let previousState = cell.btnSwitch.isOn
            //cell.btnSwitch.isSelected = !previousState
            
            self.arrPermissionList[indexPath.row].isSelect = !self.arrPermissionList[indexPath.row].isSelect
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
   
    
    
        
}
enum PermissionTitle:String {
    case search_loads,my_loads,my_profile,settings,statistics,change_password,allow_bid,view_price,post_availibility
    
}



