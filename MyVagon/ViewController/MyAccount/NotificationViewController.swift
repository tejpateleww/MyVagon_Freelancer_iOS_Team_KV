//
//  NotificationViewController.swift
//  MyVagon
//
//  Created by Apple on 13/08/21.
//

import UIKit

class NotificationViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var notificationListViewModel = NotificationListViewModel()
    var isLoading = true {
        didSet {
            TblNotification.isUserInteractionEnabled = !isLoading
            TblNotification.reloadData()
        }
    }
    
    var arrNotification : [NotificationListData]?
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var TblNotification: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TblNotification.delegate = self
        TblNotification.dataSource = self
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Notifications", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        callAPI()
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
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------

    func callAPI() {
        self.notificationListViewModel.notificationViewController =  self
        
        self.notificationListViewModel.WebServiceForNotificationList()
    }
    

}
// ----------------------------------------------------
// MARK: - --------- Table View methods ---------
// ----------------------------------------------------
extension NotificationViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 10
        }
        
     
        var numOfSections: Int = 0
        
        if arrNotification?.count != 0
        {
            numOfSections            = arrNotification?.count ?? 0
                tableView.backgroundView = nil
        }
        else
        {
            TblNotification.noDataFound(lblText: "No Notifcation Found")
        }
        return numOfSections
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TblNotification.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.LblCount.isHidden = true
        if !isLoading {
            cell.LblTitle.text = arrNotification?[indexPath.row].title ?? ""
            cell.LblDescription.text = arrNotification?[indexPath.row].message ?? ""
            cell.LblDate.text = (arrNotification?[indexPath.row].date ?? "").ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
            //cell.LblCount.isHidden = (arrNotification?[indexPath.row].readStatus == 0) ? false : true
            
            
        } else {
            cell.LblCount.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, viewBackgroundColor: .systemBackground)
        
    }
    
}
class NotificationCell : UITableViewCell {
    @IBOutlet weak var LblTitle: themeLabel!
    @IBOutlet weak var LblDate: themeLabel!
    @IBOutlet weak var LblDescription: themeLabel!
    @IBOutlet weak var LblCount: themeLabel!
}
