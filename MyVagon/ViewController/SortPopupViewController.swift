//
//  SortPopupViewController.swift
//  MyVagon
//
//  Created by Apple on 26/10/21.
//

import UIKit

protocol HomeSorfDelgate {
    func onSorfClick(strSort:String)
}

class SortPopupCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSelected: UIButton!
}

class SortPopupViewController: BaseViewController {

    @IBOutlet weak var tblSortHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSort: UITableView!
    
    var delegate : HomeSorfDelgate?
    var customTabBarController: CustomTabBarVC?
    var arrSordData : [String] = ["Deadheading","Price (Lowest First)","Price (Highest First)","Total Distance","Rating"]
    var selectedIndex:Int = -1

    //MARK: - Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareDate()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
      
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblSortHeight.constant = newsize.height
                
            }
        }
    }
    
    //MARK: - Custom Methods
    func prepareDate(){
        self.setupData()
        self.setupUI()
    }
    
    func setupData(){
        self.tblSort.reloadData()
    }
    
    func setupUI(){
        if self.tblSort.observationInfo != nil {
            self.tblSort.removeObserver(self, forKeyPath: "contentSize")
        }
        self.tblSort.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
    }

    //MARK: - IBAction Methods
    @IBAction func btnDoneClick(_ sender: themeButton) {
        if(selectedIndex >= 0){
            delegate?.onSorfClick(strSort: self.arrSordData[selectedIndex])
            self.dismiss(animated: true, completion: nil)
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: "Please select option.")
        }
    }
    
    @IBAction func btnResetClick(_ sender: themeButton) {
        self.selectedIndex = -1
        self.tblSort.reloadData()
    }

}

extension SortPopupViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSort.dequeueReusableCell(withIdentifier: "SortPopupCell", for: indexPath) as! SortPopupCell
        
        cell.btnSelected.setImage((selectedIndex == indexPath.row) ? UIImage(named: "ic_radio_selected") : UIImage(named: "ic_radio_unselected"), for: .normal)
        cell.lblName.text = arrSordData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.tblSort.reloadData()
    }
    
    
}
