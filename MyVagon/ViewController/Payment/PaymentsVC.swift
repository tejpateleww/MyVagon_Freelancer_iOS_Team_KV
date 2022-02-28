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
    @IBOutlet weak var redioBtnBoth: UIButton!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var imgCash: UIImageView!
    @IBOutlet weak var imgBank: UIImageView!
    @IBOutlet weak var imgBoth: UIImageView!
    
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
        self.selecCash()
    }
    
    func selecCash() {
        self.redioBtnCash.isSelected = true
        self.redioBtnBank.isSelected = false
        self.redioBtnBoth.isSelected = false
        self.setView(view: detailStackView, hidden: true)
        self.setupImage()
    }
    
    func selecBank() {
        self.redioBtnCash.isSelected = false
        self.redioBtnBank.isSelected = true
        self.redioBtnBoth.isSelected = false
        self.setView(view: detailStackView, hidden: false)
        self.setupImage()
    }
    
    func selecBoth() {
        self.redioBtnCash.isSelected = false
        self.redioBtnBank.isSelected = false
        self.redioBtnBoth.isSelected = true
        self.setView(view: detailStackView, hidden: false)
        self.setupImage()
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.3, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    func viewSlideInFromTopToBottom(view: UIView) -> Void {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.layer.add(transition, forKey: kCATransition)
    }
    
    func setupImage() {
        if(self.redioBtnCash.isSelected){
            self.imgCash.image = UIImage(named: "ic_radio_selected")
        }else{
            self.imgCash.image = UIImage(named: "ic_radio_unselected")
        }
        
        if(self.redioBtnBank.isSelected){
            self.imgBank.image = UIImage(named: "ic_radio_selected")
        }else{
            self.imgBank.image = UIImage(named: "ic_radio_unselected")
        }
        
        if(self.redioBtnBoth.isSelected){
            self.imgBoth.image = UIImage(named: "ic_radio_selected")
        }else{
            self.imgBoth.image = UIImage(named: "ic_radio_unselected")
        }
    }
     
    // MARK: - UIButton action methods
    
    @IBAction func btnCashAction(_ sender: Any) {
        self.selecCash()
    }
    
    @IBAction func btnBnakAction(_ sender: Any) {
        self.selecBank()
    }
    
    @IBAction func btnBothAction(_ sender: Any) {
        self.selecBoth()
    }
    
    
}
