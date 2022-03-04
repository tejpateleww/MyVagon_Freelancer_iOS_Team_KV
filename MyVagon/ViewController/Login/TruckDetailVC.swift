//
//  TruckDetailVC.swift
//  MyVagon
//
//  Created by Admin on 27/07/21.
//

import UIKit
import MobileCoreServices
import SDWebImage
import UIView_Shimmer
// ----------------------------------------------------
// MARK: - --------- Types Collectionview Cell ---------
// ----------------------------------------------------
class TypesColCell : UICollectionViewCell,ShimmeringViewProtocol {
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var lblTypes: themeLabel!
    @IBOutlet weak var BGView: UIView!
    var shimmeringAnimatedItems: [UIView]{
        [
            BGView
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTypes.textColor = UIColor.appColor(.themeButtonBlue)
    }
}

class TruckCapacityCell : UICollectionViewCell {
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var lblCapacity: themeLabel!
    @IBOutlet weak var btnRemove: themeButton!
    @IBOutlet weak var BGView: UIView!
    var RemoveClick : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func btnRemoveClick(_ sender: themeButton) {
        if let click = RemoveClick {
            click()
        }
        
    }
}

// ----------------------------------------------------
// MARK: - --------- Types TableView Cell ---------
// ----------------------------------------------------
class TypesTblCell : UITableViewCell {
    
    
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var lblTypes: UILabel!
    
    @IBOutlet weak var btnSelectType: UIButton!
    
