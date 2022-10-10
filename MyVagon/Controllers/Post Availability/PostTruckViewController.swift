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

class PostTruckViewController: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var lblTruckType: themeLabel!
    @IBOutlet weak var TextFieldSelectTime: themeTextfield!
    @IBOutlet weak var TextFieldStartLocation: themeTextfield!
    @IBOutlet weak var TextFieldEndLocation: themeTextfield!
    @IBOutlet weak var TextFieldEnterBidPrice: themeTextfield!
    @IBOutlet weak var TextFieldQuote: themeTextfield!
    @IBOutlet weak var ViewForAllowBiddingPrice: UIView!
    @IBOutlet weak var ViewForEnterQuote: UIView!
    @IBOutlet weak var SwitchAllowBidding: ThemeSwitch!
    @IBOutlet weak var LblSelectedDate: themeLabel!
    @IBOutlet weak var BtnPostATruck: themeButton!
    @IBOutlet weak var conHeightOfCalender: NSLayoutConstraint!
    @IBOutlet weak var calender: ThemeCalender!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var lblTitleTruckType: themeLabel!
    @IBOutlet weak var lblStartTime: themeLabel!
    @IBOutlet weak var lblStartDate: themeLabel!
    @IBOutlet weak var lblStartLocation: themeLabel!
    @IBOutlet weak var lblEndLocation: themeLabel!
    @IBOutlet weak var lblAllowBidding: UILabel!
    @IBOutlet weak var lblBidStartPrice: themeLabel!
    @IBOutlet weak var lblQuote: themeLabel!
    
    var postTruckViewModel = PostTruckViewModel()
    var customTabBarController: CustomTabBarVC?
    var arrTypes:[TruckTypeModel] = []
    var SelectedStartLocationCoordinate = CLLocationCoordinate2D()
    var SelectedEndLocationCoordinate = CLLocationCoordinate2D()
    var PlacerPickerFor = ""
    var SelectedTruckType = ""
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        self.setLocalization()
    }
    
    //MARK: - Custom method
    func setUpUI(){
        self.SetValue()
        self.TextFieldStartLocation.delegate = self
        self.TextFieldEndLocation.delegate = self
        self.TextFieldEnterBidPrice.delegate = self
        self.TextFieldQuote.delegate = self
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Post Availability".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.addObserver()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.lblTitleTruckType.text = "Truck Type".localized
        self.lblStartDate.text = "Start Date".localized
        self.lblStartTime.text = "Start Time".localized
        self.lblStartLocation.text = "Start Location".localized
        self.TextFieldStartLocation.placeholder = "Nearest Location".localized
        self.lblEndLocation.text = "End Location".localized
        self.TextFieldEndLocation.placeholder = "Nearest Location".localized
        self.lblAllowBidding.text = "Allow Bidding :".localized
        self.lblBidStartPrice.text = "Bid Starting Price".localized
        self.lblQuote.text = "Quote".localized
        self.TextFieldEnterBidPrice.placeholder = "Enter Bid Starting Price".localized
        self.TextFieldQuote.placeholder = "Enter Quote".localized
        self.BtnPostATruck.setTitle("Post a Truck".localized, for: .normal)
    }
    
    func SetValue() {
        self.lblTruckType.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.getName() ?? ""
        self.SwitchAllowBidding.isSelected = true
        if(SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory != nil){
            arrTypes.append(TruckTypeModel(TruckData: (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory)!, IsSelected: false))
        }
        self.calender.select(Date())
        self.calender.today = Date()
        self.calender.delegate = self
        self.calender.dataSource = self
        self.calender.appearance.todayColor = UIColor.clear
        self.calender.appearance.titleTodayColor = .black
        self.calender.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        self.SwitchAllowBidding.isOn = true
        self.ViewForEnterQuote.isHidden = true
        self.ViewForAllowBiddingPrice.isHidden = false
        let formatter1 = DateFormatter()
        formatter1.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        formatter1.dateStyle = .medium
        formatter1.dateFormat = DateFormatForDisplay
        let selectedDate = formatter1.string(from: Date())
        self.LblSelectedDate.text = selectedDate
        self.ColTypes.delegate = self
        self.ColTypes.dataSource = self
        self.ColTypes.reloadData()
        view.layoutIfNeeded()
        self.TextFieldSelectTime.text = Utilities.GetCurrentTime()
        self.TextFieldSelectTime.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .time, MinDate: false, MaxDate: true)
    }
    
    func OpenPlacePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.autocompleteFilter?.type = .city
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func getCurrentData() -> Date{
        let dateFormatterUK = DateFormatter()
        dateFormatterUK.dateFormat = DateFormatForDisplay
        let stringDate = LblSelectedDate.text ?? ""
        let date = dateFormatterUK.date(from: stringDate) ?? Date()
        let order = Calendar.current.compare(date, to: Date(), toGranularity: .day)
        if order == .orderedSame{
            return Date()
        }else{
            return date
        }
    }
    
    @objc func btnDoneDatePickerClicked() {
        if let datePicker = self.TextFieldSelectTime.inputView as? UIDatePicker {
            datePicker.minimumDate = getCurrentData()
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
            formatter.dateFormat = DateFormatterString.onlyTime.rawValue
//            formatter.amSymbol = "AM"
//            formatter.pmSymbol = "PM"
            TextFieldSelectTime.text = formatter.string(from: datePicker.date)
        }
        self.TextFieldSelectTime.resignFirstResponder() // 2-5
    }
    
    func Validate() -> (Bool,String) {
        if LblSelectedDate.text?.lowercased() == "selected date" {
            return (false,"Please_select_date".localized)
        } else if TextFieldSelectTime.text == "" || TextFieldSelectTime.text?.lowercased() == "select time" {
            return (false,"Please_select_time".localized)
        } else if TextFieldStartLocation.text == "" {
            return (false,"Please_select_start_location".localized)
        } else if TextFieldEndLocation.text == "" {
            if(SwitchAllowBidding.isOn){
                return(true,"")
            }else{
                return (false,"Please_select_end_location".localized)
            }
        } else {
            if SwitchAllowBidding.isOn {
                if(TextFieldEnterBidPrice.text == ""){
                    TextFieldEnterBidPrice.text = "0.0"
                }
            } else {
                let CheckQuote = TextFieldQuote.validatedText(validationType: ValidatorType.requiredField(field: "quote".localized))
                if(!CheckQuote.0){
                    return (CheckQuote.0,CheckQuote.1)
                }
            }
        }
        return (true,"")
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        inputFormatter.dateFormat = "h:mm a"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    //MARK: - IBAction method
    @IBAction func BtnPostTruck(_ sender: themeButton) {
        let CheckValidation = Validate()
        if CheckValidation.0 {
            CallWebSerive()
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
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
}

//MARK: - WebService method
extension PostTruckViewController{
    func CallWebSerive() {
        self.postTruckViewModel.postTruckViewController =  self
        let ReqModelForPostTruck = PostTruckReqModel()
        ReqModelForPostTruck.truck_type_id = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.id ?? 0)"
        ReqModelForPostTruck.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        ReqModelForPostTruck.date = LblSelectedDate.text?.ConvertDateFormat(FromFormat: DateFormatForDisplay, ToFormat: "yyyy-MM-dd")
        ReqModelForPostTruck.time = formattedDateFromString(dateString: TextFieldSelectTime.text ?? "", withFormat: "HH:mm:ss")?.trimmedString
        ReqModelForPostTruck.start_lat = "\(SelectedStartLocationCoordinate.latitude)"
        ReqModelForPostTruck.start_lng = "\(SelectedStartLocationCoordinate.longitude)"
        ReqModelForPostTruck.end_lat = "\(SelectedEndLocationCoordinate.latitude)"
        ReqModelForPostTruck.end_lng = "\(SelectedEndLocationCoordinate.longitude)"
        ReqModelForPostTruck.start_location = TextFieldStartLocation.text ?? ""
        ReqModelForPostTruck.end_location = TextFieldEndLocation.text ?? ""
        if SwitchAllowBidding.isOn {
            ReqModelForPostTruck.is_bid = "1"
        } else {
            ReqModelForPostTruck.is_bid = "0"
        }
        ReqModelForPostTruck.bid_amount = (SwitchAllowBidding.isOn == true) ? "\(TextFieldEnterBidPrice.text ?? "")" : "\(TextFieldQuote.text ?? "")"
        self.postTruckViewModel.PostAvailability(ReqModel: ReqModelForPostTruck)
    }
}

// MARK: - GMAutoComplete delegate methods
extension PostTruckViewController: GMSAutocompleteViewControllerDelegate{
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if PlacerPickerFor == PlacerPickerOpenFor.StartLoction.rawValue {
            let tempAddres:String = "\(place.formattedAddress ?? "")"
            self.TextFieldStartLocation.text = tempAddres
            SelectedStartLocationCoordinate = place.coordinate
        } else if PlacerPickerFor == PlacerPickerOpenFor.EndLocation.rawValue {
            let tempAddres:String = "\(place.formattedAddress ?? "")"
            self.TextFieldEndLocation.text = tempAddres
            SelectedEndLocationCoordinate = place.coordinate
        }
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
//        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Calendar delegate methods
extension PostTruckViewController: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance{
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let order = Calendar.current.compare(date, to: Date(), toGranularity: .day)
        if order == .orderedAscending{
            return .lightGray
        }
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let order = Calendar.current.compare(date, to: Date(), toGranularity: .day)
        var date = date
        var minDate = true
        if order == .orderedSame{
            date = Date()
        }else if order == .orderedAscending{
            let dateFormatterUK = DateFormatter()
            dateFormatterUK.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
            dateFormatterUK.dateFormat = DateFormatForDisplay
            let stringDate = LblSelectedDate.text ?? ""
            let date1 = dateFormatterUK.date(from: stringDate)!
            calendar.select(date1)
            date = date1
            minDate = false
        }
        let formatter1 = DateFormatter()
        formatter1.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
        formatter1.dateStyle = .medium
        formatter1.dateFormat = DateFormatForDisplay
        let selectedDate = formatter1.string(from: date)
        LblSelectedDate.text = selectedDate
        if minDate{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: UserDefaults.standard.string(forKey: LCLCurrentLanguageKey) ?? "el")
            formatter.dateFormat = DateFormatterString.onlyTime.rawValue
//            formatter.amSymbol = "AM"
//            formatter.pmSymbol = "PM"
            TextFieldSelectTime.text = formatter.string(from: date)
            TextFieldSelectTime.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .time, MinDate: false, MaxDate: true,date: date)
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.conHeightOfCalender.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
}

// MARK: - Collectionview datasource and delegate
extension PostTruckViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ColTypes{
            return arrTypes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ColTypes{
            return CGSize(width: ((arrTypes[indexPath.row].truckData?.getName().capitalized ?? "").sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                          , height: ColTypes.frame.size.height - 10)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ColTypes{
            let cell = ColTypes.dequeueReusableCell(withReuseIdentifier: "TypesColCell", for: indexPath) as! TypesColCell
            cell.lblTypes.text = arrTypes[indexPath.row].truckData?.getName()
            cell.BGView.layer.cornerRadius = 17
            if arrTypes[indexPath.row].isSelected {
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
}


//MARK: - TextField deletate
extension PostTruckViewController : UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == TextFieldEnterBidPrice || textField == TextFieldQuote{
            if textField.text?.count ?? 0 > 9{
                var text = textField.text ?? ""
                text.removeLast()
                textField.text = text
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == TextFieldStartLocation {
            PlacerPickerFor = PlacerPickerOpenFor.StartLoction.rawValue
            OpenPlacePicker()
            return false
        } else if textField == TextFieldEndLocation {
            PlacerPickerFor = PlacerPickerOpenFor.EndLocation.rawValue
            OpenPlacePicker()
            return false
        }
        return true
    }
}
