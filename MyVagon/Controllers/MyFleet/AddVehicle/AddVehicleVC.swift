//
//  AddVehicleVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/01/22.
//

import UIKit

//MARK: -
class AddVehicleVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var txtTruckType: themeTextfield!
    @IBOutlet weak var txtTruckSubType: themeTextfield!
    @IBOutlet weak var txtTruckWeight: themeTextfield!
    @IBOutlet weak var txtCargoLoadCapacity: themeTextfield!
    @IBOutlet weak var txtTrailerPlate: themeTextfield!
    @IBOutlet weak var txtTruckPlate: themeTextfield!
    @IBOutlet weak var txtCapacity: MyProfileTextField!
    @IBOutlet weak var txtBrand: MyProfileTextField!
    @IBOutlet weak var txtTruckBrand: themeTextfield!
    @IBOutlet weak var txtCapacityType: themeTextfield!
    @IBOutlet weak var TextFieldCapacity: themeTextfield!
    @IBOutlet weak var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet weak var viewTabView: UIView!
    @IBOutlet weak var truckWeightTF: themeTextfield!
    @IBOutlet weak var cargoLoadCapTF: themeTextfield!
    @IBOutlet weak var collectionTruckCapacity: UICollectionView!
    @IBOutlet weak var btnHydraulicDoor: UIButton!
    @IBOutlet weak var imgVehicle: UIImageView!
    @IBOutlet weak var btnAdd: themeButton!
    @IBOutlet var btnSelection: [UIButton]!
    
    private var imagePicker : ImagePicker!
    let GeneralPicker = GeneralPickerView()
    var SelectedTextField : UITextField?
    var SelectedCategoryIndex = 0
    var SelectedSubCategoryIndex = 0
    var tabTypeSelection = Tabselect.Diesel.rawValue
    var ButtonTypeForAddingCapacity : AddCapacityTypeButtonName?
    var selectedIndex = NSNotFound
    var SelectedIndexOfType = NSNotFound
    var isvahicalImg = false
    var TruckCapacityAdded : [TruckCapacityType] = [] {
        didSet {
            if TruckCapacityAdded.count == 0 {
                collectionTruckCapacity.isHidden = true
            } else {
                collectionTruckCapacity.isHidden = false
            }
        }
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    //MARK: - Custom methods
    func setupUI(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self, allowsEditing: true)
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Add Vehicle", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.txtTruckSubType.isUserInteractionEnabled = false
        for i in btnSelection{
            self.selectedBtnUIChanges(Selected: false, Btn: i)
        }
        self.selectedBtnUIChanges(Selected: true, Btn:btnSelection.first!)
        self.tabTypeSelection = Tabselect.Diesel.rawValue
    }
    
    func setupData(){
        self.txtTruckBrand.delegate = self
        self.txtTruckType.delegate = self
        self.txtTruckSubType.delegate = self
        self.txtTruckPlate.delegate = self
        self.txtTrailerPlate.delegate = self
        self.txtTruckWeight.delegate = self
        self.txtCapacityType.delegate = self
        self.txtCargoLoadCapacity.delegate = self
        self.truckWeightTF.delegate = self
        self.cargoLoadCapTF.delegate = self
        self.GeneralPicker.dataSource = self
        self.GeneralPicker.delegate = self
        self.collectionTruckCapacity.dataSource = self
        self.collectionTruckCapacity.delegate = self
        self.GeneralPicker.generalPickerDelegate = self
        
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnActionHydraulicDoor(_ sender: UIButton) {
        self.btnHydraulicDoor.isSelected = !self.btnHydraulicDoor.isSelected
    }
    
    @IBAction func btnActionAddVehicle(_ sender: UIButton) {
        let validation = validation()
        if validation.0{
            Utilities.ShowAlertOfSuccess(OfMessage: validation.1)
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: validation.1)
        }
    }
    
    @IBAction func btnActionVehiclePhoto(_ sender: UIButton) {
        self.imagePicker.present(from: imgVehicle, viewPresented: self.view, isRemove: isvahicalImg)
    }
    
    @IBAction func btnTabSelection(_ sender: UIButton) {
        let _ = self.btnSelection.map{$0.isSelected = false}
        for i in self.btnSelection{
            self.selectedBtnUIChanges(Selected: false, Btn: i)
        }
        if(sender.tag == 0){
            self.selectedBtnUIChanges(Selected: true, Btn:sender)
            self.tabTypeSelection = Tabselect.Diesel.rawValue
        }else if(sender.tag == 1){
            self.tabTypeSelection = Tabselect.Electrical.rawValue
            self.selectedBtnUIChanges(Selected: true, Btn: sender)
        }else if(sender.tag == 2){
            self.tabTypeSelection = Tabselect.Hydrogen.rawValue
            self.selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        
        self.btnLeadingConstaintOfAnimationView.constant = sender.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
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
    
    func setCollection(){
        TextFieldCapacity.text = ""
        txtCapacityType.text = ""
        collectionTruckCapacity.reloadData()
        TextFieldCapacity.resignFirstResponder()
        txtCapacityType.resignFirstResponder()
    }
    
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
        
    }
    
    func validation() -> (Bool,String){
        let truckType = txtTruckType.validatedText(validationType: .requiredField(field: "truck type"))
        let truckSubType = txtTruckSubType.validatedText(validationType: .requiredField(field: "truck subtype"))
        let truckPlatNumber = txtTruckPlate.validatedText(validationType: .requiredField(field: "truck plat number"))
        let overallTrukWeight = txtTruckWeight.validatedText(validationType: .requiredField(field: "truck weight"))
        let overollUnit = truckWeightTF.validatedText(validationType: .requiredField(field: "truck weight unit"))
        let cargoCapacity = txtCargoLoadCapacity.validatedText(validationType: .requiredField(field: "cargo load capacity"))
        let cargoUnit = cargoLoadCapTF.validatedText(validationType: .requiredField(field: "cargo load capacity unit"))
        let truckBrand = txtTruckBrand.validatedText(validationType: .requiredField(field: "truck brand"))
        if !truckType.0{
            return truckType
        }else if !truckSubType.0{
            return truckSubType
        }else if !truckPlatNumber.0{
            return truckPlatNumber
        }else if !overallTrukWeight.0{
            return overallTrukWeight
        }else if !overollUnit.0{
            return overollUnit
        }else if !cargoCapacity.0{
            return cargoCapacity
        }else if !cargoUnit.0{
            return cargoUnit
        }else if !truckBrand.0{
            return truckBrand
        }else if TruckCapacityAdded.count == 0{
            return (false,"add capacity")
        }else if !isvahicalImg{
            return (false,"select vehicle photo")
        }else{
            return (true,"Succesfull")
        }
    }
    
}

