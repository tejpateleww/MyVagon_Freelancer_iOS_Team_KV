//
//  ViewLoadAllScreenVC1.swift
//  MyVagon
//
//  Created by Admin on 11/08/21.
//

import UIKit
import FSCalendar
import DropDown
enum MyLoadesStatus {
  
    case all,pending,scheduled,inprocess,completed,canceled
    
    
    var Name:String {
        switch self {
        case .all:
            return "all"
        case .pending:
            return "pending"
        case .scheduled:
            return "scheduled"
        case .inprocess:
            return "in-process"
        case .completed:
            return "completed"
        case .canceled:
            return "canceled"
        }
    }
}

class ScheduleViewController: BaseViewController {

    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var tblLocations: UITableView!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var collectionOfHistory: UICollectionView!
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    let chooseDropDown = DropDown()
    
    var CurrentFilterStatus : MyLoadesStatus = .all
    
    var myLoadsViewModel = MyLoadsViewModel()
    var refreshControl = UIRefreshControl()
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var customTabBarController: CustomTabBarVC?
    var tblCellHeight = CGFloat()
    var arrStatus:[MyLoadesStatus] = [.all,.pending,.scheduled,.inprocess,.completed,.canceled]
   
    var selectedIndex = 0
    var arrMyLoadesData : [MyLoadsDatum]?
    var optionArray : [String] = ["All","Bid","Book","Posted truck"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChooseDropDown()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTblHeight(_:)), name: NSNotification.Name(NotificationKeys.KGetTblHeight), object: nil)
        tblLocations.register(UINib(nibName: "MyLoadesCell", bundle: nil), forCellReuseIdentifier: "MyLoadesCell")
        
        tblLocations.register(UINib(nibName: "NoBookingTblCell", bundle: nil), forCellReuseIdentifier: "NoBookingTblCell")
        
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Loads", leftImage: NavItemsLeft.none.value, rightImages:  [NavItemsRight.option.value], isTranslucent: true, ShowShadow: false)
        
       
        calender.accessibilityIdentifier = "calender"
        calender.delegate = self
        calender.dataSource = self
        
//        btnOptionClosour = { [self] in
//
////            picker = UIPickerView.init()
////            picker.delegate = self
////            picker.dataSource = self
////            picker.backgroundColor = UIColor.white
////            picker.setValue(UIColor.black, forKey: "textColor")
////            picker.autoresizingMask = .flexibleWidth
////            picker.contentMode = .center
////            picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
////            self.view.addSubview(picker)
////
////            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
////            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
////            self.view.addSubview(toolBar)
//        }
        
        DispatchQueue.main.async {
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.reloadData()
        }
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = RefreshControlColor
        self.tblLocations.refreshControl = refreshControl
        
        CallWebSerive(status: CurrentFilterStatus)
        
        btnOptionClosour = {
            self.chooseDropDown.show()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    @objc func getTblHeight(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
            if let dict = notification.userInfo as NSDictionary? {
                if let height = dict["TblHeight"] as? CGFloat{
                    
                    tblCellHeight = height
                    tblLocations.reloadData()
                   // tblLocations.reloadRows(at: [ind?.row], with: .automatic)
                }
            }
     }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        CallWebSerive(status: CurrentFilterStatus)
        
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    func CallWebSerive(status:MyLoadesStatus) {
    
        self.myLoadsViewModel.scheduleViewController =  self
        
        let ReqModelForMyLoades = MyLoadsReqModel()
        
        ReqModelForMyLoades.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        ReqModelForMyLoades.date = ""
        ReqModelForMyLoades.status = status.Name
//        ReqModelForGetShipment.driver_id = "271"
        
     

        self.myLoadsViewModel.getMyloads(ReqModel: ReqModelForMyLoades)
        
    }
    
    func setupChooseDropDown() {
        chooseDropDown.anchorView = btnOption
        
        // By default, the dropdown will have its origin on the top left corner of its anchor view
        // So it will come over the anchor view and hide it completely
        // If you want to have the dropdown underneath your anchor view, you can do this:
      
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        chooseDropDown.dataSource = optionArray
        
        // Action triggered on selection
        chooseDropDown.selectionAction = { [weak self] (index, item) in
         print(item)
        }
    }
}
extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        print(date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
}
extension ScheduleViewController : UITableViewDataSource , UITableViewDelegate {
    
 
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if arrMyLoadesData?.count != 0
           {
               //tableView.separatorStyle = .singleLine
            numOfSections            = arrMyLoadesData?.count ?? 0
               tableView.backgroundView = nil
           }
           else
           {
               let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
               noDataLabel.text          = "No Records Found"
               noDataLabel.font = CustomFont.PoppinsRegular.returnFont(14)
               noDataLabel.textColor     = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
               noDataLabel.textAlignment = .center
               tableView.backgroundView  = noDataLabel
               tableView.separatorStyle  = .none
           }
           return numOfSections
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyLoadesData?[section].loadsData?.count ?? 0
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.postAvailibility ?? 0 == 1 {
           
            if indexPath.section == 1 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "NoBookingTblCell", for: indexPath) as! NoBookingTblCell
                
