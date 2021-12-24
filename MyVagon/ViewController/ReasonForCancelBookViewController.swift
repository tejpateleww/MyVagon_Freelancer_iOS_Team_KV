//
//  ReasonForCancelBookViewController.swift
//  MyVagon
//
//  Created by Apple on 21/12/21.
//

import UIKit

class ReasonForCancelBookViewController:  BaseViewController {
    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   
    var remainingsMinute : Int?
    
    var arrayForSort : [SortModel] = []
    
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblSortHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSort: UITableView!
    @IBOutlet weak var lblRemainingMinutes: themeLabel!
    @IBOutlet weak var btnDecline: themeButton!

    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tblSort.observationInfo != nil {
            self.tblSort.removeObserver(self, forKeyPath: "contentSize")
        }
        self.tblSort.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.lblRemainingMinutes.text = "17 minutes remaining"// "\(remainingsMinute ?? 0) minutes remaining"
            
            self.btnDecline.setTitle("Decline", for: .normal)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
      
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblSortHeight.constant = newsize.height
                
            }
        }
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func btnDecline(_ sender: themeButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancel(_ sender: themeButton) {
        self.dismiss(animated: true, completion: nil)
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
extension ReasonForCancelBookViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayForSort.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSort.dequeueReusableCell(withIdentifier: "SortPopupCell", for: indexPath) as! SortPopupCell
        cell.btnSelected.setImage(UIImage(named: "ic_radio_unselected"), for: .normal)
        cell.btnSelected.setImage((arrayForSort[indexPath.row].isSelect == true) ? UIImage(named: "ic_radio_selected") : UIImage(named: "ic_radio_unselected"), for: .normal)
        cell.btnSelected.setTitle("", for: .normal)
        cell.lblName.text = arrayForSort[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let _ = arrayForSort.map({$0.isSelect = false})
        arrayForSort[indexPath.row].isSelect = true
        tblSort.reloadData()
    }
    
    
}
