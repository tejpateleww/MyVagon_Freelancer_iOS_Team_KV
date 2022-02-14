//
//  ChatListVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit
import SDWebImage

class ChatListVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet weak var txtSearch: themeTextfield!
    
    var vhatListViewModel = chatListViewModel()
    var arrData : [ChatUserList] = []
    var arrFilterData : [ChatUserList] = []
    var isSearched : Bool = false
    
    // Pull to refresh
    let refreshControl = UIRefreshControl()
    
    //shimmer
    var isTblReload = false
    var isLoading = true {
        didSet {
            self.tblChatList.isUserInteractionEnabled = !isLoading
            self.tblChatList.reloadData()
        }
    }
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    //MARK: - Custome methods
    func prepareView(){
        self.registerNib()
        self.addRefreshControl()
        self.setupData()
        self.setupUI()
    }
    
    func setupData(){
        self.callChatUserListAPI()
    }
    
    func setupUI(){
        self.setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Chat", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.contactus.value], isTranslucent: true, IsChatScreenLabel:true,NumberOfChatCount: "5")
        self.tblChatList.delegate = self
        self.tblChatList.dataSource = self
        self.tblChatList.separatorStyle = .none
        self.tblChatList.showsHorizontalScrollIndicator = false
        self.tblChatList.showsVerticalScrollIndicator = false
        
    }
    
    func addRefreshControl(){
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.tintColor = #colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.tblChatList.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.arrData = []
        self.arrFilterData = []
        self.txtSearch.text = ""
        self.txtSearch.resignFirstResponder()
        self.isSearched = false
        self.isTblReload = false
        self.isLoading = true
        self.callChatUserListAPI()
    }
    
    @objc func reloadFilter() {
        
        self.isSearched = false
        self.arrFilterData = self.arrData
        let searchText = self.txtSearch.text ?? ""
        if searchText.isEmpty == false {
            self.isSearched = true
            self.arrFilterData =  self.arrData.filter ({ ($0.name).lowercased().contains(searchText.lowercased())})
        }
        self.tblChatList.reloadData()
    }
    
    func registerNib(){
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblChatList.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
        let nib = UINib(nibName: NotiShimmerCell.className, bundle: nil)
        self.tblChatList.register(nib, forCellReuseIdentifier: NotiShimmerCell.className)
    }
}

//MARK: - UITableView methods
extension ChatListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearched){
            if(self.arrFilterData.count > 0){
                return self.arrFilterData.count
            }else{
                return (!self.isTblReload) ? 10 : 1
            }
        }else{
            if(self.arrData.count > 0){
                return self.arrData.count
            }else{
                return (!self.isTblReload) ? 10 : 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblChatList.dequeueReusableCell(withIdentifier: NotiShimmerCell.className) as! NotiShimmerCell
        if(!self.isTblReload){
            cell.lblNotiDesc.text = "DummyDataForShimmer"
            cell.lblNotiTitle.text = "DummyData"
            return cell
        }else{
            if(isSearched ? self.arrFilterData.count > 0 : self.arrData.count > 0){
                let cell:ChatListCell = tblChatList.dequeueReusableCell(withIdentifier: ChatListCell.className) as! ChatListCell
                cell.lblNoOfMessage.isHidden = false
                cell.lblName.text = (isSearched) ? self.arrFilterData[indexPath.row].name : self.arrData[indexPath.row].name
                cell.lblMessage.text = (isSearched) ? self.arrFilterData[indexPath.row].message : self.arrData[indexPath.row].message
                cell.lblDate.text = (isSearched) ? self.arrFilterData[indexPath.row].messageTime.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm a", ToFormat: DateFormatForDisplay)
                : self.arrData[indexPath.row].messageTime.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm a", ToFormat: DateFormatForDisplay)
                
                let FullURL = (isSearched) ? self.arrFilterData[indexPath.row].profile : self.arrData[indexPath.row].profile
                let url = URL.init(string: BaseURLS.ShipperImageURL.rawValue + FullURL)
                cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
                cell.imgProfile.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userIcon"))
                
                cell.selectionStyle = .none
                return cell
            }else{
                let NoDatacell = self.tblChatList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.imgNoData.image = UIImage(named: "ic_chat")?.withTintColor(#colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1))
                NoDatacell.lblNoDataTitle.text = "No Chat Available!"
                return NoDatacell
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(isSearched ? self.arrFilterData.count > 0 : self.arrData.count > 0){
            
            AppDelegate.shared.shipperIdForChat = (isSearched) ? "\(self.arrFilterData[indexPath.row].id)" : "\(self.arrData[indexPath.row].id)"
            AppDelegate.shared.shipperNameForChat = (isSearched) ? "\(self.arrFilterData[indexPath.row].name)" : "\(self.arrData[indexPath.row].name)"
            AppDelegate.shared.shipperProfileForChat = (isSearched) ? self.arrFilterData[indexPath.row].profile : self.arrData[indexPath.row].profile
            
            let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
            controller.shipperID = AppDelegate.shared.shipperIdForChat
            controller.shipperName = AppDelegate.shared.shipperNameForChat
            AppDelegate.shared.shipperProfileForChat = AppDelegate.shared.shipperProfileForChat
            self.navigationController?.pushViewController(controller, animated: true)
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
            if(isSearched ? self.arrFilterData.count > 0 : self.arrData.count > 0){
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
    
}

extension ChatListVC{
    func callChatUserListAPI() {
        self.vhatListViewModel.chatListVC = self
        
        let reqModel = chatListReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        self.vhatListViewModel.WebServiceChatList(ReqModel: reqModel)
    }
}

//MARK: - TextField Delegate
extension ChatListVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadFilter), object: nil)
           self.perform(#selector(reloadFilter), with: nil, afterDelay: 0.7)
        return true
    }
}
