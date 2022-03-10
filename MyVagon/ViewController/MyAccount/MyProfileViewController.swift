//
//  MyProfileViewController.swift
//  MyVagon
//
//  Created by Apple on 17/08/21.
//

import UIKit
import SDWebImage

class MyProfileViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var arrImages : [String] = []
    var arrTypes:[(TruckFeatures,Bool)] = []
    var customTabBarController: CustomTabBarVC?
    var Iseditable = false
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var TextFieldFullName: MyProfileTextField!
    @IBOutlet weak var TextFeildPhoneNumber: MyProfileTextField!
    @IBOutlet weak var TextFeildEmail: MyProfileTextField!
    
    @IBOutlet weak var TextFeildTruckType: MyProfileTextField!
    @IBOutlet weak var TextFeildTruckWeight: MyProfileTextField!
    @IBOutlet weak var TextFeildCargoLoadCapacity: MyProfileTextField!
    @IBOutlet weak var TextfieldTruckPlatNumber: MyProfileTextField!
    @IBOutlet weak var TextfieldTrailerPlatNumber: MyProfileTextField!
    
    @IBOutlet weak var TextFeildTruckBrand: MyProfileTextField!
    @IBOutlet weak var TextFeildCapacity_pallets: MyProfileTextField!
    
    
    @IBOutlet weak var ColTypes: UICollectionView!
    
    @IBOutlet weak var LabelVehicalRunsOn: themeLabel!
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var textFieldLicenseNumber: MyProfileTextField!
    @IBOutlet weak var textFieldLicenseExpiryDate: MyProfileTextField!
    @IBOutlet weak var ImageViewIdentityProofDocument: UIImageView!
    @IBOutlet weak var ImageViewLicense: UIImageView!
    
    @IBOutlet weak var ImageViewProfile: UIImageView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.myProfile ?? 0 == 1 {
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Profile", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.RequestEdit.value], isTranslucent: true, ShowShadow: true)
        } else {
            
            setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "My Profile", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.none.value], isTranslucent: true, ShowShadow: true)
            
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ProfileEdit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEdit), name: NSNotification.Name(rawValue: "ProfileEdit"), object: nil)
        SetValue()
        registerNIBsAndDelegate()
        if SingletonClass.sharedInstance.UserProfileData?.permissions?.myProfile ?? 0 == 1 {
            if Iseditable {
                isProfileEdit(allow: true)
            } else {
                isProfileEdit(allow: false)
            }
        } else {
            isProfileEdit(allow: false)
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    @objc func ProfileEdit(){
        SetValue()
       }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func isProfileEdit(allow:Bool) {
        let arrayOfDisableElement = (TextFieldFullName,TextFeildPhoneNumber,TextFeildEmail,TextFeildTruckType,TextFeildTruckWeight,TextFeildCargoLoadCapacity,TextFeildTruckBrand,TextFeildCapacity_pallets,textFieldLicenseNumber,textFieldLicenseExpiryDate,TextfieldTruckPlatNumber,TextfieldTrailerPlatNumber)
        arrayOfDisableElement.0?.isUserInteractionEnabled = allow
        arrayOfDisableElement.1?.isUserInteractionEnabled = allow
        arrayOfDisableElement.2?.isUserInteractionEnabled = allow
        arrayOfDisableElement.3?.isUserInteractionEnabled = allow
        arrayOfDisableElement.4?.isUserInteractionEnabled = allow
        arrayOfDisableElement.5?.isUserInteractionEnabled = allow
        arrayOfDisableElement.6?.isUserInteractionEnabled = allow
        arrayOfDisableElement.7?.isUserInteractionEnabled = allow
        arrayOfDisableElement.8?.isUserInteractionEnabled = allow
        arrayOfDisableElement.9?.isUserInteractionEnabled = allow
        arrayOfDisableElement.10?.isUserInteractionEnabled = allow
        arrayOfDisableElement.11?.isUserInteractionEnabled = allow

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
    func SetValue() {
        
        let StringURLForProfile = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.profile ?? "")"
        ImageViewProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        ImageViewProfile.sd_setImage(with: URL(string: StringURLForProfile), placeholderImage: UIImage(named: "ic_userIcon"))
        
        
        TextFieldFullName.text = SingletonClass.sharedInstance.UserProfileData?.name
        TextFeildPhoneNumber.text = SingletonClass.sharedInstance.UserProfileData?.mobileNumber
        TextFeildEmail.text = SingletonClass.sharedInstance.UserProfileData?.email
        
        TextFeildTruckType.text = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckType?.name ?? ""),\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckSubCategory?.name ?? "")"
        
        TextFeildTruckWeight.text = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.weight ?? "") \(SingletonClass.sharedInstance.UserProfileData?.vehicle?.weightUnit?.name ?? "")"
        
        TextFeildCargoLoadCapacity.text = "\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.loadCapacity ?? "") \(SingletonClass.sharedInstance.UserProfileData?.vehicle?.loadCapacityUnit?.name ?? "")"
        
        TextfieldTruckPlatNumber.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.registrationNo ?? ""
        TextfieldTrailerPlatNumber.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.trailerRegistrationNo ?? ""
        TextfieldTrailerPlatNumber.isHidden = ((SingletonClass.sharedInstance.UserProfileData?.vehicle?.trailerRegistrationNo ?? "") == "") ? true : false
        
        TextFeildTruckBrand.text = " \(SingletonClass.sharedInstance.UserProfileData?.vehicle?.brands?.name ?? "")"
        
        var palletText : [String] = []
        SingletonClass.sharedInstance.UserProfileData?.vehicle?.vehicleCapacity?.forEach({ element in
            palletText.append("\(element.value ?? "") \(element.packageTypeId?.name ?? "")")
        })
        
        TextFeildCapacity_pallets.text = (palletText.count == 1) ?  palletText[0] :  (palletText.map{String($0)}).joined(separator: ", ")
        
        LabelVehicalRunsOn.text = SingletonClass.sharedInstance.UserProfileData?.vehicle?.fuelType ?? ""
        
        let StringURlForIdentityProof = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.idProof ?? "")"
        ImageViewIdentityProofDocument.sd_imageIndicator = SDWebImageActivityIndicator.gray
        ImageViewIdentityProofDocument.sd_setImage(with: URL(string: StringURlForIdentityProof), placeholderImage: UIImage())
        
        textFieldLicenseNumber.text = SingletonClass.sharedInstance.UserProfileData?.licenceNumber ?? ""
        textFieldLicenseExpiryDate.text = SingletonClass.sharedInstance.UserProfileData?.licenceExpiryDate?.ConvertDateFormat(FromFormat: "yyyy-mm-dd", ToFormat: "dd-mm-yyyy")
        
        let StringURlForLicense = "\(APIEnvironment.TempProfileURL)\(SingletonClass.sharedInstance.UserProfileData?.vehicle?.license ?? "")"
        ImageViewLicense.sd_imageIndicator = SDWebImageActivityIndicator.gray
        ImageViewLicense.sd_setImage(with: URL(string: StringURlForLicense), placeholderImage: UIImage())
        
        
