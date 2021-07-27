//
//  TruckDetailVC.swift
//  MyVagon
//
//  Created by Admin on 27/07/21.
//

import UIKit

// ----------------------------------------------------
// MARK: - --------- Types TableView Cell ---------
// ----------------------------------------------------
class TypesTblCell : UITableViewCell {
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var lblTypes: UILabel!
    
    @IBOutlet weak var btnSelectType: UIButton!
    
    @IBAction func btnActionSelectType(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}


//MARK:- ========= Enum Tab Type ======
enum Tabselect: Int {
    case Diesel
    case Electrical
    case Hydrogen
    
}

class TruckDetailVC: BaseViewController {
    
    
    //    ----------------------------------------------------
    // MARK: - --------- Variables ---------
    
    var tabTypeSelection = Tabselect(rawValue: 0)
    var arrTypes = ["Hydraulic Door","Cooling"]
    var selectedIndex = NSNotFound
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet var viewTabView: UIView!
    @IBOutlet weak var tblTypes: UITableView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        tblTypes.reloadData()
        conHeightOfTbl.constant = tblTypes.contentSize.height
        for i in btnSelection{
            if i.tag == 0 {
                i.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
                selectedBtnUIChanges(Selected: true, Btn: i)
            }
            else {
                selectedBtnUIChanges(Selected: false, Btn:i)
            }
        }
        
        
    }
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnContinueClick(_ sender: themeButton) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: IdentifyYourselfVC.storyboardID) as! IdentifyYourselfVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnTabSelection(_ sender: UIButton) {
        let _ = btnSelection.map{$0.isSelected = false}
        for i in btnSelection{
            selectedBtnUIChanges(Selected: false, Btn: i)
        }
        if(sender.tag == 0)
        {
            selectedBtnUIChanges(Selected: true, Btn:sender)
            self.tabTypeSelection = .Diesel
            
        }
        else  if(sender.tag == 1)
        {
            self.tabTypeSelection = .Electrical
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        else  if(sender.tag == 2)
        {
            self.tabTypeSelection = .Hydrogen
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        
        
        self.btnLeadingConstaintOfAnimationView.constant = sender.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
    }
    
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
}

//----------------------------------------------------
// MARK: - --------- Tableview Methods ---------
// ----------------------------------------------------
extension TruckDetailVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypesTblCell") as! TypesTblCell
        cell.btnSelectType.isUserInteractionEnabled = false
        cell.lblTypes.text = arrTypes[indexPath.row]
        cell.btnSelectType.isSelected = selectedIndex == indexPath.row ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblTypes.reloadData()
    }
    
    
    
}
