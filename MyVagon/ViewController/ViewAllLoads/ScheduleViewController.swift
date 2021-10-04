//
//  ViewLoadAllScreenVC1.swift
//  MyVagon
//
//  Created by Admin on 11/08/21.
//

import UIKit
import FSCalendar

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
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var customTabBarController: CustomTabBarVC?
    var tblCellHeight = CGFloat()
    var arrStatus = ["All","Pending","Scheduled","In-Progress","Past"]
    var arrSection = ["Today" , "20th March'21" , "22Th March'21"]
    var selectedIndex = 1
    
    var optionArray : [String] = ["All","Bid","Book","Posted truck"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NotificationKeys.KGetTblHeight), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTblHeight(_:)), name: NSNotification.Name(NotificationKeys.KGetTblHeight), object: nil)
        tblLocations.register(UINib(nibName: "PickUpDropOffCell", bundle: nil), forCellReuseIdentifier: "PickUpDropOffCell")
        
        tblLocations.register(UINib(nibName: "NoBookingTblCell", bundle: nil), forCellReuseIdentifier: "NoBookingTblCell")
        
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Loads", leftImage: NavItemsLeft.none.value, rightImages: [NavItemsRight.search.value,NavItemsRight.option.value], isTranslucent: true, ShowShadow: false)
        
       
        calender.accessibilityIdentifier = "calender"
        calender.delegate = self
        calender.dataSource = self
        
        btnOptionClosour = { [self] in
            picker = UIPickerView.init()
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = UIColor.white
            picker.setValue(UIColor.black, forKey: "textColor")
            picker.autoresizingMask = .flexibleWidth
            picker.contentMode = .center
            picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
            self.view.addSubview(picker)
                    
            toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
            toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
            self.view.addSubview(toolBar)
        }
        
        DispatchQueue.main.async {
            self.tblLocations.layoutIfNeeded()
            self.tblLocations.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.showTabBar()
    }
    
    @objc func getTblHeight(_ notification: NSNotification) {
            print(notification.userInfo ?? "")
            if let dict = notification.userInfo as NSDictionary? {
                if let height = dict["TblHeight"] as? CGFloat{
                     print(height)
                   let ind = dict["indexPath"] as? IndexPath
                    print(ind)
                    
                    tblCellHeight = height
                    tblLocations.reloadData()
                   // tblLocations.reloadRows(at: [ind?.row], with: .automatic)
                }
            }
     }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
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
        return arrSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2 :
            return 2
        default:
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "NoBookingTblCell", for: indexPath) as! NoBookingTblCell
            
            cell.selectionStyle = .none
            return cell
        }
        else {
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "PickUpDropOffCell", for: indexPath) as! PickUpDropOffCell
            switch arrStatus[selectedIndex] {
            case arrStatus[0]:
              
                break
            case arrStatus[1]:
                
                break
            case arrStatus[2]:
             
                break
            case arrStatus[3]:
             
                break
            case arrStatus[4]:
               
                break
            default:
                break
            }
            cell.isFromBidRequest = true
            print(tblLocations.rowHeight)
            cell.ReloadAllData()
     
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(tblLocations.frame.height)
        
        if indexPath.section == 1 {
            return 100
        }
        return UITableView.automaticDimension
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrSection[section]
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor(hexString: "#FAFAFA")
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
        label.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
        label.text = arrSection[section]
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
        cell.lblStatus.text = arrStatus[indexPath.row]
        cell.lblStatus.textColor =  selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor(hexString: "#9A9AA9")
        cell.viewBG.backgroundColor = selectedIndex == indexPath.row ? UIColor(hexString: "#9B51E0") : UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((arrStatus[indexPath.row].capitalized).sizeOfString(usingFont: CustomFont.PoppinsRegular.returnFont(14)).width) + 30
                      , height: collectionOfHistory.frame.size.height - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
