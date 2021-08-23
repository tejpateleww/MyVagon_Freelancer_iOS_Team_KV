//
//  SearchOptionViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit

class SearchOptionViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    @IBOutlet weak var LblPickupLocation: UILabel!
    @IBOutlet weak var LblDropOffLocation: UILabel!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Search Options", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        
        SetValue()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        LblPickupLocation.attributedText = GetAttributedString(Location: "23, Alt crown Plaza", selectedType: "Short Haul")
        LblDropOffLocation.attributedText = GetAttributedString(Location: "23, Alt crown Plaza", selectedType: "Short Haul")
    }
    
    func GetAttributedString(Location:String,selectedType:String) -> NSMutableAttributedString {
        let text = "\(Location) | \(selectedType)"

        let rangeLocation = (text as NSString).range(of: Location)
        let rangePipe = (text as NSString).range(of: " | ")
        let rangeSelectedtype = (text as NSString).range(of: selectedType)

        let LocationAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#9B51E0"), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(14)]
        
        let PipeAttribute = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1F1F41").withAlphaComponent(0.2), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(14)]
        
        let yourOtherAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1F1F41"), NSAttributedString.Key.font: CustomFont.PoppinsRegular.returnFont(14)]
        
        
         let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttributes(LocationAttribute, range: rangeLocation)
        
        attributedString.addAttributes(PipeAttribute, range: rangePipe)
        
        attributedString.addAttributes(yourOtherAttributes, range: rangeSelectedtype)
        
        return attributedString
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSearchLoadsAction(_ sender: themeButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func BtnSelectDateAction(_ sender: themeButton) {
        
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterPickupDatePopupViewController.storyboardID) as! FilterPickupDatePopupViewController
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func BtnPickupLocationAction(_ sender: themeButton) {
        
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
        controller.isForPickUp = true
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func BtnDropOffLocationAction(_ sender: themeButton) {
        let controller = AppStoryboard.FilterPickup.instance.instantiateViewController(withIdentifier: FilterDropOffViewController.storyboardID) as! FilterDropOffViewController
               controller.modalPresentationStyle = .overCurrentContext
               controller.modalTransitionStyle = .crossDissolve
               self.present(controller, animated: true, completion: nil)
        
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
