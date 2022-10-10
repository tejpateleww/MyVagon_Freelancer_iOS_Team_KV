//
//  DriverPermissionVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 27/01/22.
//

import UIKit

class DriverPermissionVC: BaseViewController {

    //MARK: === Outlets ======
    @IBOutlet weak var tblDriverPermission: UITableView!
    var arrPermission = [NotificationData(Title: "Biding allowed", IsSelect: false),
                         NotificationData(Title: "Post Availability", IsSelect: false),
                         NotificationData(Title: "Search load", IsSelect: false),
                         NotificationData(Title: "View price", IsSelect: false),
                         NotificationData(Title: "Book Load", IsSelect: false)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Driver Permission", leftImage: NavItemsLeft.back.value, rightImages:[], isTranslucent: true, ShowShadow: true)
        tblDriverPermission.reloadData()
    }
}

//MARK: === TableView DataSource and Delegte  ======
extension DriverPermissionVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPermission.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PermissionTblCell", for: indexPath) as! PermissionTblCell
        cell.lblTitle.text = arrPermission[indexPath.row].title
        return cell
    }
}

// ----------------------------------------------------
// MARK: - --------- Setting TblCell ---------
// ----------------------------------------------------
class PermissionTblCell : UITableViewCell {
    
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
