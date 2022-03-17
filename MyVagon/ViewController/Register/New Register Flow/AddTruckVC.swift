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
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewAddCapacity: UIView!
    @IBOutlet weak var CollectionViewImageHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var tblTruckFeature: UITableView!
    @IBOutlet weak var tblTruckFeatureHeight: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstrentImagcollection: NSLayoutConstraint!
    
    var arrTruckFeature : [TruckFeaturesDatum] = []
    var SelectedTextField : UITextField?
    var SelectedCategoryIndex = 0
    var SelectedSubCategoryIndex = 0
    var SelectedCategory = 0
    var SelectedSubCategory = 0
    let GeneralPicker = GeneralPickerView()
    var ButtonTypeForAddingCapacity : AddCapacityTypeButtonName?
    var SelectedIndexOfType = NSNotFound
    var arrImages : [String] = []
    var arrFeatureID : [String] = []
    
    var selectedWeightUnitID = 0
    var selectedCategoryUnitID = 0
    
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
    var truckEditDeta : TruckDetails?
    var truckIndex = 0
    var editeData : ((TruckDetails) -> Void)?
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        print("setdata ",truckEditDeta)
        if isFromEdit {
            self.setEditDeta()
        }
        self.enableEdit()
        self.setUpNevigetionBar()
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "editprofile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "editprofile"), object: nil)
    }
    
    
    //MARK: - Custom methods
    func setupUI(){
        
        self.tblTruckFeature.delegate = self
        self.tblTruckFeature.dataSource = self
        self.tblTruckFeature.showsVerticalScrollIndicator = false
        self.tblTruckFeature.showsHorizontalScrollIndicator = false
        self.tblTruckFeature.separatorStyle = .none
        self.tblTruckFeature.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.CollectionViewImageHeightConst.constant = collectionImages.bounds.width/3 - 10
        self.registerNib()
    }
    
    func setUpNevigetionBar(){
        if isFromEdit{
            if isEditEnable {
                self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Edit Truck", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
            }else{
                setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Truck", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.editProfile.value], isTranslucent: true, ShowShadow: true)
            }
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
        self.btnAdd.isUserInteractionEnabled = isEditEnable
        self.viewAddCapacity.isHidden = !isEditEnable
        self.btnSave.isHidden = !isEditEnable
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
        self.GeneralPicker.dataSource = self
        self.GeneralPicker.delegate = self
        self.GeneralPicker.generalPickerDelegate = self
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
        self.txtTruckType.text = truckEditDeta?.truckType?.name
        self.txtTruckSubType.text = truckEditDeta?.truckSubCategory?.name
        self.viewSubType.isHidden = false
        self.truckWeightTF.text = truckEditDeta?.weightUnit?.name
        self.cargoLoadCapTF.text = truckEditDeta?.loadCapacityUnit?.name
        self.txtTruckWeight.text = truckEditDeta?.weight
        self.txtCargoLoadCapacity.text = truckEditDeta?.loadCapacity
        self.txtTruckLicencePlate.text = truckEditDeta?.plateNumber
        self.arrImages = truckEditDeta?.images ?? []
        self.arrFeatureID = truckEditDeta?.truckFeatures?.components(separatedBy: ",") ?? []
        let capacity = SingletonClass.sharedInstance.UserProfileData?.vehicle?.vehicleCapacity?[truckIndex]
        let item = TruckCapacityType(Capacity: capacity?.value ?? "", Type: capacity?.packageTypeId?.id ?? 0)
        TruckCapacityAdded.removeAll()
        TruckCapacityAdded.append(item)
        collectionTruckCapacity.reloadData()
    }
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        
        self.addTruckViewModel.TruckDetail = self
        self.addTruckViewModel.WebServiceImageUpload(images: arrImages)
    }
    
    func validetion() -> (Bool,String){
        let truckType = txtTruckType.validatedText(validationType: .requiredField(field: "truck type"))
        let truckSubType = txtTruckSubType.validatedText(validationType: .requiredField(field: "truck sub type"))
        let overallWeight = txtTruckWeight.validatedText(validationType: .requiredField(field: "truck weight"))
        let weightUnit = truckWeightTF.validatedText(validationType: .requiredField(field: "truck weight unit"))
        let loadCapacity = txtCargoLoadCapacity.validatedText(validationType: .requiredField(field: "cargo load capacity"))
        let loadUnit = cargoLoadCapTF.validatedText(validationType: .requiredField(field: "cargo load capacity unit"))
        let licenceNumber = txtTruckLicencePlate.validatedText(validationType: .requiredField(field: "truck licence plate number"))
        

        if !truckType.0{
            return truckType
        }else if !truckSubType.0{
            return truckSubType
        }else if !overallWeight.0{
            return overallWeight
        }else if !weightUnit.0{
            return weightUnit
        }else if !loadCapacity.0{
            return loadCapacity
        }else if !loadUnit.0{
            return loadUnit
        }else if TruckCapacityAdded.count == 0{
            return (false,"Plaese add capacity")
        }else if !licenceNumber.0{
            return licenceNumber
        }else if arrImages.count == 0{
            return (false,"Plaese add truck images")
        }else if(self.arrFeatureID.count == 0){
            return (false,"Plaese select truck features")
        }
        else{
            return (true,"Succesfull")
        }
    }
    
    @objc func ProfileEdit(){
        print("in edit notification")
        self.isEditEnable = true
        self.enableEdit()
        self.collectionImages.reloadData()
        self.setUpNevigetionBar()
        }
    
    @IBAction func btnActionHydraulicDoor(_ sender: UIButton) {
        self.btnHydraulicDoor.isSelected = !self.btnHydraulicDoor.isSelected
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        if TextFieldCapacity.text ?? "" == "" {
            Utilities.ShowAlertOfInfo(OfMessage: "Please enter capacity")
        } else  if txtCapacityType.text ?? "" == "" {
            Utilities.ShowAlertOfInfo(OfMessage: "Please select capacity type")
        } else {
            if ButtonTypeForAddingCapacity == .Update {
                guard let IndexOfType = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == txtCapacityType.text ?? ""}) else {
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
                            Utilities.ShowAlertOfInfo(OfMessage: "You can add only one time \(SingletonClass.sharedInstance.PackageList?[IndexOfType].name ?? "")")
                        }
                    } else {
                        TruckCapacityAdded[SelectedIndexOfType] = (TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: updatedIdType))
                        btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                        ButtonTypeForAddingCapacity = .Add
                        self.setCollection()
                    }
                }
            } else {
                if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == txtCapacityType.text ?? ""})
                {
                    if TruckCapacityAdded.contains(where: {$0.type == SingletonClass.sharedInstance.PackageList?[index].id ?? 0}) {
                        Utilities.ShowAlertOfInfo(OfMessage: "You can add only one time \(SingletonClass.sharedInstance.PackageList?[index].name ?? "")")
                    } else {
                        TruckCapacityAdded.append(TruckCapacityType(Capacity: TextFieldCapacity.text ?? "", Type: SingletonClass.sharedInstance.PackageList?[index].id ?? 0))
                        self.setCollection()
                    }
                }
            }
        }
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let velidetion = validetion()
        if velidetion.0{
            if isFromEdit{
                truckEditDeta?.images = arrImages
                truckEditDeta?.weight = txtTruckWeight.text
                truckEditDeta?.loadCapacity = self.txtCargoLoadCapacity.text
                truckEditDeta?.plateNumber = self.txtTruckLicencePlate.text
                truckEditDeta?.truckFeatures = arrFeatureID.map({$0}).joined(separator: ",")
                truckEditDeta?.loadCapacityUnit?.name = cargoLoadCapTF.text
                if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.first(where:{$0.name == cargoLoadCapTF.text ?? ""}) {
                    truckEditDeta?.loadCapacityUnit?.id = DummyFirst.id
                }
                
                truckEditDeta?.weightUnit?.name = truckWeightTF.text
                if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.first(where: {$0.name == truckWeightTF.text ?? ""}) {
                    truckEditDeta?.weightUnit?.id = DummyFirst.id
                }
                
                truckEditDeta?.truckType?.name = txtTruckType.text
                if let DummyFirst = SingletonClass.sharedInstance.TruckTypeList?.first(where: {$0.name == txtTruckType.text ?? ""}) {
                    truckEditDeta?.truckSubCategory?.id = DummyFirst.id
                }
                
                truckEditDeta?.truckSubCategory?.name = txtTruckSubType.text
                if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.id ?? 0)}) {
                    if let DummyFirst = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.first(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory?.id ?? 0)}) {
                        truckEditDeta?.truckSubCategory?.id = DummyFirst.id
                    }
                }
                
                self.editeData?(truckEditDeta!)
                self.navigationController?.popViewController(animated: true)
            }else{
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
                SingletonClass.sharedInstance.RegisterData.Reg_truck_data.append(self.tructData)
                
                UserDefault.SetRegiterData()
                UserDefault.synchronize()
                
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    NotificationCenter.default.post(name: .reloadRegTruckListScreen, object: nil)
                }
            }
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: velidetion.1)
        }
    }
    
}
//MARK: - Text field delegate
extension AddTruckVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTruckType {
            SelectedTextField = txtTruckType
            txtTruckType.inputView = GeneralPicker
            txtTruckType.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.name == txtTruckType.text ?? ""}) {
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
                    
                    if let IndexForTruckType = SingletonClass.sharedInstance.TruckTypeList?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.id ?? 0)}) {
                        
                        if let IndexForSubTruckType = SingletonClass.sharedInstance.TruckTypeList?[IndexForTruckType].category?.firstIndex(where: {$0.id == (SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory?.id ?? 0)}) {
                            GeneralPicker.selectRow(IndexForSubTruckType, inComponent: 0, animated: false)
                        }
                    }
                    self.GeneralPicker.reloadAllComponents()
                }
            } else {
                
            }
        }else if textField == truckWeightTF {
            truckWeightTF.inputView = GeneralPicker
            truckWeightTF.inputAccessoryView = GeneralPicker.toolbar
            SelectedTextField = truckWeightTF
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where: {$0.name == truckWeightTF.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == cargoLoadCapTF {
            cargoLoadCapTF.inputView = GeneralPicker
            cargoLoadCapTF.inputAccessoryView = GeneralPicker.toolbar
            SelectedTextField = cargoLoadCapTF
            if let DummyFirst = SingletonClass.sharedInstance.TruckunitList?.firstIndex(where:{$0.name == cargoLoadCapTF.text ?? ""}) {
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        } else if textField == txtCapacityType {
            SelectedTextField = txtCapacityType
            txtCapacityType.inputView = GeneralPicker
            txtCapacityType.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == txtCapacityType.text}){
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        }
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == txtTruckWeight || textField == txtCargoLoadCapacity{
            if let abc = Int(textField.text ?? "0"){
                if abc <= 0{
                    textField.text = ""
                }
            }else{
                textField.text = ""
            }
        }
    }
}
//MARK: - PickerView delegate
extension AddTruckVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
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
        if SelectedTextField == txtTruckType {
            return SingletonClass.sharedInstance.TruckTypeList?[row].name
        } else if SelectedTextField == txtTruckSubType {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[row].name
        }
        else if SelectedTextField == truckWeightTF {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        } else if SelectedTextField == cargoLoadCapTF {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        }else if SelectedTextField == txtCapacityType {
            return SingletonClass.sharedInstance.PackageList?[row].name
        }
        return ""
    }
}
//MARK: - GeneralPickerView Delegate
extension AddTruckVC: GeneralPickerViewDelegate{
    func didTapDone() {
        if SelectedTextField == txtTruckType {
            
            SelectedCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
            let item = SingletonClass.sharedInstance.TruckTypeList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.txtTruckType.text = item?.name
            self.SelectedCategory  = item?.id ?? 0
            self.txtTruckSubType.text = ""
            
            if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0 < 1{
                viewSubType.isHidden = true
            }else{
                viewSubType.isHidden = false
            }
            SelectedSubCategoryIndex = 0
            if item?.name?.lowercased() == "other" {
                txtTruckSubType.rightView?.isHidden = true
            } else {
                txtTruckSubType.rightView?.isHidden = false
            }
            
        } else if SelectedTextField == txtTruckSubType {
            
            if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count != 0 {
                SelectedSubCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
                let item = SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[GeneralPicker.selectedRow(inComponent: 0)]
                self.txtTruckSubType.text = item?.name
                self.SelectedSubCategory  = item?.id ?? 0
            }
        }else  if SelectedTextField == truckWeightTF {
            
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.truckWeightTF.text = item?.name
            self.selectedWeightUnitID = item?.id ?? 0
            self.truckWeightTF.resignFirstResponder()
        } else if SelectedTextField == cargoLoadCapTF {
            
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.cargoLoadCapTF.text = item?.name
            self.selectedCategoryUnitID = item?.id ?? 0
            self.cargoLoadCapTF.resignFirstResponder()
        }else if SelectedTextField == txtCapacityType {
            
            let item = SingletonClass.sharedInstance.PackageList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.txtCapacityType.text = item?.name
            self.txtCapacityType.resignFirstResponder()
        }
        self.txtTruckType.resignFirstResponder()
        self.txtTruckSubType.resignFirstResponder()
    }
    
