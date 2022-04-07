//
//  ProfileEditViewController.swift
//  MyVagon
//
//  Created by Apple on 05/10/21.
//

import UIKit
import MobileCoreServices
import SDWebImage
class ProfileEditViewController: BaseViewController , UITextFieldDelegate{

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var profileUpdateViewModel = ProfileUpdateViewModel()
    
    
    let GeneralPicker = GeneralPickerView()
    var customTabBarController: CustomTabBarVC?
    
    var SelectedTextField : UITextField?
    
    var SelectedCategoryIndex = 0
    var SelectedSubCategoryIndex = 0
    
    var tabTypeSelection = Tabselect.Diesel.rawValue
    var arrImages : [String] = []
    var arrTypes:[(TruckFeaturesDatum,Bool)] = []
    var ButtonTypeForAddingCapacity : AddCapacityTypeButtonName?
    var selectedIndex = NSNotFound
    var SelectedIndexOfType = NSNotFound
    var TruckCapacityAdded : [TruckCapacityType] = [] {
        didSet {
            if TruckCapacityAdded.count == 0 {
                collectionTruckCapacity.isHidden = true
            } else {
                collectionTruckCapacity.isHidden = false
            }
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var ImageViewProfile: UIImageView!
    @IBOutlet weak var TextFieldFullName: themeTextfield!
    @IBOutlet weak var TextFieldMobileNumber: themeTextfield!
    @IBOutlet weak var TextFieldEmail: themeTextfield!
    @IBOutlet weak var TextFieldCategory: themeTextfield!
    @IBOutlet weak var TextFieldSubCategory: themeTextfield!
    @IBOutlet weak var TextFieldTruckPlatNumber: themeTextfield!
    @IBOutlet weak var TextFieldTrailerPlatNumber: themeTextfield!
    
    @IBOutlet weak var truckWeightTF: themeTextfield!
    @IBOutlet weak var cargoLoadCapTF: themeTextfield!
    @IBOutlet weak var truckWeightUnitTF: themeTextfield!
    @IBOutlet weak var cargoLoadUnitTF: themeTextfield!
    
        
    @IBOutlet weak var ImageViewIdentity: UIImageView!
    @IBOutlet weak var ImageViewLicence: UIImageView!
    
    @IBOutlet weak var TextFieldLicenseNumber: themeTextfield!
    @IBOutlet weak var TextFieldLicenseExpiryDate: themeTextfield!
    
    @IBOutlet var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet var viewTabView: UIView!
   
    
    @IBOutlet weak var TextFieldTruckBrand: themeTextfield!
    @IBOutlet weak var TextFieldVehicalPhoto: themeTextfield!
   @IBOutlet weak var TextFieldRegistrationNumber: themeTextfield!
    @IBOutlet weak var TextFieldCapacity: themeTextfield!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var TextFieldCapacityType: themeTextfield!
    @IBOutlet weak var collectionTruckCapacity: UICollectionView!
    
    @IBOutlet weak var BtnAdd: themeButton!
    @IBOutlet var btnUpdate: themeButton!
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Profile", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        registerNIBsAndDelegate()
        setDelagets()
        SetValue()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func registerNIBsAndDelegate(){
       
        collectionImages.delegate = self
        collectionImages.dataSource = self
        let uploadnib = UINib(nibName: UploadVideoAndImagesCell.className, bundle: nil)
      
        collectionImages.register(uploadnib, forCellWithReuseIdentifier: UploadVideoAndImagesCell.className)
        collectionImages.register(uploadnib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UploadVideoAndImagesCell.className)
        let nib = UINib(nibName: collectionPhotos.className, bundle: nil)
        collectionImages.register(nib, forCellWithReuseIdentifier: collectionPhotos.className)
        
    }
    
    
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
        
    }
    func setDelagets() {
        TextFieldTruckBrand.delegate = self
        TextFieldCapacityType.delegate = self
        TextFieldCategory.delegate = self
        TextFieldSubCategory.delegate = self
        truckWeightUnitTF.delegate = self
        cargoLoadUnitTF.delegate = self
        setupDelegateForPickerView()
        TextFieldLicenseExpiryDate.addInputViewDatePicker(target: self, selector: #selector(btnDoneDatePickerClicked), PickerMode: .date, MinDate: true, MaxDate: false)
    }
   
    func SetValue() {
        
        
//        let Singleton = SingletonClass.sharedInstance.ProfileData
//
//
//        Singleton.Reg_fullname = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
//        Singleton.Reg_country_code = SingletonClass.sharedInstance.UserProfileData?.countryCode ?? ""
//            Singleton.Reg_mobile_number = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
//
//            Singleton.Reg_truck_type = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].id ?? 0)"
//            Singleton.Reg_truck_sub_category = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[SelectedSubCategoryIndex].id ?? 0)"
//
//
//        Singleton.Reg_truck_weight = SingletonClass.sharedInstance.UserProfileData?.vehicle?.weight ?? ""
//        Singleton.Reg_weight_unit = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.weightUnit?.id ?? 0)"
//        Singleton.Reg_truck_capacity = SingletonClass.sharedInstance.UserProfileData?.vehicle?.loadCapacity ?? ""
//
//        Singleton.Reg_capacity_unit = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.loadCapacityUnit?.id ?? 0)"
//
//        Singleton.Reg_brand
//
//        TextFieldTruckBrand.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.brands?.name ?? ""
//        SingletonClass.sharedInstance.UserProfileData?.vehicle?.vehicleCapacity?.forEach({ element in
//            TruckCapacityAdded.append(TruckCapacityType(Capacity: element.value ?? "", Type: element.packageTypeId?.id ?? 0))
//        })

//
//        TextFieldRegistrationNumber.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.registrationNo
//
//
//
////
////
//
//        SingletonClass.sharedInstance.ProfileData.Reg_fullname = TextFieldFullName.text ?? ""
//
//        SingletonClass.sharedInstance.ProfileData.Reg_country_code = SingletonClass.sharedInstance.UserProfileData?.countryCode ?? ""
//        SingletonClass.sharedInstance.ProfileData.Reg_mobile_number = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
//        SingletonClass.sharedInstance.ProfileData.Reg_truck_type = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].id ?? 0)"
//        SingletonClass.sharedInstance.ProfileData.Reg_truck_sub_category = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[SelectedSubCategoryIndex].id ?? 0)"
//
//        SingletonClass.sharedInstance.ProfileData.Reg_truck_weight = truckWeightTF.text ?? ""
//        SingletonClass.sharedInstance.ProfileData.Reg_weight_unit = truckWeightUnitTF.text ?? ""
//        SingletonClass.sharedInstance.ProfileData.Reg_truck_capacity = cargoLoadCapTF.text ?? ""
//        SingletonClass.sharedInstance.ProfileData.Reg_capacity_unit = cargoLoadUnitTF.text ?? ""
//
//
//        SingletonClass.sharedInstance.ProfileData.Reg_brand = TextFieldTruckBrand.text ?? ""
//       SingletonClass.sharedInstance.ProfileData.Reg_pallets = TruckCapacityAdded
//
//        SingletonClass.sharedInstance.ProfileData.Reg_registration_no = TextFieldRegistrationNumber.text ?? ""
//
//       var TempAdditionType : [String] = []
//       arrTypes.forEach { element in
//           if element.1 {
//               TempAdditionType.append("\(element.0.id ?? 0)")
//           }
//       }
//       SingletonClass.sharedInstance.ProfileData.Reg_fuel_type = tabTypeSelection
//       SingletonClass.sharedInstance.ProfileData.Reg_truck_features = TempAdditionType
//       SingletonClass.sharedInstance.ProfileData.Reg_vehicle_images = arrImages
//        SingletonClass.sharedInstance.ProfileData.Reg_license_expiry_date =  SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate?.ConvertDateFormat(FromFormat: "yyyy-mm-dd", ToFormat: "dd-mm-yyyy") ?? ""
//
        let StringURLForProfile = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.profile ?? "")"
        ImageViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        ImageViewProfile.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
        TextFieldFullName.text = SingletonClass.sharedInstance.UserProfileData?.name ?? ""
        
        TextFieldMobileNumber.text = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
        TextFieldEmail.text = SingletonClass.sharedInstance.UserProfileData?.email ?? ""
        
        if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.id ?? 0)}) {

            self.SelectedCategoryIndex = IndexForTruckType
            TextFieldCategory.text = "\(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].name ?? "")"

            if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory?.id ?? 0)}) {

                TextFieldSubCategory.text =  "\(SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?[IndexForSubTruckType].name ?? "")"
            }
        }
        TextFieldTruckPlatNumber.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.registrationNo
        TextFieldTrailerPlatNumber.text =    SingletonClass.sharedInstance.UserProfileData?.vehicle?.trailerRegistrationNo
        TextFieldTrailerPlatNumber.superview?.isHidden = ((SingletonClass.sharedInstance.UserProfileData?.vehicle?.trailerRegistrationNo ?? "") == "") ? true : false
        
        if SingletonClass.sharedInstance.UserProfileData?.vehicle?.license != "" {
            let strUrl = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? "")"
            print(strUrl)
            ImageViewLicence.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewLicence.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        if SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof != "" {
            let strUrl = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? "")"
            ImageViewIdentity.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ImageViewIdentity.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
        }
        TextFieldLicenseNumber.text = SingletonClass.sharedInstance.UserProfileData?.licenceNumber
        TextFieldLicenseExpiryDate.text = SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate?.ConvertDateFormat(FromFormat: "yyyy-mm-dd", ToFormat: "dd-mm-yyyy")
        
        
        truckWeightTF.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.weight ?? ""
        truckWeightUnitTF.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.weightUnit?.name ?? ""
        cargoLoadCapTF.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.loadCapacity ?? ""
        
        cargoLoadUnitTF.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.loadCapacityUnit?.name ?? ""
        
        
        
        TextFieldTruckBrand.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.brands?.name ?? ""
