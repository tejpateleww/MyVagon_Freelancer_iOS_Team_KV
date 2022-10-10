//
//  AddTruck.swift
//  MyVagon
//
//  Created by Dhanajay  on 28/02/22.
//

import UIKit
import SDWebImage



class AddTruckVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var txtTruckType: themeTextfield!
    @IBOutlet weak var txtTruckSubType: themeTextfield!
    @IBOutlet weak var txtTruckWeight: themeTextfield!
    @IBOutlet weak var txtCargoLoadCapacity: themeTextfield!
    @IBOutlet weak var collectionTruckCapacity: UICollectionView!
    @IBOutlet weak var txtCapacityType: themeTextfield!
    @IBOutlet weak var TextFieldCapacity: themeTextfield!
    @IBOutlet weak var btnAdd: themeButton!
    @IBOutlet weak var truckWeightTF: themeTextfield!
    @IBOutlet weak var cargoLoadCapTF: themeTextfield!
    @IBOutlet weak var txtTruckLicencePlate: themeTextfield!
    @IBOutlet weak var viewSubType: ThemeViewRounded!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var btnHydraulicDoor: UIButton!
    @IBOutlet weak var btnSave: themeButton!
    @IBOutlet weak var viewAddCapacity: UIView!
    @IBOutlet weak var CollectionViewImageHeightConst: NSLayoutConstraint!
    @IBOutlet weak var tblTruckFeature: UITableView!
    @IBOutlet weak var tblTruckFeatureHeight: NSLayoutConstraint!
    @IBOutlet weak var heightConstrentImagcollection: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: themeLabel!
    @IBOutlet weak var imgDefaultTruck: UIImageView!
    @IBOutlet weak var viewDefaultTruck: UIView!
    @IBOutlet weak var lblTruckPhoto: themeLabel!
    @IBOutlet weak var lblMakeAsDefault: UILabel!
    
    var arrTruckFeature : [TruckFeaturesDatum] = []
    var SelectedTextField : UITextField?
    var SelectedCategoryIndex = 0
    var SelectedSubCategoryIndex = 0
    var SelectedCategory = 0
    var SelectedSubCategory = 0
    var GeneralPicker = GeneralPickerView()
    var ButtonTypeForAddingCapacity : AddCapacityTypeButtonName?
    var SelectedIndexOfType = NSNotFound
    var arrImages : [String] = []
    var arrFeatureID : [String] = []
    var selectedWeightUnitID = 0
    var selectedCategoryUnitID = 0
    var isDefault = false
    var addTruckViewModel = AddTruckViewModel()
    var TruckCapacityAdded : [TruckCapacityType] = [] {
        didSet {
            if TruckCapacityAdded.count == 0 {
                collectionTruckCapacity.isHidden = true
            } else {
                collectionTruckCapacity.isHidden = false
            }
        }
    }
    var tructData = RegTruckDetailModel()
    var isFromEdit = false
    var isEditEnable = true
    var isToAdd = false
    var truckIndex = 0
    var imageUrlArray = [String]()
    var editeData : ((RegTruckDetailModel) -> Void)?
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        if isFromEdit {
            self.setEditDeta()
        }
        self.enableEdit()
        self.setUpNevigetionBar()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.tblTruckFeature.layer.removeAllAnimations()
        self.tblTruckFeatureHeight.constant = self.tblTruckFeature.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalization()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "editprofile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "editprofile"), object: nil)
    }
    
    //MARK: - Custom methods
    func setLocalization(){
        txtTruckType.placeholder = "Truck type".localized
        txtTruckWeight.placeholder = "Overall Truck Weight".localized
        truckWeightTF.placeholder = "Unit".localized
        txtCargoLoadCapacity.placeholder = "Cargo Load Capacity".localized
        cargoLoadCapTF.placeholder = "Unit".localized
        TextFieldCapacity.placeholder = "Capacity".localized
        txtCapacityType.placeholder = "Select Type".localized
        txtTruckLicencePlate.placeholder = "Enter truck licence plate number".localized
        txtTruckSubType.placeholder = "Truck sub type".localized
        lblMakeAsDefault.text = "Make as Default Truck".localized
        lblTruckPhoto.text = "Truck_Photos".localized
        btnSave.setTitle("Add Truck".localized, for: .normal)
        self.setPicker()
    }
    
    func setArray(){
        let url = isFromEdit ? "\(APIEnvironment.DriverImageURL)" : "\(APIEnvironment.tempURL)"
        imageUrlArray.removeAll()
        for i in arrImages{
            imageUrlArray.append("\(url)\(i)")
        }
        collectionImages.reloadData()
    }
    
    func setPicker(){
        self.GeneralPicker = GeneralPickerView()
        self.GeneralPicker.dataSource = self
        self.GeneralPicker.delegate = self
        self.GeneralPicker.generalPickerDelegate = self
    }
    
    func setupUI(){
        self.tblTruckFeature.delegate = self
        self.tblTruckFeature.dataSource = self
        self.tblTruckFeature.showsVerticalScrollIndicator = false
        self.tblTruckFeature.showsHorizontalScrollIndicator = false
        self.tblTruckFeature.separatorStyle = .none
        self.tblTruckFeature.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.CollectionViewImageHeightConst.constant = collectionImages.bounds.width/3 - 10
        self.registerNib()
        viewDefaultTruck.isHidden = !isToAdd
    }
    
    func setUpNevigetionBar(){
        if isFromEdit{
            self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: isEditEnable ? "Edit Truck".localized : "Truck Detail".localized, leftImage: NavItemsLeft.back.value , rightImages: (isEditEnable || UserDefault.string(forKey: UserDefaultsKey.LoginUserType.rawValue) == LoginType.dispatcher_driver.rawValue) ? [] : [NavItemsRight.editProfile.value] , isTranslucent: true)
        }else{
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Truck".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        }
    }
    
    func registerNib(){
        let nib = UINib(nibName: TruckFeatureCell.className, bundle: nil)
        self.tblTruckFeature.register(nib, forCellReuseIdentifier: TruckFeatureCell.className)
    }
    
    func enableEdit(){
        self.txtTruckType.isUserInteractionEnabled = isEditEnable
        self.txtTruckSubType.isUserInteractionEnabled = isEditEnable
        self.truckWeightTF.isUserInteractionEnabled = isEditEnable
        self.cargoLoadCapTF.isUserInteractionEnabled = isEditEnable
        self.txtCapacityType.isUserInteractionEnabled = isEditEnable
        self.txtTruckWeight.isUserInteractionEnabled = isEditEnable
        self.txtCargoLoadCapacity.isUserInteractionEnabled = isEditEnable
        self.txtTruckLicencePlate.isUserInteractionEnabled = isEditEnable
        self.txtTruckType.rightImage = isEditEnable ? UIImage(named: "ic_dropdown") : UIImage()
        self.txtTruckSubType.rightImage = isEditEnable ? UIImage(named: "ic_dropdown") : UIImage()
        self.truckWeightTF.rightImage = isEditEnable ? UIImage(named: "ic_dropdown") : UIImage()
        self.cargoLoadCapTF.rightImage = isEditEnable ? UIImage(named: "ic_dropdown") : UIImage()
        self.btnAdd.isUserInteractionEnabled = isEditEnable
        self.viewAddCapacity.isHidden = !isEditEnable
        self.btnSave.isHidden = !isEditEnable
        self.lblTitle.text = isEditEnable ? "Enter Truck Details".localized : "Truck Details".localized
    }
    
    func setupData(){
        self.arrTruckFeature = SingletonClass.sharedInstance.TruckFeatureList ?? []
        self.tblTruckFeature.reloadData()
        self.txtTruckType.delegate = self
        self.txtTruckSubType.delegate = self
        self.truckWeightTF.delegate = self
        self.cargoLoadCapTF.delegate = self
        self.txtCapacityType.delegate = self
        self.txtTruckWeight.delegate = self
        self.txtCargoLoadCapacity.delegate = self
        self.setPicker()
        self.collectionTruckCapacity.dataSource = self
        self.collectionTruckCapacity.delegate = self
        self.collectionImages.dataSource = self
        self.collectionImages.delegate = self
        self.collectionImages.showsHorizontalScrollIndicator = false
        self.collectionImages.showsVerticalScrollIndicator = false
        let uploadnib = UINib(nibName: UploadVideoAndImagesCell.className, bundle: nil)
        collectionImages.register(uploadnib, forCellWithReuseIdentifier: UploadVideoAndImagesCell.className)
        collectionImages.register(uploadnib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UploadVideoAndImagesCell.className)
        let nib = UINib(nibName: collectionPhotos.className, bundle: nil)
        collectionImages.register(nib, forCellWithReuseIdentifier: collectionPhotos.className)
    }
    
    func setCollection(){
        self.TextFieldCapacity.text = ""
        self.txtCapacityType.text = ""
        self.collectionTruckCapacity.reloadData()
        self.collectionImages.reloadData()
        self.heightConstrentImagcollection.constant = collectionImages.bounds.width/3 - 10
        self.TextFieldCapacity.resignFirstResponder()
        self.txtCapacityType.resignFirstResponder()
    }
    
    func setEditDeta(){
        for truck in SingletonClass.sharedInstance.TruckTypeList ?? []{
            if(truck.id ?? 0 == Int(self.tructData.truck_type)){
                self.txtTruckType.text = truck.getName()
                for subCatagry in truck.category ?? []{
                    if subCatagry.id == Int(self.tructData.truck_sub_category){
                        self.txtTruckSubType.text = subCatagry.getName()
                    }
                }
            }
        }
        self.viewSubType.isHidden = false
        for unit in SingletonClass.sharedInstance.TruckunitList ?? [] {
            if Int(tructData.weight_unit) ?? 0 == unit.id{
                self.truckWeightTF.text = unit.getName()
            }
            if Int(tructData.capacity_unit) ?? 0 == unit.id{
                self.cargoLoadCapTF.text = unit.getName()
            }
        }
        self.txtTruckWeight.text = tructData.weight
        self.txtCargoLoadCapacity.text = tructData.capacity
        self.txtTruckLicencePlate.text = tructData.plate_number
        self.arrImages = tructData.images.components(separatedBy: ",")
        self.arrFeatureID = tructData.truck_features.components(separatedBy: ",")
        self.SelectedCategory = Int(tructData.truck_type) ?? 0
        self.SelectedSubCategory  = Int(tructData.truck_sub_category) ?? 0
        self.selectedWeightUnitID = Int(tructData.weight_unit) ?? 0
        self.selectedCategoryUnitID = Int(tructData.capacity_unit) ?? 0
        self.TruckCapacityAdded = tructData.pallets
        collectionTruckCapacity.reloadData()
        if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.getName() == txtTruckType.text ?? ""}) {
            SelectedCategoryIndex = IndexForTruckType
        }
        self.imageUrlArray = tructData.imageWithUrl.components(separatedBy: ",")
    }
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        self.addTruckViewModel.TruckDetail = self
        self.addTruckViewModel.WebServiceImageUpload(images: arrImages)
    }
    
    func validetion() -> (Bool,String){
        self.txtTruckLicencePlate.text = self.txtTruckLicencePlate.text?.trimmedString
        let truckType = txtTruckType.validatedText(validationType: .requiredField(field: "Truck type".localized))
        let truckSubType = txtTruckSubType.validatedText(validationType: .requiredField(field: "Truck sub type".localized))
        let overallWeight = txtTruckWeight.validatedText(validationType: .requiredField(field: "weight".localized))
        let weightUnit = truckWeightTF.validatedText(validationType: .requiredField(field: "truck weight unit".localized))
        let loadCapacity = txtCargoLoadCapacity.validatedText(validationType: .requiredField(field: "load capacity".localized))
        let loadUnit = cargoLoadCapTF.validatedText(validationType: .requiredField(field: "cargo load capacity unit"))
        let licenceNumber = txtTruckLicencePlate.validatedText(validationType: .requiredField(field: "plate number".localized))
        let licenceNumberValid = txtTruckLicencePlate.validatedText(validationType: .plateNumber(field: "truck licence plate number".localized))
        if !truckType.0{
            return truckType
        }else if !truckSubType.0{
            return truckSubType
        }else if !overallWeight.0{
            return overallWeight
        }else if !weightUnit.0{
            return (weightUnit.0,"Please select unit of the weight".localized)
        }else if !loadCapacity.0{
            return loadCapacity
        }else if !loadUnit.0{
            return (loadUnit.0,"Please select unit of the load capacity".localized)
        }else if !licenceNumber.0{
            return licenceNumber
        }else if (!licenceNumberValid.0){
            return licenceNumberValid
        }else if arrImages.count == 0{
            return (false,"Please upload truck photo".localized)
        }else{
            return (true,"Succesfull")
        }
    }
    
    @objc func ProfileEdit(){
        self.isEditEnable = true
        self.enableEdit()
        self.collectionImages.reloadData()
        self.collectionTruckCapacity.reloadData()
        self.setUpNevigetionBar()
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    //MARK: - IBAction method
    @IBAction func btnMAkeDefaultClick(_ sender: Any) {
        self.isDefault = !isDefault
        self.imgDefaultTruck.image = isDefault ? UIImage(named: "ic_checkbox_selected") : UIImage(named: "ic_checkbox_unselected")
    }
    
    @IBAction func btnActionHydraulicDoor(_ sender: UIButton) {
        self.btnHydraulicDoor.isSelected = !self.btnHydraulicDoor.isSelected
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        if TextFieldCapacity.text ?? "" == "" {
            Utilities.ShowAlertOfInfo(OfMessage: "Please enter capacity".localized)
        } else  if txtCapacityType.text ?? "" == "" {
            Utilities.ShowAlertOfInfo(OfMessage: "Please select capacity type".localized)
        } else {
            if ButtonTypeForAddingCapacity == .Update {
                self.updateCapacity()
            } else {
                self.addCapacity()
            }
        }
    }
    
    func updateCapacity(){
        guard let IndexOfType = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.getName() == txtCapacityType.text ?? ""}) else {
            return
        }
        let updatedIdType = SingletonClass.sharedInstance.PackageList?[IndexOfType].id ?? 0
        let previousIDType = TruckCapacityAdded[SelectedIndexOfType].type
        if updatedIdType == previousIDType {
            TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
            btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
            ButtonTypeForAddingCapacity = .Add
            self.setCollection()
        } else {
            if TruckCapacityAdded.contains(where: {$0.type == updatedIdType}) {
                let IndexOfValue = TruckCapacityAdded.firstIndex(where: {$0.type == updatedIdType})
                if IndexOfValue == SelectedIndexOfType {
                    TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
                    btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                    ButtonTypeForAddingCapacity = .Add
                    self.setCollection()
                } else {
                    Utilities.ShowAlertOfInfo(OfMessage: "\("You can add only one time".localized) \(SingletonClass.sharedInstance.PackageList?[IndexOfType].getName() ?? "")")
                }
            } else {
                TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
                btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                ButtonTypeForAddingCapacity = .Add
                self.setCollection()
            }
        }
    }
    
    func addCapacity(){
        if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.getName() == txtCapacityType.text ?? ""})
        {
            if TruckCapacityAdded.contains(where: {$0.type == SingletonClass.sharedInstance.PackageList?[index].id ?? 0}) {
                Utilities.ShowAlertOfInfo(OfMessage: "\("You can add only one time".localized) \(SingletonClass.sharedInstance.PackageList?[index].getName() ?? "")")
            } else {
                TruckCapacityAdded.append(TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: SingletonClass.sharedInstance.PackageList?[index].id ?? 0))
                self.setCollection()
            }
        }
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let velidetion = validetion()
        if velidetion.0{
            self.setTruckData()
            if isFromEdit{
                self.editeData?(tructData)
                self.navigationController?.popViewController(animated: true)
            }else{
                if isToAdd{
                    self.tructData.default_truck = isDefault ? "1" : "0"
                    self.callWebService()
                }else{
                    self.addTruck()
                }
            }
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: velidetion.1)
        }
    }
    
    func addTruck(){
        if SingletonClass.sharedInstance.RegisterData.Reg_truck_data.count == 0{
            self.tructData.default_truck = "1"
        }
        SingletonClass.sharedInstance.RegisterData.Reg_truck_data.append(self.tructData)
        UserDefault.SetRegiterData()
        UserDefault.synchronize()
        self.navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            NotificationCenter.default.post(name: .reloadRegTruckListScreen, object: nil)
        }
    }
    
    func setTruckData(){
        self.tructData.truck_type = "\(self.SelectedCategory)"
        self.tructData.truck_sub_category = "\(self.SelectedSubCategory)"
        self.tructData.weight = self.txtTruckWeight.text ?? ""
        self.tructData.weight_unit = "\(self.selectedWeightUnitID)"
        self.tructData.capacity = self.txtCargoLoadCapacity.text ?? ""
        self.tructData.capacity_unit = "\(self.selectedCategoryUnitID)"
        self.tructData.plate_number = self.txtTruckLicencePlate.text ?? ""
        self.tructData.images = self.arrImages.map({$0}).joined(separator: ",")
        self.tructData.pallets = TruckCapacityAdded
        self.tructData.truck_features = self.arrFeatureID.map({$0}).joined(separator: ",")
        self.tructData.imageWithUrl = self.imageUrlArray.map({$0}).joined(separator: ",")
    }
}

