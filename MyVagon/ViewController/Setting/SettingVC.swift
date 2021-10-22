//
//  SettingVC.swift
//  MyVagon
//
//  Created by iMac on 8/19/21.
//

import UIKit


class NotificationList : NSObject {
    
    var SectionTitle : String!
    var data : [NotificationData]
    
    init(Title : String , Details : [NotificationData]) {
        
        self.SectionTitle = Title
        self.data = Details
        
    }

}


class NotificationData : NSObject {
    
        var title : String!
        var isSelect : Bool!
        
         init(Title : String , IsSelect : Bool) {
            self.title = Title
            self.isSelect = IsSelect
        }
    }




// ----------------------------------------------------
// MARK: - --------- Setting TblCell ---------
// ----------------------------------------------------
class settingTblCell : UITableViewCell {
    
    //MARK:- ===== Outlets =======
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSwitch: ThemeSwitch!
    
    
    var getSelectedStatus : (()->())?
        
        
        
    override func awakeFromNib() {
        super.awakeFromNib()
       
       
    }
    
    
    
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        
        if let selected = getSelectedStatus {
            selected()
        }
        
    }
    
    
}




class SettingVC: BaseViewController {
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var settingViewModel = SettingViewModel()
    var customTabBarController: CustomTabBarVC?
    var strNavTitle = ""
    var arrNotification:[NotificationList] = []
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblSettings: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: strNavTitle, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        CallWebServiceForGetData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnSaveClick(_ sender: themeButton) {
        CallWebService()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    func CallWebServiceForGetData() {
        self.settingViewModel.settingVC = self
        
        let ReqModelForGetSettings = GetSettingsListReqModel()
        ReqModelForGetSettings.user_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        
        
        self.settingViewModel.GetSettingList(ReqModel: ReqModelForGetSettings)
    }
    func CallWebService() {
        self.settingViewModel.settingVC = self
        
        let ReqModelForSettings = SettingsReqModel()
        ReqModelForSettings.user_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        arrNotification.forEach { element in
            
            element.data.forEach({ subelement in
                switch subelement.title {
                case NotificationTitle.AllNotification.Name:
                    ReqModelForSettings.notification = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Messages.Name:
                    ReqModelForSettings.message = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Bidreceive.Name:
                    ReqModelForSettings.bid_received = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Bidaccepted.Name:
                    ReqModelForSettings.bid_accepted = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Loadsassignedbydispacter.Name:
                    ReqModelForSettings.load_assign_by_dispatcher = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Starttripreminder.Name:
                    ReqModelForSettings.start_trip_reminder = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Completetripreminder.Name:
                    ReqModelForSettings.complete_trip_reminder = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.PODreminder.Name:
                    ReqModelForSettings.pdo_remider = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Matcheswithshipmentnearyou.Name:
                    ReqModelForSettings.match_shippment_near_you = (subelement.isSelect == true) ? "1" : "0"
                    break
                case NotificationTitle.Matcheswithshipmentnearlastdeliverypoint.Name:
                    ReqModelForSettings.match_shippment_near_delivery = (subelement.isSelect == true) ? "1" : "0"
                    
                    break
                case NotificationTitle.RateShipper.Name:
                    ReqModelForSettings.rate_shipper = (subelement.isSelect == true) ? "1" : "0"
                    break
                case .none:
                    break
                case .some(_):
                    break
                }
                
                
            })
        }
        
        
        self.settingViewModel.UpdateSetting(ReqModel: ReqModelForSettings)
    }
    
}
// ----------------------------------------------------
// MARK: - --------- TableView Methods ---------
// ----------------------------------------------------
extension SettingVC : UITableViewDataSource , UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrNotification.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"settingTblCell", for: indexPath) as! settingTblCell
        cell.lblTitle.text = arrNotification[indexPath.section].data[indexPath.row].title
        
        cell.btnSwitch.isOn = (arrNotification[indexPath.section].data[indexPath.row].isSelect == true) ? true : false
        cell.btnSwitch.isUserInteractionEnabled = (SingletonClass.sharedInstance.UserProfileData?.permissions?.settings ?? 0 == 1) ? true : false
        cell.getSelectedStatus = {
           // let previousState = cell.btnSwitch.isOn
            //cell.btnSwitch.isSelected = !previousState
            
            self.arrNotification[indexPath.section].data[indexPath.row].isSelect = !self.arrNotification[indexPath.section].data[indexPath.row].isSelect
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
             headerView.backgroundColor = UIColor.white
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width, height: headerView.frame.height)
            label.text = arrNotification[section].SectionTitle
            label.font = CustomFont.PoppinsSemiBold.returnFont(FontSize.size17.rawValue)
            label.textColor = .black
            
            headerView.addSubview(label)
            
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    
    
    
        
}
enum NotificationTitle {
    case AllNotification,Messages,Bidreceive,Bidaccepted,Loadsassignedbydispacter,Starttripreminder,Completetripreminder,PODreminder,Matcheswithshipmentnearyou,Matcheswithshipmentnearlastdeliverypoint, RateShipper
    var Name:String {
        switch self {
        case .AllNotification:
            return "All Notifications"
        case .Messages:
            return "Messages"
        case .Bidreceive:
            return "Bid received"
        case .Bidaccepted:
            return "Bid accepted"
        case .Loadsassignedbydispacter:
            return "Loads assigned by dispacter"
        case .Starttripreminder:
            return "Start trip reminder"
        case .Completetripreminder:
            return "Complete trip reminder"
        case .PODreminder:
            return "POD reminder"
        case .Matcheswithshipmentnearyou:
            return "Matches with shipment near you"
        case .Matcheswithshipmentnearlastdeliverypoint:
            return "Matches with shipment near last delivery point"
        case .RateShipper:
            return "Rate Shipper"
            
        }
    }
}