//        SingletonClass.sharedInstance.UserProfileData?.vehicle?.vehicleCapacity?.forEach({ element in
//            TruckCapacityAdded.append(TruckCapacityType(Capacity: element.value ?? "", Type: element.packageTypeId?.id ?? 0))
//        })
        
      
//        TextFieldRegistrationNumber.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.registrationNo
       
       var TempAdditionType : [String] = []
       arrTypes.forEach { element in
           if element.1 {
               TempAdditionType.append("\(element.0.id ?? 0)")
           }
       }
       
        ButtonTypeForAddingCapacity = .Add
        for i in btnSelection{
            if i.tag == 0 {
                i.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
                selectedBtnUIChanges(Selected: true, Btn: i)
            }
            else {
                selectedBtnUIChanges(Selected: false, Btn:i)
            }
        }
        if let flowLayout = collectionImages.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: collectionImages.frame.width / 3, height: collectionImages.frame.height - 30)
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
       
        
        arrImages = SingletonClass.sharedInstance.UserProfileData?.vehicle?.images ?? []
        SingletonClass.sharedInstance.ProfileData.Reg_id_proof = [SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? ""]
        SingletonClass.sharedInstance.ProfileData.Reg_license = [SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? ""]

        SingletonClass.sharedInstance.TruckFeatureList?.forEach({ element in
            arrTypes.append((element,false))
        })
        if arrTypes.count != 0 {
            for i in 0...arrTypes.count - 1 {
                if let truckFeatures = SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckFeatures {
                    if truckFeatures.contains(where: {$0.id == arrTypes[i].0.id ?? 0}) {
                        arrTypes[i].1 = true
                    } else {
                        arrTypes[i].1 = false
                    }
                   
                }
            }
           
            
//            for i in 0...arrTypes.count - 1 {
//                 let valueIsIn =  (arrTypes[i].0.id ?? 0)
//                    if .contains(where: {$0.id == valueIsIn}) {
//
//                    }
//
//                if ((SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckFeatures?.contains(where: {$0.id == (arrTypes[i].0.id ?? 0)})) != nil) {
//                    arrTypes[i].1 = true
//                } else {
//                    arrTypes[i].1  = false
//                }
//
//            }
        }
        collectionTruckCapacity.reloadData()
        collectionImages.reloadData()
        ColTypes.reloadData()
        let _ = btnSelection.map{$0.isSelected = false}
        selectedBtnUIChanges(Selected: false, Btn:btnSelection[0])
        selectedBtnUIChanges(Selected: false, Btn:btnSelection[1])
        selectedBtnUIChanges(Selected: false, Btn:btnSelection[2])
        switch SingletonClass.sharedInstance.RegisterData.Reg_fuel_type {
        
        case Tabselect.Diesel.rawValue:
            selectedBtnUIChanges(Selected: true, Btn:btnSelection[0])
            self.tabTypeSelection = Tabselect.Diesel.rawValue

            self.btnLeadingConstaintOfAnimationView.constant = btnSelection[0].superview?.frame.origin.x ?? 0.0
            UIView.animate(withDuration: 0.3) {
                self.viewTabView.layoutIfNeeded()
            }
        case Tabselect.Electrical.rawValue:
            selectedBtnUIChanges(Selected: true, Btn:btnSelection[1])
            self.tabTypeSelection = Tabselect.Electrical.rawValue

            self.btnLeadingConstaintOfAnimationView.constant = btnSelection[1].superview?.frame.origin.x ?? 0.0
            UIView.animate(withDuration: 0.3) {
                self.viewTabView.layoutIfNeeded()
            }
        case Tabselect.Hydrogen.rawValue:
            selectedBtnUIChanges(Selected: true, Btn:btnSelection[2])
            self.tabTypeSelection = Tabselect.Hydrogen.rawValue

            self.btnLeadingConstaintOfAnimationView.constant = btnSelection[2].superview?.frame.origin.x ?? 0.0
            UIView.animate(withDuration: 0.3) {
                self.viewTabView.layoutIfNeeded()
            }
        default:
            break
        }
        
        
    }
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        
        GeneralPicker.generalPickerDelegate = self
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == TextFieldCategory {
            SelectedTextField = TextFieldCategory
            TextFieldCategory.inputView = GeneralPicker
            TextFieldCategory.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.name == TextFieldCategory.text ?? ""}) {
                print("Dummy First",DummyFirst)
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == TextFieldSubCategory {
            if TextFieldCategory.text != "" {
                if TextFieldCategory.text?.lowercased() == "other" {
                    self.TextFieldSubCategory.inputView = nil
                    self.TextFieldSubCategory.becomeFirstResponder()
                    print("Keyboard open here")
                } else {
                    SelectedTextField = TextFieldSubCategory
                    TextFieldSubCategory.inputView = GeneralPicker
                    TextFieldSubCategory.inputAccessoryView = GeneralPicker.toolbar
                    
                    if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.id ?? 0)}) {
                        if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory?.id ?? 0)}) {
                            
                            GeneralPicker.selectRow(IndexForSubTruckType, inComponent: 0, animated: false)
                        }
                    }
                    self.GeneralPicker.reloadAllComponents()
                    
                }
            } else {
                
            }
            
        }  else if textField == TextFieldTruckBrand {
            SelectedTextField = TextFieldTruckBrand
            TextFieldTruckBrand.inputView = GeneralPicker
            TextFieldTruckBrand.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == TextFieldTruckBrand.text ?? ""}){
                
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
            
        } else if textField == TextFieldCapacityType {
            SelectedTextField = TextFieldCapacityType
            TextFieldCapacityType.inputView = GeneralPicker
            TextFieldCapacityType.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == TextFieldCapacityType.text}){
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == truckWeightUnitTF {
            truckWeightUnitTF.inputView = GeneralPicker
            truckWeightUnitTF.inputAccessoryView = GeneralPicker.toolbar
            SelectedTextField = truckWeightUnitTF
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == truckWeightUnitTF.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == cargoLoadUnitTF {
            cargoLoadUnitTF.inputView = GeneralPicker
            cargoLoadUnitTF.inputAccessoryView = GeneralPicker.toolbar
            SelectedTextField = cargoLoadUnitTF
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where:{$0.name == cargoLoadUnitTF.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
                self.GeneralPicker.reloadAllComponents()
            }
        }
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func btnSaveProfileClick(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            
           CallAPI()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
        }
        
        
        
        
    }
    @objc func btnDoneDatePickerClicked() {
        if let datePicker = self.TextFieldLicenseExpiryDate.inputView as? UIDatePicker {
            
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatterString.onlyDate.rawValue
            TextFieldLicenseExpiryDate.text = formatter.string(from: datePicker.date)

        }
        self.TextFieldLicenseExpiryDate.resignFirstResponder() // 2-5
    }
    
    @IBAction func btnIdentityClick(_ sender: themeButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.ImageViewIdentity.image = image
            print(image)
            self.ImageUploadAPI(arrImages: [image], documentType: .IdentityProof)
        }
        
    }
    @IBAction func btnProfileClick(_ sender: themeButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.ImageViewProfile.image = image
            print(image)
            self.ImageUploadAPI(arrImages: [image], documentType: .Profile)
        }
        
    }
    @IBAction func btnLicenceClick(_ sender: themeButton) {
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.ImageViewLicence.image = image
         
            print(image)
            self.ImageUploadAPI(arrImages: [image], documentType: .Licence)
        }
    }
    @IBAction func btnAddClick(_ sender: themeButton) {
        if TextFieldCapacity.text ?? "" == "" {
            Utilities.ShowAlertOfValidation(OfMessage: "Please enter capacity")
        } else  if TextFieldCapacityType.text ?? "" == "" {
            Utilities.ShowAlertOfValidation(OfMessage: "Please select capacity type")
        } else {
            if ButtonTypeForAddingCapacity == .Update {
                
                guard let IndexOfType = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == TextFieldCapacityType.text ?? ""}) else {
                    return
                }
                let updatedIdType = SingletonClass.sharedInstance.PackageList?[IndexOfType].id ?? 0
                let previousIDType = TruckCapacityAdded[SelectedIndexOfType].type
                
                if updatedIdType == previousIDType {
                    TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
                        
                        BtnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                        ButtonTypeForAddingCapacity = .Add
                        
                        TextFieldCapacity.text = ""
                        TextFieldCapacityType.text = ""
                        
                        collectionTruckCapacity.reloadData()
                        TextFieldCapacity.resignFirstResponder()
                        TextFieldCapacityType.resignFirstResponder()
                } else {
                    if TruckCapacityAdded.contains(where: {$0.type == updatedIdType}) {
                        let IndexOfValue = TruckCapacityAdded.firstIndex(where: {$0.type == updatedIdType})
                        if IndexOfValue == SelectedIndexOfType {
                            TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
                                
                                BtnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                                ButtonTypeForAddingCapacity = .Add
                                
                                TextFieldCapacity.text = ""
                                TextFieldCapacityType.text = ""
                                
                                collectionTruckCapacity.reloadData()
                                TextFieldCapacity.resignFirstResponder()
                                TextFieldCapacityType.resignFirstResponder()
                        } else {
                            Utilities.ShowAlertOfValidation(OfMessage: "You can add only one time \(SingletonClass.sharedInstance.PackageList?[IndexOfType].name ?? "")")
                        }
                    } else {
                        TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
                            
                            BtnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                            ButtonTypeForAddingCapacity = .Add
                            
                            TextFieldCapacity.text = ""
                            TextFieldCapacityType.text = ""
                            
                            collectionTruckCapacity.reloadData()
                            TextFieldCapacity.resignFirstResponder()
                            TextFieldCapacityType.resignFirstResponder()
                    }
                }
                
            } else {
                
                    if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == TextFieldCapacityType.text ?? ""})
                    {
                        if TruckCapacityAdded.contains(where: {$0.type == SingletonClass.sharedInstance.PackageList?[index].id ?? 0}) {
                            Utilities.ShowAlertOfValidation(OfMessage: "You can add only one time \(SingletonClass.sharedInstance.PackageList?[index].name ?? "")")
                        } else {
                            TruckCapacityAdded.append(TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: SingletonClass.sharedInstance.PackageList?[index].id ?? 0))
                            TextFieldCapacity.text = ""
                            TextFieldCapacityType.text = ""
                            
                            collectionTruckCapacity.reloadData()
                            TextFieldCapacity.resignFirstResponder()
                            TextFieldCapacityType.resignFirstResponder()
                        }
                       
                    }
                    
                }
               
        }
        
        
        
    }
    @IBAction func btnTabSelection(_ sender: UIButton) {
        let _ = btnSelection.map{$0.isSelected = false}
        for i in btnSelection{
            selectedBtnUIChanges(Selected: false, Btn: i)
        }
        if(sender.tag == 0)
        {
            selectedBtnUIChanges(Selected: true, Btn:sender)
            self.tabTypeSelection = Tabselect.Diesel.rawValue
            
        }
        else  if(sender.tag == 1)
        {
            self.tabTypeSelection = Tabselect.Electrical.rawValue
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        else  if(sender.tag == 2)
        {
            self.tabTypeSelection = Tabselect.Hydrogen.rawValue
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        
        
        self.btnLeadingConstaintOfAnimationView.constant = sender.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validations ---------
    // ----------------------------------------------------
    
    func Validate() -> (Bool,String) {
        
        
        SingletonClass.sharedInstance.ProfileData.Reg_fullname = TextFieldFullName.text ?? ""
        
        SingletonClass.sharedInstance.ProfileData.Reg_country_code = SingletonClass.sharedInstance.UserProfileData?.countryCode ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_mobile_number = SingletonClass.sharedInstance.UserProfileData?.mobileNumber ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_truck_type = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].id ?? 0)"
        SingletonClass.sharedInstance.ProfileData.Reg_truck_sub_category = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[SelectedSubCategoryIndex].id ?? 0)"
        SingletonClass.sharedInstance.ProfileData.Reg_truck_weight = truckWeightTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_weight_unit = truckWeightUnitTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_truck_capacity = cargoLoadCapTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_capacity_unit = cargoLoadUnitTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_truck_plat_number = TextFieldTruckPlatNumber.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_trailer_plat_number = TextFieldTrailerPlatNumber.text ?? ""
        
        SingletonClass.sharedInstance.ProfileData.Reg_brand = TextFieldTruckBrand.text ?? ""
       SingletonClass.sharedInstance.ProfileData.Reg_pallets = TruckCapacityAdded
      
//        SingletonClass.sharedInstance.ProfileData.Reg_registration_no = TextFieldRegistrationNumber.text ?? ""
       
       var TempAdditionType : [String] = []
       arrTypes.forEach { element in
           if element.1 {
               TempAdditionType.append("\(element.0.id ?? 0)")
           }
       }
       SingletonClass.sharedInstance.ProfileData.Reg_fuel_type = tabTypeSelection
       SingletonClass.sharedInstance.ProfileData.Reg_truck_features = TempAdditionType
       SingletonClass.sharedInstance.ProfileData.Reg_vehicle_images = arrImages
        SingletonClass.sharedInstance.ProfileData.Reg_license_expiry_date =  SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate?.ConvertDateFormat(FromFormat: "yyyy-mm-dd", ToFormat: "dd-mm-yyyy") ?? ""
        
        let checkFullName = TextFieldFullName.validatedText(validationType: ValidatorType.username(field: "full name",MaxChar: 70))
       
        let CheckTruckCategory = TextFieldCategory.validatedText(validationType: ValidatorType.Select(field: "truck category"))
        let CheckTruckSubCategory = TextFieldSubCategory.validatedText(validationType: ValidatorType.Select(field: "truck sub category"))
        let checkTruckPlateNumber = TextFieldTruckPlatNumber.validatedText(validationType: ValidatorType.requiredField(field: "truck plat number"))
        let checkTrailerNumber = TextFieldTrailerPlatNumber.validatedText(validationType: ValidatorType.requiredField(field: "trailer plat number"))
        let CheckTruckWeight = truckWeightTF.validatedText(validationType: ValidatorType.requiredField(field: "truck weight"))
        let UnitTruckWeight = truckWeightUnitTF.validatedText(validationType: ValidatorType.Select(field: "unit of truck weight"))
        let CheckLoadCapacity = cargoLoadCapTF.validatedText(validationType: ValidatorType.requiredField(field: "truck load capacity"))
       let UnitLoadCapacity = cargoLoadUnitTF.validatedText(validationType: ValidatorType.Select(field: "unit of truck load capacity"))
        
        let CheckTruckBrand = TextFieldTruckBrand.validatedText(validationType: ValidatorType.Select(field: "truck brand"))
        
     //   let CheckRegistrationNumber = TextFieldRegistrationNumber.validatedText(validationType: ValidatorType.username(field: "registration number", MaxChar: 8))
        //let CheckVehicalPhoto = TextFieldVehicalPhoto.validatedText(validationType: ValidatorType.Attach(field: "vehical photo"))
      
        let checkLicenseNumber = TextFieldLicenseNumber.validatedText(validationType: ValidatorType.requiredField(field: "license number"))
        
        let checkLicenseExpiryDate = TextFieldLicenseExpiryDate.validatedText(validationType: ValidatorType.requiredField(field: "license expiry date"))
        
        if (!checkFullName.0){
            return (checkFullName.0,checkFullName.1)
        }  else if (!CheckTruckCategory.0){
            return (CheckTruckCategory.0,CheckTruckCategory.1)
        } else if (!CheckTruckSubCategory.0){
            return (CheckTruckSubCategory.0,CheckTruckSubCategory.1)
        } else if (!checkTruckPlateNumber.0){
            return (checkTruckPlateNumber.0,checkTruckPlateNumber.1)
        } else if (SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].isTrailer == 1){
            if (!checkTrailerNumber.0){
                return (checkTrailerNumber.0,checkTrailerNumber.1)
                
            }
        } else if (!CheckTruckBrand.0){
            return (CheckTruckBrand.0,CheckTruckBrand.1)
        } else if TruckCapacityAdded.count == 0 {
            return (false,"Please add atleast one capacity")
        }
