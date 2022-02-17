//
//  SupportPopUpVC.swift
//  MyVagon
//
//  Created by Tej P on 16/02/22.
//

import UIKit

class SupportPopUpVC: UIViewController {
    
    @IBOutlet weak var btnCall: themeButton!
    @IBOutlet weak var btnChat: themeButton!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var imgClose: UIImageView!
    
    var selectChatClosour : (()->())?
    var selectCallClosour : (()->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    func prepareView(){
        self.setupUI()
    }
    
    func setupUI(){
        self.MainView.layer.cornerRadius = 30
    }
    
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
    }
    
}
