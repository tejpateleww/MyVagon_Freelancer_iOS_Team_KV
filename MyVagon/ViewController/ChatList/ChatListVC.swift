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
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareView()
    }
    
    //MARK: - Custome methods
    func prepareView(){
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
}

//MARK: - UITableView methods
extension ChatListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearched){
            return self.arrFilterData.count
        }else{
            return self.arrData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
        controller.shipperID = (isSearched) ? "\(self.arrFilterData[indexPath.row].id)" : "\(self.arrData[indexPath.row].id)"
        controller.shipperName = (isSearched) ? self.arrFilterData[indexPath.row].name  : self.arrData[indexPath.row].name
        AppDelegate.shared.shipperProfileForChat = (isSearched) ? self.arrFilterData[indexPath.row].profile : self.arrData[indexPath.row].profile
        self.navigationController?.pushViewController(controller, animated: true)
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