    @IBAction func btnActionSelectType(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class TruckCapacityType : Codable   {
    var capacity:String?
    var type:Int?
    
    init(Capacity:String,Type:Int) {
        self.capacity = Capacity
        self.type = Type
    }
    
    private enum CodingKeys : String, CodingKey {
        case capacity = "value", type = "id"
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if capacity != nil{
            dictionary["value"] = capacity
        }
        if type != nil{
            dictionary["id"] = type
        }
        
        return dictionary
    }
    
    class func ConvetToDictonary(arrayDataCart : [TruckCapacityType]) -> [[String:Any]] {
        var arrayDataDictionaries : [[String:Any]] = []
        for objDataCart in arrayDataCart {
            print(objDataCart)
            
            arrayDataDictionaries.append(objDataCart.toDictionary());
        }
        return arrayDataDictionaries
    }
    
}
//MARK:- ========= Enum Tab Type ======
enum Tabselect: String {
    case Diesel
    case Electrical
    case Hydrogen
    
}

class TruckDetailVC: BaseViewController, UITextFieldDelegate,UIDocumentPickerDelegate {
    
    
    //    ----------------------------------------------------
    // MARK: - --------- Variables ---------
    let GeneralPicker = GeneralPickerView()
    var truckDetailsViewModel = TruckDetailsViewModel()
    
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
    
    
    var SelectedTextField :SelectedTextFieldForGeneralPicker?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet var viewTabView: UIView!
    @IBOutlet weak var tblTypes: UITableView!
   
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    
    @IBOutlet weak var TextFieldTruckBrand: themeTextfield!
    @IBOutlet weak var TextFieldVehicalPhoto: themeTextfield!
    @IBOutlet weak var TextFieldRegistrationNumber: themeTextfield!
    @IBOutlet weak var TextFieldCapacity: themeTextfield!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var TextFieldCapacityType: themeTextfield!
    @IBOutlet weak var collectionTruckCapacity: UICollectionView!
    
    @IBOutlet weak var BtnAdd: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
   
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonTypeForAddingCapacity = .Add
        registerNIBsAndDelegate()
        tblTypes.reloadData()
        conHeightOfTbl.constant = tblTypes.contentSize.height
        for i in btnSelection{
            if i.tag == 0 {
                i.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
                selectedBtnUIChanges(Selected: true, Btn: i)
            }
            else {
                selectedBtnUIChanges(Selected: false, Btn:i)
            }
        }
        TextFieldVehicalPhoto.delegate = self
        if let flowLayout = collectionImages.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.headerReferenceSize = CGSize(width: collectionImages.frame.width / 3, height: collectionImages.frame.height - 30)
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
        setupDelegateForPickerView()
        setValue()
        TextFieldTruckBrand.delegate = self
        TextFieldCapacityType.delegate = self
    }
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func setupDelegateForPickerView() {
        GeneralPicker.dataSource = self
        GeneralPicker.delegate = self
        
        GeneralPicker.generalPickerDelegate = self
    }
    
   
    
    func registerNIBsAndDelegate(){
       
        collectionImages.delegate = self
        collectionImages.dataSource = self
        let uploadnib = UINib(nibName: UploadVideoAndImagesCell.className, bundle: nil)
      
        collectionImages.register(uploadnib, forCellWithReuseIdentifier: UploadVideoAndImagesCell.className)
        collectionImages.register(uploadnib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UploadVideoAndImagesCell.className)
        let nib = UINib(nibName: collectionPhotos.className, bundle: nil)
        collectionImages.register(nib, forCellWithReuseIdentifier: collectionPhotos.className)
        
       
    }
    
    func setValue() {
        
        TextFieldTruckBrand.text = SingletonClass.sharedInstance.RegisterData.Reg_brand
        
       
        
        TruckCapacityAdded = SingletonClass.sharedInstance.RegisterData.Reg_pallets
      
      
       
       var TempAdditionType : [String] = []
       arrTypes.forEach { element in
           if element.1 {
               TempAdditionType.append("\(element.0.id ?? 0)")
           }
       }
       
       
        
        arrImages = SingletonClass.sharedInstance.RegisterData.Reg_vehicle_images
        

        SingletonClass.sharedInstance.TruckFeatureList?.forEach({ element in
            arrTypes.append((element,false))
        })
        if arrTypes.count != 0 {
            for i in 0...arrTypes.count - 1 {
                if SingletonClass.sharedInstance.RegisterData.Reg_truck_features.contains(where: {$0 == "\(arrTypes[i].0.id ?? 0)"}) {
                    arrTypes[i].1 = true
                } else {
                    arrTypes[i].1  = false
                }

            }
        }
        collectionTruckCapacity.reloadData()
        collectionImages.reloadData()
        ColTypes.reloadData()
        let _ = btnSelection.map{$0.isSelected = false}
        selectedBtnUIChanges(Selected: false, Btn:btnSelection[0])
        selectedBtnUIChanges(Selected: false, Btn:btnSelection[1])
        selectedBtnUIChanges(Selected: false, Btn:btnSelection[2])
        switch SingletonClass.sharedInstance.RegisterData.Reg_fuel_type  {
        
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
    
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
        
    }
    
    func CheckSubTypeOfTruck() -> Bool {
        var CheckSelected = false
        arrTypes.forEach { element in
            if element.1 == true {
                CheckSelected = true
                
            }
        }
       
        return CheckSelected
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       // textField.resignFirstResponder()
        if textField == TextFieldVehicalPhoto {
            
           
            let options = [kUTTypePDF as String, kUTTypeZipArchive  as String, kUTTypePNG as String, kUTTypeJPEG as String, kUTTypeText  as String, kUTTypePlainText as String]
            
            let documentPicker =  UIDocumentPickerViewController(documentTypes: options, in: .import)
            documentPicker.delegate = self
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
        } else if textField == TextFieldTruckBrand {
            SelectedTextField = .TruckBrandList
            TextFieldTruckBrand.inputView = GeneralPicker
            TextFieldTruckBrand.inputAccessoryView = GeneralPicker.toolbar
            
            if let DummyFirst = SingletonClass.sharedInstance.TruckBrandList?.firstIndex(where: {$0.name == TextFieldTruckBrand.text ?? ""}){
                
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
            
        } else if textField == TextFieldCapacityType {
            SelectedTextField = .CapacityType
            TextFieldCapacityType.inputView = GeneralPicker
            TextFieldCapacityType.inputAccessoryView = GeneralPicker.toolbar
            if let DummyFirst = SingletonClass.sharedInstance.PackageList?.firstIndex(where: {$0.name == TextFieldCapacityType.text}){
                GeneralPicker.selectRow(DummyFirst, inComponent: 0, animated: false)
            }
            self.GeneralPicker.reloadAllComponents()
        }
        
        
        
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print(cico)
        print(url)
        
        print(url.lastPathComponent)
        
        print(url.pathExtension)
        
        TextFieldVehicalPhoto.text = url.lastPathComponent
        
        
    }
    
    private func handleFileSelection(inUrl:URL) -> Data {
        var data = Data()
        do {
            // inUrl is the document's URL
            data = try Data(contentsOf: inUrl)
            // Getting file data here
        } catch {
           
        }
        return data
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
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
    
    @IBAction func BtnContinueClick(_ sender: themeButton) {
//        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: IdentifyYourselfVC.storyboardID) as! IdentifyYourselfVC
//        self.navigationController?.pushViewController(controller, animated: true)
        let CheckValidation = Validate()
        if CheckValidation.0 {
          
        
            
             SingletonClass.sharedInstance.RegisterData.Reg_brand = TextFieldTruckBrand.text ?? ""
            SingletonClass.sharedInstance.RegisterData.Reg_pallets = TruckCapacityAdded
           
             
            
            var TempAdditionType : [String] = []
            arrTypes.forEach { element in
                if element.1 {
                    TempAdditionType.append("\(element.0.id ?? 0)")
                }
            }
            SingletonClass.sharedInstance.RegisterData.Reg_fuel_type = tabTypeSelection
            SingletonClass.sharedInstance.RegisterData.Reg_truck_features = TempAdditionType
            SingletonClass.sharedInstance.RegisterData.Reg_vehicle_images = arrImages
           
            UserDefault.SetRegiterData()
            
            UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
            
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 3
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            
           // UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
           // UserDefault.synchronize()
            RegisterMainVC.viewDidLayoutSubviews()
        } else {
            Utilities.ShowAlertOfValidation(OfMessage: CheckValidation.1)
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
    // MARK: - --------- Validation ---------
    // ----------------------------------------------------
    
    
    func Validate() -> (Bool,String) {
        
        let CheckTruckBrand = TextFieldTruckBrand.validatedText(validationType: ValidatorType.Select(field: "truck brand"))
        
    
       // let CheckRegistrationNumber = TextFieldRegistrationNumber.validatedText(validationType: ValidatorType.username(field: "registration number", MaxChar: 8))
        //let CheckVehicalPhoto = TextFieldVehicalPhoto.validatedText(validationType: ValidatorType.Attach(field: "vehical photo"))
        
        if (!CheckTruckBrand.0){
            return (CheckTruckBrand.0,CheckTruckBrand.1)
        } else if TruckCapacityAdded.count == 0 {
            return (false,"Please add atleast one capacity")
        }
//        else if (!CheckRegistrationNumber.0){
//            return (CheckRegistrationNumber.0,CheckRegistrationNumber.1)
//        }

        return (true,"")
        
    }
    
    
   
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    func ImageUploadAPI(arrImages:[UIImage]) {
        
        self.truckDetailsViewModel.TruckDetail = self
        
        self.truckDetailsViewModel.WebServiceImageUpload(images: arrImages)
    }
    
}

//----------------------------------------------------
// MARK: - --------- Tableview Methods ---------
// ----------------------------------------------------
extension TruckDetailVC : UITableViewDataSource , UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTypes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TypesTblCell") as! TypesTblCell
        cell.btnSelectType.isUserInteractionEnabled = false
        cell.lblTypes.text = arrTypes[indexPath.row].0.name
        cell.btnSelectType.isSelected = selectedIndex == indexPath.row ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tblTypes.reloadData()
    }
    
    
    
}
//----------------------------------------------------
// MARK: - --------- Collectionview Methods ---------
// ----------------------------------------------------
extension TruckDetailVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
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
                self.ImageUploadAPI(arrImages: [image])
            }
        }
        
    }
    