    func didTapCancel() {
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
            return (arrImages.count > 0) ? arrImages.count + count : count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTruckCapacity {
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
                if self.isEditEnable{
                self.btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                self.ButtonTypeForAddingCapacity = .Add
                
                self.TextFieldCapacity.text = ""
                self.txtCapacityType.text = ""
                
                self.TextFieldCapacity.resignFirstResponder()
                self.txtCapacityType.resignFirstResponder()
                
                self.TruckCapacityAdded.remove(at: indexPath.row)
                self.collectionTruckCapacity.reloadData()
                }
            }
            return cell
        }else if collectionView == collectionImages {
            if(indexPath.row == 0 && isEditEnable){
                let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: UploadVideoAndImagesCell.className, for: indexPath)as! UploadVideoAndImagesCell
                cell.btnUploadImg = {
                    AttachmentHandler.shared.showAttachmentActionSheet(vc: self)
                    AttachmentHandler.shared.imagePickedBlock = { (image) in
                        self.collectionImages.reloadData()
                        self.ImageUploadAPI(arrImages: [image])
                        self.heightConstrentImagcollection.constant = self.collectionImages.bounds.width/3 - 10
                    }
                }
                return cell
            }else{
                var count = 0
                if isEditEnable{
                    count = 1
                }
                let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: collectionPhotos.className, for: indexPath)as! collectionPhotos
                let strUrl = "\(APIEnvironment.TempProfileURL)\(arrImages[indexPath.row - count])"
                cell.imgPhotos.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgPhotos.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
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
                txtCapacityType.text = SingletonClass.sharedInstance.PackageList?[index].name ?? ""
            }
        }else if collectionView == collectionImages {
//            if(indexPath.row != 0){
                let vc : GalaryVC = GalaryVC.instantiate(fromAppStoryboard: .Auth)
                vc.firstTimeSelectedIndex = indexPath.row - 1
                vc.arrImage = self.arrImages
                self.navigationController?.present(vc, animated: true)
            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionTruckCapacity{
            if let index = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.id == TruckCapacityAdded[indexPath.row].type}) {
                let StringForSize = "\(TruckCapacityAdded[indexPath.row].capacity ?? "") \(SingletonClass.sharedInstance.PackageList?[index].name ?? "" )"
                return CGSize(width: (StringForSize.sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 50
                              , height: collectionTruckCapacity.frame.size.height - 10)
            }
        }else if collectionView == collectionImages {
            return CGSize(width: collectionView.bounds.width/3 - 10, height: collectionView.bounds.width/3 - 10)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    
    @objc func deleteImagesClicked(sender : UIButton){
        arrImages.remove(at: sender.tag)
        self.collectionImages.reloadData()
    }
}

//MARK: - UITableView Methods
extension AddTruckVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTruckFeature.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblTruckFeature.dequeueReusableCell(withIdentifier: "TruckFeatureCell") as! TruckFeatureCell
        cell.selectionStyle = .none
        cell.lblFeature.text = self.arrTruckFeature[indexPath.row].name ?? ""
        
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
        print(self.arrFeatureID)
    }
}
