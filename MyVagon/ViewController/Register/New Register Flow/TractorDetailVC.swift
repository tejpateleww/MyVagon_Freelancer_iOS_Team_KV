//
//  TractorDetailVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 28/02/22.
//

import UIKit
import SDWebImage

class TractorDetailVC: UIViewController {

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
    
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        self.setupPreviousData()
    }
    
    
    //MARK: - Custom methods
    func setupUI(){
        for i in btnSelection{
            self.selectedBtnUIChanges(Selected: false, Btn: i)
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
            
            SingletonClass.sharedInstance.RegisterData.Reg_tractor_fual_type = self.tabTypeSelection
            SingletonClass.sharedInstance.RegisterData.Reg_tractor_brand = txtTractorBrand.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_tractor_plate_number = txtLicencePlateNumber.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_tractor_images = self.arrImages
            
            UserDefault.SetRegiterData()
            UserDefault.setValue(1, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
            
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 2
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            RegisterMainVC.viewDidLayoutSubviews()
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
            
            self.txtTractorBrand.resignFirstResponder()
        }
    }
    
}
//MARK: - Collection view datasource and delegate
extension TractorDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (arrImages.count > 0) ? arrImages.count + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
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
            let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: collectionPhotos.className, for: indexPath)as! collectionPhotos
            let strUrl = "\(APIEnvironment.TempProfileURL)\(arrImages[indexPath.row - 1])"
            cell.imgPhotos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgPhotos.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
            
            cell.btnCancel.tag = indexPath.row - 1
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
