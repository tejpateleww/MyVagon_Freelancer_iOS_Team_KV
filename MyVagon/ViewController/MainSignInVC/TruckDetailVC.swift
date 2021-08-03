//
//  TruckDetailVC.swift
//  MyVagon
//
//  Created by Admin on 27/07/21.
//

import UIKit
import MobileCoreServices
// ----------------------------------------------------
// MARK: - --------- Types Collectionview Cell ---------
// ----------------------------------------------------
class TypesColCell : UICollectionViewCell {
    
    //MARK:- ===== Outlets ======
    @IBOutlet weak var lblTypes: themeLabel!
    @IBOutlet weak var BGView: UIView!
    
   // @IBOutlet weak var btnSelectType: UIButton!
    
//    @IBAction func btnActionSelectType(_ sender: UIButton) {
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTypes.textColor = UIColor.appColor(.themeButtonBlue)
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


//MARK:- ========= Enum Tab Type ======
enum Tabselect: Int {
    case Diesel
    case Electrical
    case Hydrogen
    
}

class TruckDetailVC: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate,UIDocumentPickerDelegate {
    
    
    //    ----------------------------------------------------
    // MARK: - --------- Variables ---------
    
    var tabTypeSelection = Tabselect(rawValue: 0)
    
    var arrTypes:[(String,Bool)] = [("Curtainsde",false),("Refrigerated (With Cooling)",false),("Refrigerated (Without Cooling)",false),("Flatbed Trailer",false),("Platform",false),("Canvas",false),("Tilting Trailer",false),("Container",false)]
    var selectedIndex = NSNotFound
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet var btnLeadingConstaintOfAnimationView: NSLayoutConstraint!
    @IBOutlet var btnSelection: [UIButton]!
    @IBOutlet var viewTabView: UIView!
    @IBOutlet weak var tblTypes: UITableView!
    @IBOutlet weak var ColTypes: UICollectionView!
    @IBOutlet weak var conHeightOfTbl: NSLayoutConstraint!
    
    @IBOutlet weak var TextFieldTruckBrand: themeTextfield!
    @IBOutlet weak var TextFieldVehicalPhoto: themeTextfield!
    @IBOutlet weak var TextFieldRegistrationNumber: themeTextfield!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        
    }
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    func SetValue() {
        
    }
    func selectedBtnUIChanges(Selected : Bool , Btn : UIButton) {
        Btn.titleLabel?.font = CustomFont.PoppinsMedium.returnFont(16)
        Btn.setTitleColor(Selected == true ? UIColor(hexString: "9B51E0") : UIColor.appColor(.themeLightGrayText), for: .normal)
        
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnContinueClick(_ sender: themeButton) {
//        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: IdentifyYourselfVC.storyboardID) as! IdentifyYourselfVC
//        self.navigationController?.pushViewController(controller, animated: true)
        let CheckValidation = Validate()
        if CheckValidation.0 {
            
            let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
            let x = self.view.frame.size.width * 3
            RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            
            UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
            UserDefault.synchronize()
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
            self.tabTypeSelection = .Diesel
            
        }
        else  if(sender.tag == 1)
        {
            self.tabTypeSelection = .Electrical
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        else  if(sender.tag == 2)
        {
            self.tabTypeSelection = .Hydrogen
            selectedBtnUIChanges(Selected: true, Btn: sender)
        }
        
        
        self.btnLeadingConstaintOfAnimationView.constant = sender.superview?.frame.origin.x ?? 0.0
        UIView.animate(withDuration: 0.3) {
            self.viewTabView.layoutIfNeeded()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((arrTypes[indexPath.row].0.capitalized).sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                      , height: ColTypes.frame.size.height - 10)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if arrTypes[indexPath.row].1 {
            arrTypes[indexPath.row].1 = false
        } else {
            arrTypes[indexPath.row].1 = true
        }
        
        ColTypes.reloadData()
        
        
        
    }
    
    func Validate() -> (Bool,String) {
        
        
        let CheckTruckBrand = TextFieldTruckBrand.validatedText(validationType: ValidatorType.Select(field: "truck brand"))
        let CheckRegistrationNumber = TextFieldRegistrationNumber.validatedText(validationType: ValidatorType.requiredField(field: "registration number"))
        let CheckVehicalPhoto = TextFieldVehicalPhoto.validatedText(validationType: ValidatorType.Attach(field: "vehical photo"))
        
        if (!CheckTruckBrand.0){
            return (CheckTruckBrand.0,CheckTruckBrand.1)
        } else if !CheckSubTypeOfTruck() {
            return (false,"Please select other types")
        } else if (!CheckRegistrationNumber.0){
            return (CheckRegistrationNumber.0,CheckRegistrationNumber.1)
        }else if (!CheckVehicalPhoto.0){
            return (CheckVehicalPhoto.0,CheckVehicalPhoto.1)
        }
        return (true,"")
        
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
        textField.resignFirstResponder()
        if textField == TextFieldVehicalPhoto {
            
           
            let options = [kUTTypePDF as String, kUTTypeZipArchive  as String, kUTTypePNG as String, kUTTypeJPEG as String, kUTTypeText  as String, kUTTypePlainText as String]
            
            let documentPicker =  UIDocumentPickerViewController(documentTypes: options, in: .import)
            documentPicker.delegate = self
            documentPicker.delegate = self
            self.present(documentPicker, animated: true, completion: nil)
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
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
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
        cell.lblTypes.text = arrTypes[indexPath.row].0
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