//        else if (!CheckRegistrationNumber.0){
//            return (CheckRegistrationNumber.0,CheckRegistrationNumber.1)
//        }
        else if (!CheckTruckWeight.0){
            return (CheckTruckWeight.0,CheckTruckWeight.1)
        } else if (!UnitTruckWeight.0){
            return (UnitTruckWeight.0,UnitTruckWeight.1)
        }else if(!CheckLoadCapacity.0){
            return (CheckLoadCapacity.0,CheckLoadCapacity.1)
        }else if(!UnitLoadCapacity.0){
            return (UnitLoadCapacity.0,UnitLoadCapacity.1)
        } else if SingletonClass.sharedInstance.ProfileData.Reg_id_proof.count == 0 {
            return (false,"Please attach id proof document")
        } else if SingletonClass.sharedInstance.ProfileData.Reg_license.count == 0 {
            return (false,"Please attach license")
        } else if (!checkLicenseNumber.0){
            return (checkLicenseNumber.0,checkLicenseNumber.1)
        }
        else if (!checkLicenseExpiryDate.0){
            return (checkLicenseExpiryDate.0,checkLicenseExpiryDate.1)
        }
        return (true,"")
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    func CallAPI(){
        
        SingletonClass.sharedInstance.ProfileData.Reg_fullname = TextFieldFullName.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_mobile_number = TextFieldMobileNumber.text ?? ""
        
        SingletonClass.sharedInstance.ProfileData.Reg_truck_type = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].id ?? 0)"
        SingletonClass.sharedInstance.ProfileData.Reg_truck_sub_category = "\(SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[SelectedSubCategoryIndex].id ?? 0)"
        SingletonClass.sharedInstance.ProfileData.Reg_truck_plat_number = TextFieldTruckPlatNumber.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_trailer_plat_number = TextFieldTrailerPlatNumber.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_truck_weight = truckWeightTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_weight_unit = truckWeightUnitTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_truck_capacity = cargoLoadCapTF.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_capacity_unit = cargoLoadUnitTF.text ?? ""
        
        
        
      
        SingletonClass.sharedInstance.ProfileData.Reg_brand = TextFieldTruckBrand.text ?? ""
       SingletonClass.sharedInstance.ProfileData.Reg_pallets = TruckCapacityAdded
      
        //SingletonClass.sharedInstance.ProfileData.Reg_registration_no = TextFieldRegistrationNumber.text ?? ""
        
        SingletonClass.sharedInstance.ProfileData.Reg_license_number = TextFieldLicenseNumber.text ?? ""
        SingletonClass.sharedInstance.ProfileData.Reg_license_expiry_date = TextFieldLicenseExpiryDate.text ?? ""
        
       
       var TempAdditionType : [String] = []
       arrTypes.forEach { element in
           if element.1 {
               TempAdditionType.append("\(element.0.id ?? 0)")
           }
       }
       SingletonClass.sharedInstance.ProfileData.Reg_fuel_type = tabTypeSelection
       SingletonClass.sharedInstance.ProfileData.Reg_truck_features = TempAdditionType
       SingletonClass.sharedInstance.ProfileData.Reg_vehicle_images = arrImages
        
        
        self.profileUpdateViewModel.profileEditViewController = self
        
        let productsDict = TruckCapacityType.ConvetToDictonary(arrayDataCart: SingletonClass.sharedInstance.ProfileData.Reg_pallets);
        
        let jsonData = try! JSONSerialization.data(withJSONObject: productsDict, options: [])
        let jsonString:String = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
