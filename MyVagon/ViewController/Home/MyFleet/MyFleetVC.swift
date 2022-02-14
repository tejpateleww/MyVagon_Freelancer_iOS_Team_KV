//
//  MyFleetVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/01/22.
//

import UIKit


enum SelectionBtn: Int {
    case Drivers
    case Vehicles
   
}

enum status : String{
    case Available = "Available"
    case loaded = "Loaded"
    case NotAssigned = "Not Assigned"
    
    func colourOfStatus(AvailableStatus:status) -> UIColor {
        switch AvailableStatus {
        case .Available:
            return UIColor(hexString: ThemeColor.themeGreen.rawValue)
        case .loaded:
            return UIColor(hexString: "#DBA539")
        case .NotAssigned:
            return UIColor(hexString: ThemeColor.themeRed.rawValue)
        }
    }
}

class DriversModel {
    var status : status!
    
    init(Status : status) {
        self.status = Status
    }
}

class MyFleetVC: BaseViewController {

    //MARK: - ==== Outlets =====
    @IBOutlet weak var viewTabView: UIView!
    @IBOutlet weak var tblFleet: UITableView!
    @IBOutlet weak var leadingConstraintView: NSLayoutConstraint!
    @IBOutlet weak var btnDriver: UIButton!
    @IBOutlet weak var btnVehicle: UIButton!
    @IBOutlet weak var btnAddVehicle: themeButton!
    
    
    //MARK: - ==== Variables =====
    var statusClr : status = .Available
    var arrDrivers = [DriversModel(Status:.Available) , DriversModel(Status:.NotAssigned) , DriversModel(Status: .loaded)]
    var tabTypeSelection = SelectionBtn(rawValue: 0)
    {
        didSet
        {
            switch tabTypeSelection {
            case .Drivers:
                btnAddVehicle.setTitle("+ Add Driver", for: .normal)
            case .Vehicles:
                btnAddVehicle.setTitle("+ Add Vehicle", for: .normal)
            case .none:
                break
            }
           self.tblFleet.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblFleet.register(UINib(nibName: "VehiclesTableViewCell", bundle: nil), forCellReuseIdentifier: "VehiclesTableViewCell")
        tblFleet.register(UINib(nibName: "DriversTableViewCell", bundle: nil), forCellReuseIdentifier: "DriversTableViewCell")
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Fleet", leftImage: "", rightImages:[], isTranslucent: true, ShowShadow: true)
        tabTypeSelection = .Drivers
        btnSelectionSetup(btnSelected:btnDriver,btnUnselected:btnVehicle)
        tblFleet.reloadData()
    }
    
    //MARK: - ==== Select/Unselect Button setup==
    func btnSelectionSetup(btnSelected:UIButton,btnUnselected:UIButton){
        btnSelected.isSelected = true
        btnUnselected.isSelected = false
        btnSelected.setTitleColor(UIColor(hexString: "#1F1F3F"), for: .normal)
        btnUnselected.setTitleColor(UIColor.lightGray, for: .normal)
        btnUnselected.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(16.0)
        btnSelected.titleLabel?.font = CustomFont.PoppinsSemiBold.returnFont(16.0)
        self.leadingConstraintView.constant = btnSelected.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
    }
    
    //MARK: - ==== Btn Action Driver Selction==
    @IBAction func btnActionDriver(_ sender: UIButton) {
        self.tabTypeSelection = .Drivers
        btnSelectionSetup(btnSelected: btnDriver, btnUnselected: btnVehicle)
    }
    
    //MARK: - ==== Btn Action Vehicle Selction==
    @IBAction func btnActionVehicle(_ sender: UIButton) {
        self.tabTypeSelection = .Vehicles
        btnSelectionSetup(btnSelected: btnVehicle, btnUnselected: btnDriver)
    }
      
    
    //MARK: - ==== Btn Action Add Vehicle =====
    @IBAction func btnActionAddVehicle(_ sender: UIButton) {
        switch tabTypeSelection {
        case .Drivers:
            let addDriverVC = AddDriverVC.instantiate(fromAppStoryboard: .Home)
            self.navigationController?.pushViewController(addDriverVC, animated: true)
        case .Vehicles:
            let addVehicleVC = AddVehicleVC.instantiate(fromAppStoryboard: .Home)
            self.navigationController?.pushViewController(addVehicleVC, animated: true)
        default:
            break
        }
    }
}

//MARK: - ===== TableView DataSource and Delegate ========
extension MyFleetVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDrivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tabTypeSelection {
        case .Drivers:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DriversTableViewCell", for: indexPath) as! DriversTableViewCell
            cell.viewEdit.isHidden = arrDrivers[indexPath.row].status == .Available ? false : true
            cell.lblAvailable.isHidden = arrDrivers[indexPath.row].status == .Available ?  false : true
            cell.lblAssigned.isHidden = arrDrivers[indexPath.row].status == .NotAssigned ?  false : true
            cell.lblLoaded.isHidden = arrDrivers[indexPath.row].status == .loaded ?  false : true
            cell.clickEdit = {
                let driverPermissionVC = DriverPermissionVC.instantiate(fromAppStoryboard: .Home)
                self.navigationController?.pushViewController(driverPermissionVC, animated: true)
            }
            return cell
        case .Vehicles:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclesTableViewCell", for: indexPath) as! VehiclesTableViewCell
            return cell
        default :
            break
        }
       return UITableViewCell()
    }
}
