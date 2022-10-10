//
//  DeleteAccountPopUpVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/06/22.
//

import UIKit

class DeleteAccountPopUpVC: UIViewController {
    //MARK: - Propertise
    @IBOutlet weak var btnCancel: themeButton!
    @IBOutlet weak var btnDelete: themeButton!
    @IBOutlet weak var lblTitle: themeLabel!
    @IBOutlet weak var lblDeleteInfo: themeLabel!
    
    let deleteUserViewModel = DeleteUserViewModel()
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setLocalization()
    }
    
    //MARK: - Custom method
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        let msg = "- \("delete_msg_first".localized) \("delete_msg_last".localized)"
        let attrStri = NSMutableAttributedString.init(string: msg)
        let boldRange = NSString(string: msg).range(of: "delete_msg_first".localized, options: String.CompareOptions.caseInsensitive)
        let normalRange = NSString(string: msg).range(of: "delete_msg_last".localized, options: String.CompareOptions.caseInsensitive)
        attrStri.addAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16) as Any], range: boldRange)
        attrStri.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.6) as Any], range: normalRange)
        self.lblTitle.text = "Delete_Title".localized
        self.lblDeleteInfo.attributedText = attrStri
        self.btnCancel.setTitle("Cancel".localized, for: .normal)
        self.btnDelete.setTitle("Delete".localized, for: .normal)
    }
    
    //MARK: - IBAction method
    @IBAction func btnCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDeleteClick(_ sender: Any) {
        Utilities.showAlertWithTitleFromVC(vc: self, title: AppName, message: "Are you sure want to Delete your account?".localized, buttons: ["NO".localized, "YES".localized]) { index in
            if index == 1 {
                self.dismiss(animated: true, completion: {
                    print("Call API")
                })
            }
        }
    }
}

//MARK: - web service method
extension DeleteAccountPopUpVC{
    func callWebService(){
        let reqModel = DeleteUserReqModel()
        deleteUserViewModel.callWebServiceToDeleteUser(reqModel: reqModel)
    }
}
