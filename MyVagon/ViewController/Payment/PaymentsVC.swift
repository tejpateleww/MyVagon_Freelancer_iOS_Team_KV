//
//  Payments.swift
//  MyVagon
//
//  Created by Dhanajay  on 21/02/22.
//

import UIKit

class PaymentsVC: BaseViewController {

    // MARK: - Properties
    @IBOutlet weak var redioBtnCash: UIButton!
    @IBOutlet weak var redioBtnBank: UIButton!
    @IBOutlet weak var detailStackView: UIStackView!
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    // MARK: - Custome methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Payments", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.redioBtnBank.setTitle("", for: .normal)
        self.redioBtnCash.setTitle("", for: .normal)
        self.detailStackView.isHidden = true
    }
    
    func setupData(){
        
    }
     
    // MARK: - UIButton action methods
    @IBAction func redioBtnClicked(_ sender: UIButton) {
        view.endEditing(true)
        self.redioBtnCash.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        self.redioBtnBank.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        sender.setImage(UIImage(named: "ic_radio_selected"), for: .normal)
        if sender == redioBtnBank{
            self.detailStackView.isHidden = false
        }else{
            self.detailStackView.isHidden = true
        }
    }
    
}
