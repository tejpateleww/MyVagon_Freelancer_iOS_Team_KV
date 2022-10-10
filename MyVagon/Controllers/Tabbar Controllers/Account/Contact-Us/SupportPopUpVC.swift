//
//  SupportPopUpVC.swift
//  MyVagon
//
//  Created by Tej P on 16/02/22.
//

import UIKit

protocol CloseSettingTabbarDelgate {
    func onCloseTap()
}

class SupportPopUpVC: UIViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var btnCall: themeButton!
    @IBOutlet weak var btnChat: themeButton!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var imgClose: UIImageView!
    @IBOutlet weak var lblMsg: themeLabel!
    
    var delegate : CloseSettingTabbarDelgate?
    var selectChatClosour : (()->())?
    var selectCallClosour : (()->())?

    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
        self.addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom method
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.lblMsg.text = "To better assist you, contact us from one of below options".localized
        self.btnCall.setTitle("Call".localized, for: .normal)
        self.btnChat.setTitle("Chat".localized, for: .normal)
    }
    
    func prepareView(){
        self.setupUI()
    }
    
    func setupUI(){
        self.MainView.layer.cornerRadius = 30
    }
    
    //MARK: - IBAction method
    @IBAction func btnChatAction(_ sender: Any) {
        if let click = self.selectChatClosour {
            click()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCallAction(_ sender: Any) {
        if let click = self.selectCallClosour {
            click()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        if(delegate != nil){
            delegate?.onCloseTap()
        }
    }
}
