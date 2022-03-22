//
//  TractorDetailVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 28/02/22.
//

import UIKit
import SDWebImage

class TractorDetailVC: BaseViewController {
// dhananjay
    //MARK: - Properties
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet weak var collectionImages: UICollectionView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtTractorBrand: themeTextfield!
    @IBOutlet weak var txtLicencePlateNumber: themeTextfield!
    @IBOutlet weak var viewTabView: UIView!
    
    @IBOutlet weak var heightConstrentImagcollection: NSLayoutConstraint!
    @IBOutlet weak var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    var tabTypeSelection = Tabselect.Diesel.rawValue
    let GeneralPicker = GeneralPickerView()
    var SelectedTextField : UITextField?
    var arrImages : [String] = []
    var tractorDetailsViewModel = TractorDetailViewModel()
    var selectedBrandID = 0
    var isFromEdit = false
    var isEditEnable = true
    var editTractorDetailViewModel = EditTractorDetailViewModel()
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        if isFromEdit{
            isEditEnable = false
            self.setProfileData()
        }else{
            self.setupPreviousData()
        }
        self.setupData()
        self.enableEdit()
        self.setUpNevigetionBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "editprofile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "editprofile"), object: nil)
    }
    
    //MARK: - Custom methods
    func setupUI(){
        for i in btnSelection{
            self.selectedBtnUIChanges(Selected: false, Btn: i)
        }
    }
    
    func setUpNevigetionBar(){
        if isFromEdit{
            if isEditEnable {
                setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Edit Tractor Detail", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
            }else{
                setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Tractor Detail", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.editProfile.value], isTranslucent: true, ShowShadow: true)
            }
        }else{
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Tractor Detail", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        }
    }
    
    func setupData(){
        txtTractorBrand.delegate = self
        self.collectionImages.dataSource = self
        self.collectionImages.delegate = self
        self.collectionImages.showsHorizontalScrollIndicator = false
        self.collectionImages.showsVerticalScrollIndicator = false
        
        self.GeneralPicker.dataSource = self
        self.GeneralPicker.delegate = self
        self.GeneralPicker.generalPickerDelegate = self
        
        let uploadnib = UINib(nibName: UploadVideoAndImagesCell.className, bundle: nil)
        collectionImages.register(uploadnib, forCellWithReuseIdentifier: UploadVideoAndImagesCell.className)
        collectionImages.register(uploadnib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UploadVideoAndImagesCell.className)
        let nib = UINib(nibName: collectionPhotos.className, bundle: nil)
        collectionImages.register(nib, forCellWithReuseIdentifier: collectionPhotos.className)
    }

    func setupPreviousData(){
        
        switch SingletonClass.sharedInstance.RegisterData.Reg_tractor_fual_type  {
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
            selectedBtnUIChanges(Selected: true, Btn:btnSelection[0])
            self.tabTypeSelection = Tabselect.Diesel.rawValue
            self.btnLeadingConstaintOfAnimationView.constant = btnSelection[0].superview?.frame.origin.x ?? 0.0
            UIView.animate(withDuration: 0.3) {
                self.viewTabView.layoutIfNeeded()
            }
            break
        }
        
        self.txtTractorBrand.text = SingletonClass.sharedInstance.RegisterData.Reg_tractor_brand
        self.txtLicencePlateNumber.text = SingletonClass.sharedInstance.RegisterData.Reg_tractor_plate_number
        
        self.arrImages = SingletonClass.sharedInstance.RegisterData.Reg_tractor_images
        self.collectionImages.reloadData()
        self.heightConstrentImagcollection.constant = collectionImages.bounds.width/3 - 10
    }
    
    
    func setProfileData(){
        switch SingletonClass.sharedInstance.UserProfileData?.vehicle?.fuelType {
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
            selectedBtnUIChanges(Selected: true, Btn:btnSelection[0])
            self.tabTypeSelection = Tabselect.Diesel.rawValue
            self.btnLeadingConstaintOfAnimationView.constant = btnSelection[0].superview?.frame.origin.x ?? 0.0
            UIView.animate(withDuration: 0.3) {
                self.viewTabView.layoutIfNeeded()
            }
            break
        }
        
        self.txtTractorBrand.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.brands?.name ?? ""
        self.txtLicencePlateNumber.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.registrationNo
        self.arrImages = SingletonClass.sharedInstance.UserProfileData?.vehicle?.images ?? []
        self.collectionImages.reloadData()
        self.heightConstrentImagcollection.constant = collectionImages.bounds.width/3 - 10
    }
    
    func enableEdit(){
        txtTractorBrand.isUserInteractionEnabled = isEditEnable
        txtLicencePlateNumber.isUserInteractionEnabled = isEditEnable
        for i in btnSelection{
            i.isUserInteractionEnabled = isEditEnable
        }
        btnSave.isHidden = !isEditEnable
        btnSave.setTitle(self.isFromEdit ? "Save" : "Continue", for: .normal)
    }
    
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
    }
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        
        self.tractorDetailsViewModel.TruckDetail = self
        self.tractorDetailsViewModel.WebServiceImageUpload(images: arrImages)
    }
    
    func validetion() -> (Bool,String){
        let tractorBrand = txtTractorBrand.validatedText(validationType: .requiredField(field: "tractor"))
        let tractorPlateNumber = txtLicencePlateNumber.validatedText(validationType: .requiredField(field: "tractor licence plate number"))
        if !tractorBrand.0{
            return (false,"Select tractor brand")
        }else if !tractorPlateNumber.0{
            return tractorPlateNumber
        }else if arrImages.count == 0{
            return (false,"add tractor images")
        }else{
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
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let velidetion = validetion()
        if velidetion.0{
            if isFromEdit{
                let reqModel = EditTractorDetailReqModel()
                reqModel.brand = txtTractorBrand.text
                reqModel.fuel_type = tabTypeSelection
                reqModel.images = arrImages.map({$0}).joined(separator: ",")
                reqModel.plate_number = txtLicencePlateNumber.text
                self.callWebServiceForEditTractorDetail(reqModel: reqModel)
            }else{
                SingletonClass.sharedInstance.RegisterData.Reg_tractor_fual_type = self.tabTypeSelection
                SingletonClass.sharedInstance.RegisterData.Reg_tractor_brand = "\(self.selectedBrandID)"
                SingletonClass.sharedInstance.RegisterData.Reg_tractor_plate_number = txtLicencePlateNumber.text ?? ""
                SingletonClass.sharedInstance.RegisterData.Reg_tractor_images = self.arrImages
                
                UserDefault.SetRegiterData()
                UserDefault.setValue(1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
                UserDefault.synchronize()
                
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 2
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            }
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: velidetion.1)
        }
    }
    
}