//MARK: - image picker Delegate method
extension AddVehicleVC: ImagePickerDelegate {
    func didSelect(image: UIImage?, SelectedTag: Int) {
        if image != nil {
            imgVehicle.image = image
            isvahicalImg = true
        }else{
            imgVehicle.image = UIImage(named: "ic_gallary")
            isvahicalImg = false
        }
    }
}

//MARK: - Textfield Delegate
extension AddVehicleVC: UITextFieldDelegate {
    
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
        } else if textField == txtTruckBrand {
            SelectedTextField = txtTruckBrand
            txtTruckBrand.inputView = GeneralPicker
            txtTruckBrand.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == txtTruckBrand.text ?? ""}){
                
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
}

//MARK: - PickerView delegate
extension AddVehicleVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectedTextField == txtTruckType {
            return SingletonClass.sharedInstance.TruckTypeList?.count ?? 0
        } else if SelectedTextField == txtTruckSubType {
            return SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0
        } else if SelectedTextField == truckWeightTF {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        } else if SelectedTextField == cargoLoadCapTF {
            return SingletonClass.sharedInstance.TruckunitList?.count ?? 0
        }else if SelectedTextField == txtTruckBrand {
            return SingletonClass.sharedInstance.TruckBrandList?.count ?? 0
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
        } else if SelectedTextField == truckWeightTF {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        } else if SelectedTextField == cargoLoadCapTF {
            return SingletonClass.sharedInstance.TruckunitList?[row].name
        } else if SelectedTextField == txtTruckBrand {
            return SingletonClass.sharedInstance.TruckBrandList?[row].name
        } else if SelectedTextField == txtCapacityType {
            return SingletonClass.sharedInstance.PackageList?[row].name
        }
        return ""
    }
}

//MARK: - GeneralPickerView Delegate
extension AddVehicleVC: GeneralPickerViewDelegate{
    func didTapDone() {
        if SelectedTextField == txtTruckType {
            
            SelectedCategoryIndex = GeneralPicker.selectedRow(inComponent: 0)
            let item = SingletonClass.sharedInstance.TruckTypeList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.txtTruckType.text = item?.name
            self.txtTruckSubType.text = ""
            self.txtTruckPlate.text = ""
            self.txtTrailerPlate.text = ""
            
            if item?.isTrailer == 1 {
                self.txtTrailerPlate.superview?.isHidden = false
            } else {
                self.txtTrailerPlate.superview?.isHidden = true
            }
            if SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?.count ?? 0 < 1{
                txtTruckSubType.isUserInteractionEnabled = false
            }else{
                txtTruckSubType.isUserInteractionEnabled = true
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
                let item =
                SingletonClass.sharedInstance.TruckTypeList?[SelectedCategoryIndex].category?[GeneralPicker.selectedRow(inComponent: 0)]
                self.txtTruckSubType.text = item?.name
            }
        }else  if SelectedTextField == truckWeightTF {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.truckWeightTF.text = item?.name
            self.truckWeightTF.resignFirstResponder()
        } else if SelectedTextField == cargoLoadCapTF {
            let item = SingletonClass.sharedInstance.TruckunitList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.cargoLoadCapTF.text = item?.name
            self.cargoLoadCapTF.resignFirstResponder()
        } else if SelectedTextField == txtTruckBrand {
            let item = SingletonClass.sharedInstance.TruckBrandList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.txtTruckBrand.text = item?.name
            
            self.txtTruckBrand.resignFirstResponder()
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

//MARK: - Collection view delegate
extension AddVehicleVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionTruckCapacity {
            return TruckCapacityAdded.count
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
           
            
            cell.RemoveClick = {
                self.btnAdd.setImage(#imageLiteral(resourceName: "ic_add"), for: .normal)
                self.ButtonTypeForAddingCapacity = .Add
                
                self.TextFieldCapacity.text = ""
                self.txtCapacityType.text = ""
                
                self.TextFieldCapacity.resignFirstResponder()
                self.txtCapacityType.resignFirstResponder()
                
                self.TruckCapacityAdded.remove(at: indexPath.row)
                self.collectionTruckCapacity.reloadData()
            }
            return cell
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
        }
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
        }
        return CGSize(width: 0.0, height: 0.0)
    }
}
