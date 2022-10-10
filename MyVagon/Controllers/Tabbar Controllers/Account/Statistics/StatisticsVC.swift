//
//  StatisticsOneVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class StatisticsVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tblStatistics: UITableView!
    var statisticsViewModel = StatisticsViewModel()
    var arrData : [StatisticListData] = []
    let refreshControl = UIRefreshControl()
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblStatistics.isUserInteractionEnabled = !isLoading
            self.tblStatistics.reloadData()
        }
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    //MARK: - Custom methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.tblStatistics.delegate = self
        self.tblStatistics.dataSource = self
        self.tblStatistics.showsVerticalScrollIndicator = false
        self.tblStatistics.showsHorizontalScrollIndicator = false
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Statistics".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.addRefreshControl()
        self.registerNib()
    }
    
    func setupData(){
        self.callStatisticListAPI()
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6771393418, green: 0.428924799, blue: 0.9030951262, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblStatistics.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.arrData = []
        self.isTblReload = false
        self.isLoading = true
        self.callStatisticListAPI()
    }
    
    func registerNib(){
        let statisticShimmerCellNib = UINib(nibName: StatisticShimmerCell.className, bundle: nil)
        self.tblStatistics.register(statisticShimmerCellNib, forCellReuseIdentifier: StatisticShimmerCell.className)
        let noDataTableViewCellNib = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblStatistics.register(noDataTableViewCellNib, forCellReuseIdentifier: NoDataTableViewCell.className)
       
    }
    
}
 
//MARK: - UITableView Delegate and Data Source Methods
extension StatisticsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrData.count > 0 {
            return self.arrData.count
        } else {
            return (!self.isTblReload) ? 10 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblStatistics.dequeueReusableCell(withIdentifier: StatisticShimmerCell.className) as! StatisticShimmerCell
        if(!self.isTblReload){
            return cell
        }else{
            if(self.arrData.count > 0){
                let cell:statisticsCell = tblStatistics.dequeueReusableCell(withIdentifier: statisticsCell.className) as! statisticsCell
                cell.selectionStyle = .none
                cell.setData(data: self.arrData[indexPath.row])
                return cell
            }else{
                let NoDatacell = self.tblStatistics.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.lblNoDataTitle.text = "Statistics not found.".localized
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.arrData.count > 0){
            let controller = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: MyEarningVC.storyboardID) as! MyEarningVC
            controller.strId = arrData[indexPath.row].statisticType ?? "0"
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

//MARK: - WebService method
extension StatisticsVC{
    func callStatisticListAPI() {
        self.statisticsViewModel.VC =  self
        let reqModel = StatisticListReqModel()
        reqModel.driverId = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        self.statisticsViewModel.WebServiceForStatiscticList(ReqModel: reqModel)
    }
}