    func setImg(cell:collectionPhotos,img : UIImage ){
        cell.imgPhotos.image = img
    }
}
extension TruckDetailVC: GeneralPickerViewDelegate {
    
    func didTapDone() {
        
        if SelectedTextField == .CapacityType {
            let item = SingletonClass.sharedInstance.PackageList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldCapacityType.text = item?.name
            
            self.TextFieldCapacityType.resignFirstResponder()
        } else if SelectedTextField == .TruckBrandList {
            let item = SingletonClass.sharedInstance.TruckBrandList?[GeneralPicker.selectedRow(inComponent: 0)]
            self.TextFieldTruckBrand.text = item?.name
            
            self.TextFieldTruckBrand.resignFirstResponder()
        }
    }
    
    func didTapCancel() {
        //self.endEditing(true)
    }
}
extension TruckDetailVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if SelectedTextField == .CapacityType {
            return SingletonClass.sharedInstance.PackageList?.count ?? 0
        } else if SelectedTextField == .TruckBrandList {
            return SingletonClass.sharedInstance.TruckBrandList?.count ?? 0
        }
        return 0
            
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if SelectedTextField == .CapacityType {
            return SingletonClass.sharedInstance.PackageList?[row].name
        } else if SelectedTextField == .TruckBrandList {
            return SingletonClass.sharedInstance.TruckBrandList?[row].name
        }
        
        
        return ""
        
        
    }
    
}
enum SelectedTextFieldForGeneralPicker {
    case CapacityType
    case TruckBrandList
}
public extension UIView
{
    static func loadFromXib<T>(withOwner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)

        guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
}
enum AddCapacityTypeButtonName {
    case Add
    case Update
}