//
        
        
        let profileEditReqModel = ProfileEditReqModel()
        profileEditReqModel.fullname  = SingletonClass.sharedInstance.ProfileData.Reg_fullname
        profileEditReqModel.mobile_number  = SingletonClass.sharedInstance.ProfileData.Reg_mobile_number
        profileEditReqModel.truck_type  = SingletonClass.sharedInstance.ProfileData.Reg_truck_type
        profileEditReqModel.profile_image = SingletonClass.sharedInstance.ProfileData.Reg_profilePic.map({$0}).joined(separator: ",")
        profileEditReqModel.truck_sub_category = SingletonClass.sharedInstance.ProfileData.Reg_truck_sub_category
        profileEditReqModel.truck_weight  = SingletonClass.sharedInstance.ProfileData.Reg_truck_weight
        
        if let TruckUnitIndex = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.ProfileData.Reg_weight_unit}) {
            profileEditReqModel.weight_unit  = "\(SingletonClass.sharedInstance.TruckunitList?[TruckUnitIndex].id ?? 0)"
        }
        
       
        profileEditReqModel.truck_capacity  = SingletonClass.sharedInstance.ProfileData.Reg_truck_capacity
        
        if let CapacityUnitIndex = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.ProfileData.Reg_capacity_unit}) {
            profileEditReqModel.capacity_unit  = "\(SingletonClass.sharedInstance.TruckunitList?[CapacityUnitIndex].id ?? 0)"
        }
        profileEditReqModel.plate_number_truck = SingletonClass.sharedInstance.ProfileData.Reg_truck_plat_number
        profileEditReqModel.plate_number_trailer = SingletonClass.sharedInstance.ProfileData.Reg_trailer_plat_number