//MARK: - Text field delegate
extension TractorDetailVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtTractorBrand {
           SelectedTextField = txtTractorBrand
            txtTractorBrand.inputView = GeneralPicker
            txtTractorBrand.inputAccessoryView = GeneralPicker.toolbar
           if let DummyFirst = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == txtTractorBrand.text ?? ""}){
               
               GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
           }
           self.GeneralPicker.reloadAllComponents()
       }
    }
}


//MARK: - PickerView delegate
extension TractorDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if SelectedTextField == txtTractorBrand {
            return SingletonClass.sharedInstance.TruckBrandList?.count ?? 0
        }
        return 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if SelectedTextField == txtTractorBrand {
            return SingletonClass.sharedInstance.TruckBrandList?[row].name
        }
        return ""
    }
}

//MARK: - GeneralPickerView Delegate
extension TractorDetailVC: GeneralPickerViewDelegate{
    
    func didTapCancel() {
        
    }

    func didTapDone() {
        if SelectedTextField == txtTractorBrand {
            let item = SingletonClass.sharedInstance.TruckBrandList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.txtTractorBrand.text = item?.name
            self.selectedBrandID = item?.id ?? 0
            self.txtTractorBrand.resignFirstResponder()
        }
    }
    
}
//MARK: - Collection view datasource and delegate
extension TractorDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if isEditEnable{
            count = 1
        }
        return (arrImages.count > 0) ? arrImages.count + count : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            let vc : GalaryVC = GalaryVC.instantiate(fromAppStoryboard: .Auth)
            vc.firstTimeSelectedIndex = indexPath.row - 1
            vc.arrImage = self.arrImages
            self.navigationController?.present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3 - 10, height: collectionView.bounds.width/3 - 10)
    }
    
    @objc func deleteImagesClicked(sender : UIButton){
        arrImages.remove(at: sender.tag)
        self.collectionImages.reloadData()
        self.heightConstrentImagcollection.constant = collectionImages.bounds.width/3 - 10
    }

}
// web services
extension TractorDetailVC{
    
    func callWebServiceForEditTractorDetail(reqModel: EditTractorDetailReqModel){
        editTractorDetailViewModel.callwebservice(reqModel: reqModel)
    }
    
}
