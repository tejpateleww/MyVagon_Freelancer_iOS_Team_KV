//
//  MyEarningVC.swift
//  MyVagon
//
//  Created by Tej P on 28/01/22.
//

import UIKit

class MyEarningVC: BaseViewController {
    
    @IBOutlet weak var tblEarning: UITableView!
    
    var earningListViewModel = EarningListViewModel()
    var arrData : [Earning] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    

    func prepareView(){
        self.registerNib()
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Statistics", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        self.tblEarning.delegate = self
        self.tblEarning.dataSource = self
        self.tblEarning.separatorStyle = .none
    }
    
    func setupData(){
        self.callEarningListAPI()
        self.tblEarning.reloadData()
    }
    
    func registerNib(){
        let nib = UINib(nibName: MyEarningCell.className, bundle: nil)
        self.tblEarning.register(nib, forCellReuseIdentifier: MyEarningCell.className)
    }
    

}


//MARK: - UITableView Delegate and Data Sourse Methods
extension MyEarningVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblEarning.dequeueReusableCell(withIdentifier: MyEarningCell.className) as! MyEarningCell
        
        cell.lblCompanyNAme.text = self.arrData[indexPath.row].bookingData?.shipperDetails?.companyName ?? ""
        cell.lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (self.arrData[indexPath.row].bookingData?.amount ?? "") : ""
        cell.lblTripID.text = "\(self.arrData[indexPath.row].bookingId ?? 0)"
        cell.lblTon.text =   "\(self.arrData[indexPath.row].bookingData?.trucks?.locations?[0].products?[0].weight ?? "") Ton, \(self.arrData[indexPath.row].bookingData?.distance ?? "0") miles"
        cell.lblDeadhead.text = "\(self.arrData[indexPath.row].bookingData?.trucks?.locations?[0].deadhead ?? "0") mile Deadhead : \(self.arrData[indexPath.row].bookingData?.trucks?.truckTypeCategory?[0].name ?? "0")"
        
        cell.arrLocations = self.arrData[indexPath.row].bookingData?.trucks?.locations ?? []
        
        cell.tblHeight = { (heightTBl) in
            self.tblEarning.layoutIfNeeded()
            self.tblEarning.layoutSubviews()
        }
        
        cell.tblEarningLocation.reloadData()
        cell.tblEarningLocation.layoutIfNeeded()
        cell.tblEarningLocation.layoutSubviews()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension MyEarningVC{
    func callEarningListAPI() {
        self.earningListViewModel.myEarningVC = self
        
        let reqModel = EarningReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        self.earningListViewModel.WebServiceEarningList(ReqModel: reqModel)
    }
}