                cell.selectionStyle = .none
                return cell
            }
            else {
                
                let cell =  tableView.dequeueReusableCell(withIdentifier: "MyLoadesCell", for: indexPath) as! MyLoadesCell
                   cell.PickUpDropOffData = arrMyLoadesData?[indexPath.section].loadsData?[indexPath.row].trucks?.locations
                   
                   cell.myloadDetails = arrMyLoadesData?[indexPath.section].loadsData?[indexPath.row]
                   
                   cell.tblHeight = { (heightTBl) in
                       self.tblLocations.layoutIfNeeded()
                       self.tblLocations.layoutSubviews()
                   }
                   cell.tblMultipleLocation.reloadData()
                   cell.tblMultipleLocation.layoutIfNeeded()
                   cell.tblMultipleLocation.layoutSubviews()
              
                return cell
                
            }
         
       } else {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "MyLoadesCell", for: indexPath) as! MyLoadesCell
           cell.PickUpDropOffData = arrMyLoadesData?[indexPath.section].loadsData?[indexPath.row].trucks?.locations
           
           cell.myloadDetails = arrMyLoadesData?[indexPath.section].loadsData?[indexPath.row]
           
           cell.tblHeight = { (heightTBl) in
               self.tblLocations.layoutIfNeeded()
               self.tblLocations.layoutSubviews()
           }
           cell.tblMultipleLocation.reloadData()
           cell.tblMultipleLocation.layoutIfNeeded()
           cell.tblMultipleLocation.layoutSubviews()
      
      
          
        return cell
        

       }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(tblLocations.frame.height)
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.postAvailibility ?? 0 == 1 {
            if indexPath.section == 1 {
                return 100
            }
            return UITableView.automaticDimension
        } else {
            
            return UITableView.automaticDimension
        }
        
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrMyLoadesData?[section].date ?? ""
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
        label.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
        label.text = arrMyLoadesData?[section].date ?? ""
        label.textAlignment = .center
        label.font = CustomFont.PoppinsMedium.returnFont(FontSize.size15.rawValue)
        label.textColor = UIColor(hexString: "#292929")
        label.drawLineOnBothSides(labelWidth: label.frame.size.width, color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1))
        headerView.addSubview(label)
        
        return headerView
               
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let controller = PostTruckViewController.instantiate(fromAppStoryboard: .Home)
                controller.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        

    }
}

extension ScheduleViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.lblStatus.text = arrStatus[indexPath.row].Name.capitalized
        cell.lblStatus.textColor =  selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor(hexString: "#9A9AA9")
        cell.viewBG.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((arrStatus[indexPath.row].Name.capitalized).sizeOfString(usingFont: CustomFont.PoppinsRegular.returnFont(14)).width) + 30
                      , height: collectionOfHistory.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CurrentFilterStatus = arrStatus[indexPath.row]
        CallWebSerive(status: CurrentFilterStatus)
        selectedIndex = indexPath.row
        collectionOfHistory.reloadData()
        tblLocations.reloadData()
        
    }

}
extension ScheduleViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionArray.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionArray[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(optionArray[row])
    }
    
    
  
}