//            registerReqModel.capacity_unit  = SingletonClass.sharedInstance.ProfileData.Reg_TruckLoadCapacityUnit
        
        if let TruckBrandIndex = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == SingletonClass.sharedInstance.ProfileData.Reg_brand}) {
            profileEditReqModel.brand  = "\(SingletonClass.sharedInstance.TruckBrandList?[TruckBrandIndex].id ?? 0)"
        }
        
//            registerReqModel.brand  = SingletonClass.sharedInstance.ProfileData.Reg_TruckBrand
        profileEditReqModel.pallets = jsonString
        profileEditReqModel.fuel_type  = SingletonClass.sharedInstance.ProfileData.Reg_fuel_type
        profileEditReqModel.vehicle_images  = SingletonClass.sharedInstance.ProfileData.Reg_vehicle_images.map({$0}).joined(separator: ",")

        profileEditReqModel.id_proof  = SingletonClass.sharedInstance.ProfileData.Reg_id_proof.map({$0}).joined(separator: ",")
        
        profileEditReqModel.truck_features = SingletonClass.sharedInstance.ProfileData.Reg_truck_features.map({$0}).joined(separator: ",")
        profileEditReqModel.license  = SingletonClass.sharedInstance.ProfileData.Reg_license.map({$0}).joined(separator: ",")
        profileEditReqModel.license_number  = SingletonClass.sharedInstance.ProfileData.Reg_license_number
        profileEditReqModel.license_expiry_date  = SingletonClass.sharedInstance.ProfileData.Reg_license_expiry_date.ConvertDateFormat(FromFormat: "dd-MM-yyyy", ToFormat: "yyyy-MM-dd")
        
        self.profileUpdateViewModel.WebserviceForProfileEidt(ReqModel: profileEditReqModel)
    }
    
    func ImageUploadAPI(arrImages:[UIImage],documentType:DocumentType) {
        self.profileUpdateViewModel.profileEditViewController = self
        
        self.profileUpdateViewModel.WebServiceImageUpload(images: arrImages, uploadFor: documentType)
      
    }
}
extension ProfileEditViewController: GeneralPickerViewDelegate {
    
