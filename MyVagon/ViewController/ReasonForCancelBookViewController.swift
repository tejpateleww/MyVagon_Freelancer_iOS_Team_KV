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
    var arrSordData = SingletonClass.sharedInstance.cancellationReasons ?? []
    var selectedIndex:Int = -1
    var customTabBarController: CustomTabBarVC?
    var cancelBook = CancelBookRequestViewModel()
    var booking_id = ""
    var shipper_id = ""
    var booking_request_id = ""
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
        self.lblRemainingMinutes.text = "\(remainingsMinute ?? 0) minutes remaining"// "\(remainingsMinute ?? 0) minutes remaining"
        
        self.btnDecline.setTitle("Decline", for: .normal)
        self.tblSort.reloadData()
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
        // call api for dicline
        if selectedIndex >= 0{
            self.callWebService()
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: "Please select reason")
        }
//        self.dismiss(animated: true, completion: nil)
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
        return arrSordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSort.dequeueReusableCell(withIdentifier: "SortPopupCell", for: indexPath) as! SortPopupCell
        
        cell.btnSelected.setImage((selectedIndex == indexPath.row) ? UIImage(named: "ic_radio_selected") : UIImage(named: "ic_radio_unselected"), for: .normal)
        cell.lblName.text = arrSordData[indexPath.row].reason
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.tblSort.reloadData()
    }
}
//MARK: -  web service
extension ReasonForCancelBookViewController{
    
    func callWebService(){
       let requestModel = CancelBookRequestReqModel()
        requestModel.booking_id = self.booking_id
        requestModel.shipper_id = self.shipper_id
        requestModel.booking_request_id = self.booking_request_id
        requestModel.reason = "\(arrSordData[selectedIndex].id ?? 0)"
        requestModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        cancelBook.reasoneVC = self
        cancelBook.callwebServiceForDeclineBook(req: requestModel)
    }
}