//MARK: - Text field delegate
extension AddTruckVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTruckType {
            SelectedTextField = txtTruckType
            txtTruckType.inputView = GeneralPicker
            txtTruckType.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.getName() == txtTruckType.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        }else if textField == txtTruckSubType{
            if txtTruckType.text != "" {
                if txtTruckType.text?.lowercased() == "other" {
                    self.txtTruckSubType.inputView = nil
                    self.txtTruckSubType.becomeFirstResponder()
                } else {
                    SelectedTextField = txtTruckSubType
                    txtTruckSubType.inputView = GeneralPicker
                    txtTruckSubType.inputAccessoryView = GeneralPicker.toolbar
                    if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.getName() == txtTruckType.text ?? ""}) {
                        if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.getName() == txtTruckSubType.text}) {
                            GeneralPicker.selectRow(IndexForSubTruckType, inComponent: 0, animated: false)
                        }
                    }
                    self.GeneralPicker.reloadAllComponents()
                }
            }
        }else if textField == truckWeightTF {
            truckWeightTF.inputView = GeneralPicker
            truckWeightTF.inputAccessoryView = GeneralPicker.toolbar
            SelectedTextField = truckWeightTF
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.getName() == truckWeightTF.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == cargoLoadCapTF {
            cargoLoadCapTF.inputView = GeneralPicker
            cargoLoadCapTF.inputAccessoryView = GeneralPicker.toolbar
            SelectedTextField = cargoLoadCapTF
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where:{$0.getName() == cargoLoadCapTF.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == txtCapacityType {
            SelectedTextField = txtCapacityType
            txtCapacityType.inputView = GeneralPicker
            txtCapacityType.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.getName() == txtCapacityType.text}){
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtTruckWeight || textField == txtCargoLoadCapacity{
            if let weight:Int = Int(textField.text ?? ""){
                if weight <= 0{
                    textField.text = ""
                }
                if textField.text?.count ?? 0 > 5{
                    var text = textField.text ?? ""
                    text.removeLast()
                    textField.text = text
                }
            }else{
                textField.text = ""
            }
        }
    }
}

//MARK: - PickerView delegate
extension AddTruckVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectedTextField == txtTruckType {
            return SingletonClass.sharedInstance.TruckTypeList?.count ?? 0
        } else if SelectedTextField == txtTruckSubType {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0
        }
        else if SelectedTextField == truckWeightTF {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        } else if SelectedTextField == cargoLoadCapTF {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        }else if SelectedTextField == txtCapacityType {
            return SingletonClass.sharedInstance.PackageList?.count ?? 0
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getTitle(row)
    }
    
    func getTitle(_ index: Int) -> String{
        if SelectedTextField == txtTruckType {
            return SingletonClass.sharedInstance.TruckTypeList?[index].getName() ?? ""
        }else if SelectedTextField == txtTruckSubType {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[index].getName() ?? ""
        }else if SelectedTextField == truckWeightTF || SelectedTextField == cargoLoadCapTF{
            return SingletonClass.sharedInstance.TruckunitList?[index].getName() ?? ""
        }else if SelectedTextField == txtCapacityType {
            return SingletonClass.sharedInstance.PackageList?[index].getName() ?? ""
        }
        return ""
    }
}
//MARK: - GeneralPickerView Delegate
extension AddTruckVC: GeneralPickerViewDelegate{
    func didTapDone() {
        if SelectedTextField == txtTruckType {
            setTruckType()
        } else if SelectedTextField == txtTruckSubType {
            setTrucksubType()
        }else if SelectedTextField == truckWeightTF {
            setTruckWaight()
        }else if SelectedTextField == cargoLoadCapTF {
            setCargoLoadCapacity()
        }else if SelectedTextField == txtCapacityType {
            setCapacityType()
        }
        self.txtTruckType.resignFirstResponder()
        self.txtTruckSubType.resignFirstResponder()
    }
    func didTapCancel() {
    }
    