    func didTapDone() {
        
        if SelectedTextField == TextFieldCategory {
            
            SelectedCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
            let item = SingletonClass.sharedInstance.TruckTypeList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldCategory.text = item?.name
            self.TextFieldSubCategory.text = ""
            self.TextFieldTruckPlatNumber.text = ""
            self.TextFieldTrailerPlatNumber.text = ""
            
            if item?.isTrailer == 1 {
                self.TextFieldTrailerPlatNumber.superview?.isHidden = false
            } else {
                self.TextFieldTrailerPlatNumber.superview?.isHidden = true
            }
            
            SelectedSubCategoryIndex = 0
            if item?.name?.lowercased() == "other" {
                TextFieldSubCategory.rightView?.isHidden = true
                print("Keyboard open here")
            } else {
                TextFieldSubCategory.rightView?.isHidden = false
            }
            
            
        } else if SelectedTextField == TextFieldSubCategory {
         
            if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count != 0 {
                SelectedSubCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
                let item =
                SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[GeneralPicker.selectedRow(inComponent: 0)]
                
                self.TextFieldSubCategory.text = item?.name
    
            }
        } else if SelectedTextField == TextFieldCapacityType {
            let item = SingletonClass.sharedInstance.PackageList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldCapacityType.text = item?.name
            
            self.TextFieldCapacityType.resignFirstResponder()
        } else if SelectedTextField == TextFieldTruckBrand {
            let item = SingletonClass.sharedInstance.TruckBrandList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldTruckBrand.text = item?.name
            
            self.TextFieldTruckBrand.resignFirstResponder()
        } else  if SelectedTextField == truckWeightUnitTF {
           
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.truckWeightUnitTF.text = item?.name
            self.truckWeightUnitTF.resignFirstResponder()
            
        } else if SelectedTextField == cargoLoadUnitTF {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.cargoLoadUnitTF.text = item?.name
            
            self.cargoLoadUnitTF.resignFirstResponder()
        }
        self.TextFieldCategory.resignFirstResponder()
        self.TextFieldSubCategory.resignFirstResponder()
    }
    
