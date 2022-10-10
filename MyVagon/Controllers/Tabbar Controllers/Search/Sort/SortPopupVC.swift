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



class SortPopupVC: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var tblSortHeight: NSLayoutConstraint!
    @IBOutlet weak var tblSort: UITableView!
    @IBOutlet weak var lblShortBy: themeLabel!
    @IBOutlet weak var btnReset: themeButton!
    @IBOutlet weak var btnSort: themeButton!
    
    var delegate : HomeSorfDelgate?
    var customTabBarController: CustomTabBarVC?
    var arrSordData : [String] = ["Price (Lowest First)","Price (Highest First)","Total Distance","Rating"]
    var selectedIndex:Int = -1
    var isFromBid = false

    //MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareDate()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
        self.setLocalization()
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
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization(){
        self.lblShortBy.text = "Sort by".localized
        self.btnReset.setTitle("Reset".localized, for: .normal)
        self.btnSort.setTitle("Sort".localized, for: .normal)
    }
    
    func prepareDate(){
        self.setupData()
        self.setupUI()
    }
    
    func setupData(){
        self.arrSordData = isFromBid ? ["Price (Lowest First)","Price (Highest First)"] : ["Price (Lowest First)","Price (Highest First)","Total Distance","Rating"]
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
            Utilities.ShowAlertOfInfo(OfMessage: "Please select any one option")
        }
    }
    
    @IBAction func btnResetClick(_ sender: themeButton) {
        delegate?.onSorfClick(strSort: "")
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Tableview datasource and delegate
extension SortPopupVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSort.dequeueReusableCell(withIdentifier: "SortPopupCell", for: indexPath) as! SortPopupCell
        cell.btnSelected.setImage((selectedIndex == indexPath.row) ? UIImage(named: "ic_radio_selected") : UIImage(named: "ic_radio_unselected"), for: .normal)
        cell.lblName.text = arrSordData[indexPath.row].localized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tblSort.reloadData()
    }
}