//        TextFeildTruckWeight: MyPro
//        TextFeildCargoLoadCapacity:
//        TextFeildTruckBrand: MyProfif
//
//        TextFeildCapacity_pallets:
//
//        TextFeildPlates: MyProfileT
        
        
        
        SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckFeatures?.forEach({ element in
            arrTypes.append((element,true))
        })
        
        
        arrImages = SingletonClass.sharedInstance.UserProfileData?.vehicle?.images ?? []
        if arrImages.count == 0 {
            collectionImages.superview?.superview?.isHidden = true
        }
        if arrTypes.count == 0 {
            ColTypes.superview?.isHidden = true
        }
        ColTypes.reloadData()
        collectionImages.reloadData()
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
extension MyProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == ColTypes{
            return arrTypes.count
        } else if collectionView == collectionImages {
            return arrImages.count
        }
        return 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == ColTypes{
            return CGSize(width: ((arrTypes[indexPath.row].0.name?.capitalized ?? "").sizeOfString(usingFont: CustomFont.PoppinsMedium.returnFont(14)).width) + 30
                          , height: ColTypes.frame.size.height - 10)
        } else if collectionView == collectionImages {
            return CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
        }
        return CGSize(width: 0.0, height: 0.0)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == ColTypes{
            let cell = ColTypes.dequeueReusableCell(withReuseIdentifier: "TypesColCell", for: indexPath) as! TypesColCell
            cell.lblTypes.text = arrTypes[indexPath.row].0.name
            cell.BGView.layer.cornerRadius = 17
            if arrTypes[indexPath.row].1 {
             
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
        } else if collectionView == collectionImages {
            let cell = collectionImages.dequeueReusableCell(withReuseIdentifier: collectionPhotos.className, for: indexPath)as! collectionPhotos
            cell.btnCancel.tag = indexPath.row
            let strUrl = "\(APIEnvironment.TempProfileURL)\(arrImages[indexPath.row])"
            cell.imgPhotos.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgPhotos.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage())
            cell.btnCancel.addTarget(self, action: #selector(deleteImagesClicked(sender:)), for: .touchUpInside)
            if Iseditable {
                cell.btnCancel.isHidden = false
            } else {
                cell.btnCancel.isHidden = true
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Iseditable {
            if collectionView == ColTypes{
                if arrTypes[indexPath.row].1 {
                    arrTypes[indexPath.row].1 = false
                } else {
                    arrTypes[indexPath.row].1 = true
                }
                
                ColTypes.reloadData()
            } else if collectionView == collectionImages {
             
                let vc : GalaryVC = GalaryVC.instantiate(fromAppStoryboard: .Auth)
                vc.firstTimeSelectedIndex = indexPath.row
                vc.arrImage = self.arrImages
                self.navigationController?.present(vc, animated: true)
            }
        } else {
            if collectionView == collectionImages {
             
                let vc : GalaryVC = GalaryVC.instantiate(fromAppStoryboard: .Auth)
                vc.firstTimeSelectedIndex = indexPath.row
                vc.arrImage = self.arrImages
                self.navigationController?.present(vc, animated: true)
            }
        }
        
    }
    
    @objc func deleteImagesClicked(sender : UIButton){
        if Iseditable {
            arrImages.remove(at: sender.tag)
    //        arrVideoThumbnailImage.remove(at: sender.tag)
            self.collectionImages.reloadData()
        } else {
            
        }

    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//
//
//            return 5
//
//    }
    
   
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
       
    }
    
    func setImg(cell:collectionPhotos,img : UIImage ){
        cell.imgPhotos.image = img
    }
}