    func didTapCancel() {
        //self.endEditing(true)
    }
}
extension ProfileEditViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectedTextField == TextFieldCategory {
            return SingletonClass.sharedInstance.TruckTypeList?.count ?? 0
        } else if SelectedTextField == TextFieldSubCategory {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0
        } else if SelectedTextField == TextFieldCapacityType {
            return SingletonClass.sharedInstance.PackageList?.count ?? 0
        } else if SelectedTextField == TextFieldTruckBrand {
            return SingletonClass.sharedInstance.TruckBrandList?.count ?? 0
        } else if SelectedTextField == truckWeightUnitTF {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        } else if SelectedTextField == cargoLoadUnitTF {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        }
        return 0
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectedTextField == TextFieldCategory {
            return SingletonClass.sharedInstance.TruckTypeList?[row].name
        } else if SelectedTextField == TextFieldSubCategory {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[row].name
        } else if SelectedTextField == TextFieldCapacityType {
            return SingletonClass.sharedInstance.PackageList?[row].name
        } else if SelectedTextField == TextFieldTruckBrand {
            return SingletonClass.sharedInstance.TruckBrandList?[row].name
        } else if SelectedTextField == truckWeightUnitTF {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        } else if SelectedTextField == cargoLoadUnitTF {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        }
        return ""
        
    }
    
    
}

