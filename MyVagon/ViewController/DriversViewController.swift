//
//  DriversViewController.swift
//  MyVagon
//
//  Created by Apple on 18/10/21.
//

import UIKit
class DriverCell : UITableViewCell {
    
    var editPermissionClosour : (() -> ())?
    
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBAction func btnEditPermissionClick(_ sender: Any) {
        if let click = self.editPermissionClosour {
            click()
        }
        
    }
}

class DriversViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var driverListViewModel = DriverListViewModel()
    var customTabBarController: CustomTabBarVC?
    var arrDriverList : [DriverListDatum]?
    var refreshControl = UIRefreshControl()
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblDrivers: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Drivers", leftImage: NavItemsLeft.none.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = RefreshControlColor
        self.tblDrivers.refreshControl = refreshControl
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "GetDriverList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GetDriverListNotification), name: NSNotification.Name(rawValue: "GetDriverList"), object: nil)
       GetDriverList()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        self.customTabBarController?.hideTabBar()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func GetDriverList() {
        self.driverListViewModel.driversViewController = self
        
        let ReqModelToGetDriverList = GetDriverListReqModel()
        ReqModelToGetDriverList.user_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        
        
        self.driverListViewModel.GetDriverList(ReqModel: ReqModelToGetDriverList)
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        GetDriverList()
        
    }
    @objc func GetDriverListNotification(){
        GetDriverList()
       }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func btnLogoutClick(_ sender: themeButton) {
        appDel.Logout()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
extension DriversViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDriverList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDrivers.dequeueReusableCell(withIdentifier: "DriverCell", for: indexPath) as! DriverCell
        cell.lblName.text = arrDriverList?[indexPath.row].name ?? ""
        cell.editPermissionClosour = {
            let controller = AppStoryboard.Dispatcher.instance.instantiateViewController(withIdentifier: ChangePermissionViewController.storyboardID) as! ChangePermissionViewController
            controller.DriverData = self.arrDriverList?[indexPath.row]
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
            
        }
        return cell
    }
    
    
}
