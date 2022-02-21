//
//  MyEarningVC.swift
//  MyVagon
//
//  Created by Tej P on 28/01/22.
//

import UIKit

class MyEarningVC: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tblEarning: UITableView!
    
    var earningListViewModel = EarningListViewModel()
    var arrData : [EarningResData] = []
    var strId : String = ""
    
    //shimmer
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblEarning.isUserInteractionEnabled = !isLoading
            self.tblEarning.reloadData()
        }
    }
    
    // Pull to refresh
    let refreshControl = UIRefreshControl()
    
    // MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    // MARK: - Custome methods
    func prepareView(){
        self.registerNib()
        self.addRefreshControl()
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Statistics", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        
        self.tblEarning.delegate = self
        self.tblEarning.dataSource = self
        self.tblEarning.separatorStyle = .none
        self.tblEarning.showsHorizontalScrollIndicator = false
        self.tblEarning.showsVerticalScrollIndicator = false
    }
    
    func setupData(){
        self.callEarningListAPI()
    }
    
    func registerNib(){
        let nib = UINib(nibName: MyEarningCell.className, bundle: nil)
        self.tblEarning.register(nib, forCellReuseIdentifier: MyEarningCell.className)
        let nib2 = UINib(nibName: EarningShimmerCell.className, bundle: nil)
        self.tblEarning.register(nib2, forCellReuseIdentifier: EarningShimmerCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblEarning.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblEarning.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.arrData = []
        self.isTblReload = false
        self.isLoading = true
        self.callEarningListAPI()
    }
    
    
}


//MARK: - UITableView Delegate and Data Sourse Methods
extension MyEarningVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrData.count > 0 {
            return self.arrData.count
        } else {
            return (!self.isTblReload) ? 10 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblEarning.dequeueReusableCell(withIdentifier: EarningShimmerCell.className) as! EarningShimmerCell
        cell.selectionStyle = .none
        if(!self.isTblReload){
            return cell
        }else{
            if(self.arrData.count > 0){
                
                let cell = tblEarning.dequeueReusableCell(withIdentifier: MyEarningCell.className) as! MyEarningCell
                
                cell.selectionStyle = .none
                
                cell.lblCompanyNAme.text = self.arrData[indexPath.row].shipperDetails?.companyName
                cell.lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (self.arrData[indexPath.row].amount ?? "" ) : ""
                cell.lblTripID.text = "#\(self.arrData[indexPath.row].id ?? 0 )"
                cell.lblTon.text =   "\(self.arrData[indexPath.row].trucks?.locations?[0].products?[0].weight ?? "" ) Ton, \(self.arrData[indexPath.row].distance ?? "") miles"
                cell.lblDeadhead.text = "\(self.arrData[indexPath.row].trucks?.locations?[0].deadhead ?? "") mile Deadhead : \(self.arrData[indexPath.row].trucks?.truckTypeCategory?[0].name ?? "")"
                cell.arrLocations = self.arrData[indexPath.row].trucks?.locations ?? []
                
                cell.tblEarningLocation.reloadData()
                cell.tblEarningLocation.layoutIfNeeded()
                cell.tblEarningLocation.layoutSubviews()
                
                return cell
            }else{
                let NoDatacell = self.tblEarning.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.lblNoDataTitle.text = "No Loads Found"
                return NoDatacell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(!isTblReload){
            return UITableView.automaticDimension
        }else{
            if self.arrData.count != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
}

//MARK: - API calls
extension MyEarningVC{
    func callEarningListAPI() {
        self.earningListViewModel.myEarningVC = self
        
        let reqModel = EarningReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.statisticType = self.strId
        self.earningListViewModel.WebServiceEarningList(ReqModel: reqModel)
    }
}


