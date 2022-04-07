//
//  RelatedMatchesVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/03/22.
//

import UIKit

class RelatedMatchesVC: BaseViewController {

    @IBOutlet weak var tblRelatedData: UITableView!
    
    var driverId = ""
    var bookingId = ""
    var relodeMatchViewModel = RelatedMatchViewModel()
    var arrRelatedData : [SearchLoadsDatum] = []
    let refreshControl = UIRefreshControl()
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblRelatedData.isUserInteractionEnabled = !self.isLoading
            self.tblRelatedData.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    //MARK: - Custom methods
    func setupUI(){
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Related Matches", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
    }
    
    func setupData(){
        self.tblRelatedData.delegate = self
        self.tblRelatedData.dataSource = self
        self.tblRelatedData.separatorStyle = .none
        self.tblRelatedData.showsHorizontalScrollIndicator = false
        self.tblRelatedData.showsVerticalScrollIndicator = false
        self.registerNib()
        self.callWebService()
        self.addRefreshControl()
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblRelatedData.addSubview(self.refreshControl)
    }
    
    func reloadSearchData(){
        self.arrRelatedData = []
        self.isTblReload = false
        self.isLoading = true
        self.callWebService()
    }
    
    func registerNib(){
        let nib = UINib(nibName: SearchDataCell.className, bundle: nil)
        self.tblRelatedData.register(nib, forCellReuseIdentifier: SearchDataCell.className)
        let nib2 = UINib(nibName: EarningShimmerCell.className, bundle: nil)
        self.tblRelatedData.register(nib2, forCellReuseIdentifier: EarningShimmerCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblRelatedData.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadSearchData()
    }
    
}
//MARK: - UITableView Delegate and Data Sourse Methods
extension RelatedMatchesVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrRelatedData.count  > 0 {
                return arrRelatedData.count
            } else {
                return (!self.isTblReload) ? 10 : 1
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tblRelatedData.dequeueReusableCell(withIdentifier: EarningShimmerCell.className) as! EarningShimmerCell
        cell.selectionStyle = .none
        if(!self.isTblReload){
            return cell
        }else{
                if(self.arrRelatedData.count > 0){
                    let cell = self.tblRelatedData.dequeueReusableCell(withIdentifier: SearchDataCell.className) as! SearchDataCell
                    cell.selectionStyle = .none
                    
                    cell.lblCompanyName.text = arrRelatedData[indexPath.row].shipperDetails?.companyName ?? ""
                    cell.lblAmount.text = (SingletonClass.sharedInstance.UserProfileData?.permissions?.viewPrice ?? 0 == 1) ? Currency + (arrRelatedData[indexPath.row].amount ?? "" ) : ""
                    cell.lblLoadId.text = "#\(arrRelatedData[indexPath.row].id ?? 0)"
                    cell.lblTonMiles.text =   "\(arrRelatedData[indexPath.row].totalWeight ?? ""), \(arrRelatedData[indexPath.row].distance ?? "") Km"
                    let DeadheadValue = (arrRelatedData[indexPath.row].trucks?.locations?.first?.deadhead ?? "" == "0") ? arrRelatedData[indexPath.row].trucks?.truckType?.name ?? "" : "\(arrRelatedData[indexPath.row].trucks?.locations?.first?.deadhead ?? "") : \(arrRelatedData[indexPath.row].trucks?.truckType?.name ?? "")"
                    cell.lblDeadhead.text = DeadheadValue
                    
                    if (self.arrRelatedData[indexPath.row].isBid ?? 0) == 1 {
                        cell.lblStatus.text = bidStatus.BidNow.Name
                        cell.vWStatus.backgroundColor = #colorLiteral(red: 0.02068837173, green: 0.6137695909, blue: 0.09668994695, alpha: 1)
                    } else {
                        cell.lblStatus.text = bidStatus.BookNow.Name
                        cell.vWStatus.backgroundColor = #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)
                    }
                    
                    cell.arrLocations = arrRelatedData[indexPath.row].trucks?.locations ?? []
                    cell.tblHeight = { (heightTBl) in
                        self.tblRelatedData.layoutIfNeeded()
                        self.tblRelatedData.layoutSubviews()
                    }
                    
                    cell.btnMainTapCousure = {
                        self.goToDeatilScreen(index: indexPath)
                    }
                    
                    cell.tblSearchLocation.reloadData()
                    cell.tblSearchLocation.layoutIfNeeded()
                    cell.tblSearchLocation.layoutSubviews()
                    return cell
                }else{
                    let NoDatacell = self.tblRelatedData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    NoDatacell.lblNoDataTitle.text = "No Loads Found"
                    return NoDatacell
                }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            cell.setTemplateWithSubviews(self.isLoading, animate: true, viewBackgroundColor: .systemBackground)
        } else {
            cell.setTemplateWithSubviews(self.isLoading, animate: true, viewBackgroundColor: UIColor.lightGray.withAlphaComponent(0.3))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.goToDeatilScreen(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(!isTblReload){
            return UITableView.automaticDimension
        }else{
            if arrRelatedData.count > 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
    func goToDeatilScreen(index : IndexPath){
        
        if !self.isLoading {
            if arrRelatedData.count > 0 {
                let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: LoadDetailsVC.storyboardID) as! LoadDetailsVC
                controller.hidesBottomBarWhenPushed = true
                controller.isFromRelated = true
                controller.LoadDetails = arrRelatedData[index.row]
                UIApplication.topViewController()?.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
}



// Web service
extension RelatedMatchesVC{
    func callWebService(){
        let reqModel = RelatedMatchReqModel()
        reqModel.booking_id = self.bookingId
        reqModel.driver_id = self.driverId
        self.relodeMatchViewModel.relatedMatchesVC = self
        self.relodeMatchViewModel.callWebServiceForRelatedMatchList(reqModal: reqModel)
    }
}