    func setTruckType(){
        SelectedCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
        let item = SingletonClass.sharedInstance.TruckTypeList?[GeneralPicker.selectedRow(inComponent: 0)]
        self.txtTruckType.text = item?.getName()
        self.SelectedCategory  = item?.id ?? 0
        self.txtTruckSubType.text = ""
        self.SelectedSubCategory = 0
        if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0 < 1{
            viewSubType.isHidden = true
        }else{
            viewSubType.isHidden = false
        }
        SelectedSubCategoryIndex = 0
        if item?.getName().lowercased() == "other" {
            txtTruckSubType.rightView?.isHidden = true
        } else {
            txtTruckSubType.rightView?.isHidden = false
        }
    }
    
    func setTrucksubType(){
        if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count != 0 {
            SelectedSubCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
            let item = SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[GeneralPicker.selectedRow(inComponent: 0)]
            self.txtTruckSubType.text = item?.getName()
            self.SelectedSubCategory  = item?.id ?? 0
        }
    }
    
    func setCargoLoadCapacity(){
        let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
        self.cargoLoadCapTF.text = item?.getName()
        self.selectedCategoryUnitID = item?.id ?? 0
        self.cargoLoadCapTF.resignFirstResponder()
    }
    
    func setTruckWaight(){
        let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
        self.truckWeightTF.text = item?.getName()
        self.selectedWeightUnitID = item?.id ?? 0
        self.truckWeightTF.resignFirstResponder()
    }
    
