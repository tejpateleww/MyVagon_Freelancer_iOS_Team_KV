//
//  ConfirmationPopUPVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 05/04/22.
//

import UIKit

class ConfirmationPopUPVC: UIViewController {

    @IBOutlet weak var lblTitle: themeLabel!
    @IBOutlet weak var btnYes: themeButton!
    @IBOutlet weak var btnNo: themeButton!
    var btnPositiveAction : (() -> ())?
    var btnNagativeAction : (() -> ())?
    var titleText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        
    }
    
    func setupData(){
        self.lblTitle.text = titleText
    }
    
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
