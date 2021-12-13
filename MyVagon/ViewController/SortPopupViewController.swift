//
//  SortPopupViewController.swift
//  MyVagon
//
//  Created by Apple on 26/10/21.
//

import UIKit
class SortPopupCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelected: UIButton!
}
class SortModel : NSObject {
    
        var title : String!
        var isSelect : Bool!
        
         init(Title : String , IsSelect : Bool) {
            self.title = Title
            self.isSelect = IsSelect
        }
}

class SortPopupViewController: BaseViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
   
    
    
    var arrayForSort : [SortModel] = []
    
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblSortHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSort: UITableView!
    
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
    @IBAction func btnDoneClick(_ sender: themeButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnResetClick(_ sender: themeButton) {
        let _ = arrayForSort.map({$0.isSelect = false})
        arrayForSort[0].isSelect = true
        tblSort.reloadData()
       
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
extension SortPopupViewController : UITableViewDelegate,UITableViewDataSource {
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
