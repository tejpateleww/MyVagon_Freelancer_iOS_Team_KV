//
//  PostTruckViewController.swift
//  MyVagon
//
//  Created by Apple on 13/08/21.
//

import UIKit
import FSCalendar
class PostTruckViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var customTabBarController: CustomTabBarVC?
    var arrTypes:[(String,Bool)] = []
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldSelectTime: themeTextfield!
    @IBOutlet weak var ViewForAllowBiddingPrice: UIView!
    @IBOutlet weak var ViewForEnterQuote: UIView!
    
    @IBOutlet weak var SwitchAllowBidding: UISwitch!
    
    @IBOutlet weak var LblSelectedDate: themeLabel!
    
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var ColTypes: UICollectionView!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetValue()
        
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Post truck", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        SwitchAllowBidding.isSelected = true
        SingletonClass.sharedInstance.TruckFeatureList?.forEach({ element in
            arrTypes.append((element.name ?? "",false))
        })
        if arrTypes.count != 0 {
            for i in 0...arrTypes.count - 1 {
                if SingletonClass.sharedInstance.Reg_AdditionalTypes.contains(arrTypes[i].0) {
                    arrTypes[i].1 = true
                } else {
                    arrTypes[i].1  = false
                }
            }
        }
     
        calender.delegate = self
        calender.dataSource = self
        
        ColTypes.delegate = self
        ColTypes.dataSource = self
        ColTypes.reloadData()
        view.layoutIfNeeded()
        
        TextFieldSelectTime.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .time, MinDate: true, MaxDate: true)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
   
    @objc func btnDoneDatePickerClicked() {
        if let datePicker = self.TextFieldSelectTime.inputView as? UIDatePicker {
            
                let formatter = DateFormatter()
                formatter.dateFormat = DateFormatterString.onlyTime.rawValue
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            TextFieldSelectTime.text = formatter.string(from: datePicker.date)
          
        }
        self.TextFieldSelectTime.resignFirstResponder() // 2-5
        

    }
    @IBAction func SwitchAllowBiddingAction(_ sender: UISwitch) {
        
        if sender.isOn {
            ViewForEnterQuote.isHidden = true
            ViewForAllowBiddingPrice.isHidden = false
        } else {
            ViewForEnterQuote.isHidden = false
            ViewForAllowBiddingPrice.isHidden = true
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    

}
//----------------------------------------------------
// MARK: - --------- Calender delegate Methods ---------
// ----------------------------------------------------

extension PostTruckViewController: FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter1 = DateFormatter()
         formatter1.dateStyle = .medium
         formatter1.dateFormat = "dd MMMM, yyyy"
         
         let selectedDate = formatter1.string(from: date)
        
        LblSelectedDate.text = selectedDate
        print(date)
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
}
//----------------------------------------------------
// MARK: - --------- Collectionview Methods ---------
// ----------------------------------------------------
extension PostTruckViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ColTypes{
            return arrTypes.count
        }
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ColTypes{
            return CGSize(width: ((arrTypes[indexPath.row].0.capitalized).sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                          , height: ColTypes.frame.size.height - 10)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ColTypes{
            let cell = ColTypes.dequeueReusableCell(withReuseIdentifier: "TypesColCell", for: indexPath) as! TypesColCell
            cell.lblTypes.text = arrTypes[indexPath.row].0
            cell.BGView.layer.cornerRadius = 17
            if arrTypes[indexPath.row].1 {
                print("Here come with index :: \(indexPath.row)")
                cell.BGView.layer.borderWidth = 0
                cell.BGView.backgroundColor = UIColor.appColor(.themeColorForButton).withAlphaComponent(0.5)
                cell.BGView.layer.borderColor = UIColor.appColor(.themeColorForButton).cgColor
               
            } else {
               
                cell.BGView.layer.borderWidth = 1
                cell.BGView.backgroundColor = .clear
                
                cell.BGView.layer.borderColor = UIColor.appColor(.themeLightBG).cgColor
                cell.lblTypes.textColor = UIColor.appColor(.themeButtonBlue)
            }
            
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ColTypes{
            if arrTypes[indexPath.row].1 {
                arrTypes[indexPath.row].1 = false
            } else {
                arrTypes[indexPath.row].1 = true
            }
            
            ColTypes.reloadData()
        }
        
        
        
    }
  
    
}