    func setCapacityType(){
        let item = SingletonClass.sharedInstance.PackageList?[GeneralPicker.selectedRow(inComponent: 0)]
        self.txtCapacityType.text = item?.getName()
        self.txtCapacityType.resignFirstResponder()
    }
    
}
//MARK: - Collection view datasource and delegate
extension AddTruckVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionTruckCapacity {
            return TruckCapacityAdded.count
        }else if collectionView == collectionImages {
            var count = 0
            if isEditEnable{
                count = 1
            }
            return (imageUrlArray.count > 0) ? imageUrlArray.count + count : count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTruckCapacity {
            let cell = collectionTruckCapacity.dequeueReusableCell(withReuseIdentifier: "TruckCapacityCell", for: indexPath) as! TruckCapacityCell
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                let StringForSize = "\(TruckCapacityAdded[indexPath.row].capacity ?? "") \(SingletonClass.sharedInstance.PackageList?[index].getName() ?? "" )"
                cell.lblCapacity.text = StringForSize
            }else{
                
            }
            cell.btnRemove.isHidden = !isEditEnable
            cell.btnView.isHidden = !isEditEnable
            cell.RemoveClick = {
                if self.isEditEnable{
                    self.removeTruck(index: indexPath.row)
                }
            }
            return cell
        }else if collectionView == collectionImages {
            if(indexPath.row == 0 && isEditEnable){
                let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: UploadVideoAndImagesCell.className, for: indexPath)as! UploadVideoAndImagesCell
                cell.btnUploadImg = {
                    self.updateImage()
                }
                return cell
            }else{
                var count = 0
                if isEditEnable{
                    count = 1
                }
                let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: collectionPhotos.className, for: indexPath)as! collectionPhotos
                cell.imgPhotos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgPhotos.sd_setImage(with: URL(string: imageUrlArray[indexPath.row - count]), placeholderImage: UIImage())
                cell.btnCancel.isHidden = !isEditEnable
                cell.btnCancel.tag = indexPath.row - count
                cell.btnCancel.addTarget(self, action: #selector(deleteImagesClicked(sender:)), for: .touchUpInside)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionTruckCapacity {
            ButtonTypeForAddingCapacity = .Update
            SelectedIndexOfType = indexPath.row
            btnAdd.setImage(#imageLiteral(resourceName: "ic_edit"), for: .normal)
            TextFieldCapacity.text = TruckCapacityAdded[indexPath.row].capacity
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                txtCapacityType.text = SingletonClass.sharedInstance.PackageList?[index].getName() ?? ""
            }
        }else if collectionView == collectionImages {
            //            if(indexPath.row != 0){
            let vc : GalaryVC = GalaryVC.instantiate(fromAppStoryboard: .Auth)
            vc.firstTimeSelectedIndex = indexPath.row - 1
            vc.arrImage = self.imageUrlArray
            vc.isFromEdit = isFromEdit
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionTruckCapacity{
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                let StringForSize = "\(TruckCapacityAdded[indexPath.row].capacity ?? "") \(SingletonClass.sharedInstance.PackageList?[index].getName() ?? "" )"
                return CGSize(width: (StringForSize.sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 50
                              , height: collectionTruckCapacity.frame.size.height - 10)
            }
        }else if collectionView == collectionImages {
            return CGSize(width: collectionView.bounds.width/3 - 10, height: collectionView.bounds.width/3 - 10)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    
    func removeTruck(index:Int){
        self.btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
        self.ButtonTypeForAddingCapacity = .Add
        self.TextFieldCapacity.text = ""
        self.txtCapacityType.text = ""
        self.TextFieldCapacity.resignFirstResponder()
        self.txtCapacityType.resignFirstResponder()
        self.TruckCapacityAdded.remove(at: index)
        self.collectionTruckCapacity.reloadData()
    }
    
    func updateImage(){
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
        AttachmentHandler.shared.imagePickedBlock = { (image) in
            self.collectionImages.reloadData()
            self.ImageUploadAPI(arrImages: [image])
            self.heightConstrentImagcollection.constant = self.collectionImages.bounds.width/3 - 10
        }
    }
    
    @objc func deleteImagesClicked(sender : UIButton){
        arrImages.remove(at: sender.tag)
        imageUrlArray.remove(at: sender.tag)
        self.collectionImages.reloadData()
    }
}

//MARK: - UITableView datasource and delegate Methods
extension AddTruckVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTruckFeature.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblTruckFeature.dequeueReusableCell(withIdentifier: "TruckFeatureCell") as! TruckFeatureCell
        cell.selectionStyle = .none
        cell.lblFeature.text = self.arrTruckFeature[indexPath.row].getName() ?? ""
        if(self.arrFeatureID.contains("\(self.arrTruckFeature[indexPath.row].id ?? 0)")){
            cell.imgCell.image = UIImage(named: "ic_checkbox_selected")
        }else{
            cell.imgCell.image = UIImage(named: "ic_checkbox_unselected")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditEnable{
            if(self.arrFeatureID.contains("\(self.arrTruckFeature[indexPath.row].id ?? 0)")){
                let index = self.arrFeatureID.firstIndex(where: { $0 == "\(self.arrTruckFeature[indexPath.row].id ?? 0)" })
                self.arrFeatureID.remove(at: index!)
            }else{
                self.arrFeatureID.append("\(self.arrTruckFeature[indexPath.row].id ?? 0)")
            }
            self.tblTruckFeature.reloadData()
        }
    }
}

//MARK: - Web service
extension AddTruckVC{
    func callWebService(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonString = try! encoder.encode([self.tructData])
        let finalJson = String(data: jsonString, encoding: .utf8)!
        let reqModel = AddTruckReqModel()
        reqModel.truck_details = finalJson
        self.addTruckViewModel.webServiceForAddTruck(reqModel: reqModel)
    }
}
