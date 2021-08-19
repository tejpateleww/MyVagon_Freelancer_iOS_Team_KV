//
//  PostTruckViewController.swift
//  MyVagon
//
//  Created by Apple on 13/08/21.
//

import UIKit
import FSCalendar
import GoogleMaps
import GooglePlaces
class TruckTypeModel : NSObject {
    var truckData : TruckFeaturesDatum!
    var isSelected : Bool!
    
     init(TruckData:TruckFeaturesDatum,IsSelected:Bool) {
        self.truckData = TruckData
        self.isSelected = IsSelected
    }
}

enum PlacerPickerOpenFor:String {
    case StartLoction
    case EndLocation
}
class PostTruckViewController: BaseViewController,UITextFieldDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var postTruckViewModel = PostTruckViewModel()
    var customTabBarController: CustomTabBarVC?
    var arrTypes:[TruckTypeModel] = []
    
    var SelectedStartLocationCoordinate = CLLocationCoordinate2D()
    var SelectedEndLocationCoordinate = CLLocationCoordinate2D()
    var PlacerPickerFor = ""
    var SelectedTruckType = ""
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldSelectTime: themeTextfield!
    
    @IBOutlet weak var TextFieldStartLocation: themeTextfield!
    @IBOutlet weak var TextFieldEndLocation: themeTextfield!
    @IBOutlet weak var TextFieldEnterBidPrice: themeTextfield!
    @IBOutlet weak var TextFieldQuote: themeTextfield!
    
    
    
    @IBOutlet weak var ViewForAllowBiddingPrice: UIView!
    @IBOutlet weak var ViewForEnterQuote: UIView!
    
    @IBOutlet weak var SwitchAllowBidding: ThemeSwitch!
    
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
        TextFieldStartLocation.delegate = self
        TextFieldEndLocation.delegate = self
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
            arrTypes.append(TruckTypeModel(TruckData: element, IsSelected: false))
        })
        if arrTypes.count != 0 {
            for i in 0...arrTypes.count - 1 {
                if SingletonClass.sharedInstance.Reg_AdditionalTypes.contains(arrTypes[i].truckData.name ?? "") {
                    arrTypes[i].isSelected = true
                } else {
                    arrTypes[i].isSelected  = false
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
    
    func OpenPlacePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        present(autocompleteController, animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TextFieldStartLocation {
            PlacerPickerFor = PlacerPickerOpenFor.StartLoction.rawValue
            OpenPlacePicker()
        } else if textField == TextFieldEndLocation {
            PlacerPickerFor = PlacerPickerOpenFor.EndLocation.rawValue
            OpenPlacePicker()
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func BtnPostTruck(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            CallWebSerive()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
    }
   
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
    func CallWebSerive() {
        
        self.postTruckViewModel.postTruckViewController =  self
        
        
        let ReqModelForPostTruck = PostTruckReqModel()
        ReqModelForPostTruck.truck_type_id = SelectedTruckType
        ReqModelForPostTruck.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        
        ReqModelForPostTruck.date = LblSelectedDate.text?.ConvertDateFormat(FromFormat: "dd MMMM, yyyy", ToFormat: "yyyy-MM-dd")
        ReqModelForPostTruck.time = TextFieldSelectTime.text?.ConvertDateFormat(FromFormat: DateFormatterString.onlyTime.rawValue, ToFormat: "HH:mm:ss")
        
        ReqModelForPostTruck.start_lat = "\(SelectedStartLocationCoordinate.latitude)"
        ReqModelForPostTruck.start_lng = "\(SelectedStartLocationCoordinate.longitude)"
        
        ReqModelForPostTruck.end_lat = "\(SelectedEndLocationCoordinate.latitude)"
        ReqModelForPostTruck.end_lng = "\(SelectedEndLocationCoordinate.longitude)"
        
        if SwitchAllowBidding.isOn {
            ReqModelForPostTruck.is_bid = "1"
        } else {
            ReqModelForPostTruck.is_bid = "0"
        }
        
        ReqModelForPostTruck.bid_amount = "200"

        self.postTruckViewModel.PostAvailability(ReqModel: ReqModelForPostTruck)
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Validation ---------
    // ----------------------------------------------------
    func Validate() -> (Bool,String) {
        
        if arrTypes.count != 0 {
            for i in 0...arrTypes.count {
                if i == arrTypes.count {
                    return (false,"Please select truck type")
                } else {
                    if arrTypes[i].isSelected == true {
                        break
                    }
                }
            }
        }
        
        if LblSelectedDate.text?.lowercased() == "selected date" {
            return (false,"Please select date")
        } else if TextFieldSelectTime.text == "" || TextFieldSelectTime.text?.lowercased() == "select time" {
            return (false,"Please select time")
        } else if TextFieldStartLocation.text == "" {
            return (false,"Please select start location")
        } else if TextFieldEndLocation.text == "" {
            return (false,"Please select end location")
        } else {
            if SwitchAllowBidding.isOn {
                let CheckBidPrice = TextFieldEnterBidPrice.validatedText(validationType: ValidatorType.requiredField(field: "bid starting price"))
                
                if(!CheckBidPrice.0){
                    return (CheckBidPrice.0,CheckBidPrice.1)
                }
            } else {
                let CheckQuote = TextFieldQuote.validatedText(validationType: ValidatorType.requiredField(field: "quote"))
                
                if(!CheckQuote.0){
                    return (CheckQuote.0,CheckQuote.1)
                }
            }
        }
        return (true,"")
    }

}

//----------------------------------------------------
// MARK: - --------- Calender delegate Methods ---------
// ----------------------------------------------------

extension PostTruckViewController: GMSAutocompleteViewControllerDelegate{
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if PlacerPickerFor == PlacerPickerOpenFor.StartLoction.rawValue {
            let tempAddres:String = "\(place.formattedAddress ?? "")"
             self.TextFieldStartLocation.text = tempAddres
            SelectedStartLocationCoordinate = place.coordinate
            print(place.coordinate)
        } else if PlacerPickerFor == PlacerPickerOpenFor.EndLocation.rawValue {
            let tempAddres:String = "\(place.formattedAddress ?? "")"
             self.TextFieldEndLocation.text = tempAddres
            SelectedEndLocationCoordinate = place.coordinate
            print(place.coordinate)
        }
      
      dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
}


//----------------------------------------------------
// MARK: - --------- Calender delegate Methods ---------
// ----------------------------------------------------

extension PostTruckViewController: FSCalendarDelegate, FSCalendarDataSource{
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    
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
            return CGSize(width: ((arrTypes[indexPath.row].truckData.name?.capitalized ?? "").sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                          , height: ColTypes.frame.size.height - 10)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ColTypes{
            let cell = ColTypes.dequeueReusableCell(withReuseIdentifier: "TypesColCell", for: indexPath) as! TypesColCell
            cell.lblTypes.text = arrTypes[indexPath.row].truckData.name ?? ""
            cell.BGView.layer.cornerRadius = 17
            if arrTypes[indexPath.row].isSelected {
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
        arrTypes.forEach({$0.isSelected = false})
        arrTypes[indexPath.row].isSelected = true
        SelectedTruckType = "\(arrTypes[indexPath.row].truckData.id ?? 0)"
            ColTypes.reloadData()
        
        
        
        
    }
  
    
}
