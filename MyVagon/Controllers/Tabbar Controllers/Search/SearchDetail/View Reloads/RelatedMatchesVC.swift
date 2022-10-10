//
//  RelatedMatchesVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/03/22.
//

import UIKit

class RelatedMatchesVC: BaseViewController {

    // MARK: - Properties
    @IBOutlet weak var tblRelatedData: UITableView!
    
    var driverId = ""
    var bookingId = ""
    var viewModel = RelatedMatchViewModel()
    var arrRelatedData : [SearchLoadsDatum] = []
    let refreshControl = UIRefreshControl()
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblRelatedData.isUserInteractionEnabled = !self.isLoading
            self.tblRelatedData.reloadData()
        }
    }
    
    // MARK: - Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    //MARK: - Custom methods
    func setupUI(){
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Related_Matches".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.reloadSearchData()
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
        let nibSearchDataCell = UINib(nibName: SearchDataCell.className, bundle: nil)
        self.tblRelatedData.register(nibSearchDataCell, forCellReuseIdentifier: SearchDataCell.className)
        let nibEarningShimmerCell = UINib(nibName: EarningShimmerCell.className, bundle: nil)
        self.tblRelatedData.register(nibEarningShimmerCell, forCellReuseIdentifier: EarningShimmerCell.className)
        let nibNoDataTableViewCell = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblRelatedData.register(nibNoDataTableViewCell, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
}

//MARK: - UITableView Delegate and Data Source Methods
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
                    cell.setData(data: arrRelatedData[indexPath.row])
                    cell.tblHeight = { (heightTBl) in
                        self.tblRelatedData.layoutIfNeeded()
                        self.tblRelatedData.layoutSubviews()
                    }
                    cell.btnMainTapCousure = {
                        self.goToDetailScreen(index: indexPath)
                    }
                    return cell
                }else{
                    let NoDatacell = self.tblRelatedData.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                    NoDatacell.lblNoDataTitle.text = "No Loads Found".localized
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
        self.goToDetailScreen(index: indexPath)
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
    
    func goToDetailScreen(index : IndexPath){
        
        if !self.isLoading {
            if arrRelatedData.count > 0 {
                let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: SearchDetailVC.storyboardID) as! SearchDetailVC
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
        self.viewModel.relatedMatchesVC = self
        self.viewModel.callWebServiceForRelatedMatchList(reqModal: reqModel)
    }
}
