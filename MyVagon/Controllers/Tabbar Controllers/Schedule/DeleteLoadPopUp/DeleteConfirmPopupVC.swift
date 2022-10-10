//
//  ConfirmationPopUPVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 05/04/22.
//

import UIKit

class DeleteConfirmPopupVC: UIViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var lblTitle: themeLabel!
    @IBOutlet weak var btnYes: themeButton!
    @IBOutlet weak var btnNo: themeButton!
    
    var btnPositiveAction : (() -> ())?
    var btnNagativeAction : (() -> ())?
    var titleText = ""
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.addObserver()
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
        self.btnNo.setTitle("NO".localized, for: .normal)
        self.btnYes.setTitle("YES".localized, for: .normal)
    }
    
    func setupData(){
        self.lblTitle.text = titleText
    }
    
    //MARK: - IBAction method
    @IBAction func btnPositiveClick(_ sender: Any) {
        if let click = self.btnPositiveAction{
            click()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNagativeClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