extension ProfileEditViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ColTypes{
            return arrTypes.count
        } else if collectionView == collectionTruckCapacity {
            return TruckCapacityAdded.count
        } else if collectionView == collectionImages {
            return arrImages.count
        }
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ColTypes{
            return CGSize(width: ((arrTypes[indexPath.row].0.name?.capitalized ?? "").sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                          , height: ColTypes.frame.size.height - 10)
        } else  if collectionView == collectionTruckCapacity{
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                let StringForSize = "\(TruckCapacityAdded[indexPath.row].capacity ?? "") \(SingletonClass.sharedInstance.PackageList?[index].name ?? "" )"
                return CGSize(width: (StringForSize.sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 50
                              , height: collectionTruckCapacity.frame.size.height - 10)
            }
            return CGSize(width: 0.0, height: 0.0)
           
        } else if collectionView == collectionImages {
            return CGSize(width: collectionView.bounds.width/3 - 5, height: 71.0)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ColTypes{
            let cell = ColTypes.dequeueReusableCell(withReuseIdentifier: "TypesColCell", for: indexPath) as! TypesColCell
            cell.lblTypes.text = arrTypes[indexPath.row].0.name
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
        } else if collectionView == collectionTruckCapacity {
            let cell = collectionTruckCapacity.dequeueReusableCell(withReuseIdentifier: "TruckCapacityCell", for: indexPath) as! TruckCapacityCell
            
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                let StringForSize = "\(TruckCapacityAdded[indexPath.row].capacity ?? "") \(SingletonClass.sharedInstance.PackageList?[index].name ?? "" )"
                cell.lblCapacity.text = StringForSize
             
            }
            
            cell.BGView.layer.cornerRadius = 17
            cell.BGView.layer.borderWidth = 1
            
            cell.BGView.backgroundColor = .clear
            cell.BGView.layer.borderColor = UIColor.appColor(.themeButtonBlue).cgColor
            
            cell.RemoveClick = {
                self.BtnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                self.ButtonTypeForAddingCapacity = .Add
                
                self.TextFieldCapacity.text = ""
                self.TextFieldCapacityType.text = ""
                
               
                self.TextFieldCapacity.resignFirstResponder()
                self.TextFieldCapacityType.resignFirstResponder()
                
                self.TruckCapacityAdded.remove(at: indexPath.row)
                self.collectionTruckCapacity.reloadData()
            }
            return cell
        } else if collectionView == collectionImages {
            let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: collectionPhotos.className, for: indexPath)as! collectionPhotos
            cell.btnCancel.tag = indexPath.row
            let strUrl = "\(APIEnvironment.TempProfileURL)\(arrImages[indexPath.row])"
            cell.imgPhotos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgPhotos.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
            cell.btnCancel.addTarget(self, action: #selector(deleteImagesClicked(sender:)), for: .touchUpInside)
          
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
        } else if collectionView == collectionTruckCapacity {
            ButtonTypeForAddingCapacity = .Update
            SelectedIndexOfType = indexPath.row
            BtnAdd.setImage(#imageLiteral(resourceName: "ic_edit"), for: .normal)
            
            
            TextFieldCapacity.text = TruckCapacityAdded[indexPath.row].capacity
            
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                TextFieldCapacityType.text = SingletonClass.sharedInstance.PackageList?[index].name ?? ""
             
            }
                 
        } else if collectionView == collectionImages {
            
            let vc : GalaryVC = GalaryVC.instantiate(fromAppStoryboard: .Auth)
            vc.firstTimeSelectedIndex = indexPath.row
            vc.arrImage = self.arrImages
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    @objc func deleteImagesClicked(sender : UIButton){
        arrImages.remove(at: sender.tag)
//        arrVideoThumbnailImage.remove(at: sender.tag)
        self.collectionImages.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UploadVideoAndImagesCell.className, for: indexPath) as? UploadVideoAndImagesCell {
           //  header.backgroundColor = UIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
                
                    header.isForImage = collectionView == collectionImages ? true : false
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(tapDetected(_:)))
                header.addGestureRecognizer(tapGestureRecognizer)
            return header
          } else {
            return UICollectionReusableView()

          }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
     {
         return 10
     }
    
    @objc func tapDetected(_ sender: UITapGestureRecognizer){
        let cv = sender.view as? UploadVideoAndImagesCell
        if cv?.isForImage == true{
           
            AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
            AttachmentHandler.shared.imagePickedBlock = { (image) in
                
                self.collectionImages.reloadData()
                print(image)
                self.ImageUploadAPI(arrImages: [image], documentType: .Vehicle)
            }
        }
        
    }
    
    func setImg(cell:collectionPhotos,img : UIImage ){
        cell.imgPhotos.image = img
    }
}
