//
//  NotificationViewController.swift
//  MyVagon
//
//  Created by Apple on 13/08/21.
//

import UIKit

class NotificationVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tblNotification: UITableView!
    
    var notificationListViewModel = NotificationListViewModel()
    var arrNotification : [NotificationListData]?
    var customTabBarController: CustomTabBarVC?
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblNotification.isUserInteractionEnabled = !isLoading
            self.tblNotification.reloadData()
        }
    }
    let refreshControl = UIRefreshControl()

    //MARK: - Life-cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        self.customTabBarController?.hideTabBar()
    }
    
    //MARK: - Custom Methods
    func prepareView(){
        self.registerNib()
        self.addRefreshControl()
        self.setupUI()
        self.setupData()
        self.addNotificationObservers()
    }
  
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Notifications".localized, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.tblNotification.delegate = self
        self.tblNotification.dataSource = self
        self.tblNotification.showsHorizontalScrollIndicator = false
        self.tblNotification.showsVerticalScrollIndicator = false
    }
    
    func registerNib(){
        let nib2 = UINib(nibName: NotiShimmerCell.className, bundle: nil)
        self.tblNotification.register(nib2, forCellReuseIdentifier: NotiShimmerCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblNotification.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6771393418, green: 0.428924799, blue: 0.9030951262, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblNotification.addSubview(self.refreshControl)
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: .reloadNotificationScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNotificationScreen), name: .reloadNotificationScreen, object: nil)
    }
    
    @objc func reloadNotificationScreen(){
        self.relaodScreen()
    }
    
    @objc func refresh(_ sender: AnyObject){
        self.relaodScreen()
    }
    
    func relaodScreen() {
        self.arrNotification = []
        self.isTblReload = false
        self.isLoading = true
        self.callAPI()
    }
    
    func setupData(){
        self.callAPI()
    }
}

//MARK: - Webservice method
extension NotificationVC{
    func callAPI() {
        self.notificationListViewModel.notificationViewController =  self
        self.notificationListViewModel.WebServiceForNotificationList()
    }
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension NotificationVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.arrNotification?.count ?? 0 > 0 {
            return self.arrNotification?.count ?? 0
        } else {
            return (!self.isTblReload) ? 10 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotification.dequeueReusableCell(withIdentifier: NotiShimmerCell.className) as! NotiShimmerCell
        if(!self.isTblReload){
            cell.lblNotiDesc.text = "DummyDataForShimmer"
            cell.lblNotiTitle.text = "DummyDataForShimmer"
            return cell
        }else{
            if(self.arrNotification?.count ?? 0 > 0){
                let cell = tblNotification.dequeueReusableCell(withIdentifier: NotificationCell.className) as! NotificationCell
                cell.LblTitle.text = self.arrNotification?[indexPath.row].title ?? ""
                cell.LblDescription.text = self.arrNotification?[indexPath.row].message ?? ""
                cell.LblDate.text = self.arrNotification?[indexPath.row].date?.ConvertDateFormat(FromFormat: "yyyy-MM-dd", ToFormat: DateFormatForDisplay)
                cell.selectionStyle = .none
                return cell
            }else{
                let NoDatacell = self.tblNotification.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.imgNoData.image = UIImage(named: "ic_notification")?.withTintColor(#colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1))
                NoDatacell.lblNoDataTitle.text = "\("Notifications not found".localized)."
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
            if self.arrNotification?.count ?? 0 != 0 {
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
}
