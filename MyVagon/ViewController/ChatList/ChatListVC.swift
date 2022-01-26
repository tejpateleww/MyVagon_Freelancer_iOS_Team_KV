//
//  ChatListVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class ChatListVC: BaseViewController {

    //MARK: - Properties
    @IBOutlet weak var tblChatList: UITableView!
    
    var vhatListViewModel = chatListViewModel()
    var arrData : [ChatUserList] = []
    
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
}

//MARK: - UITableView methods
extension ChatListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatListCell = tblChatList.dequeueReusableCell(withIdentifier: ChatListCell.className) as! ChatListCell
        cell.lblNoOfMessage.isHidden = false
        cell.lblName.text = self.arrData[indexPath.row].name
        
        let url = URL.init(string:self.arrData[indexPath.row].profile)
        cell.imgProfile.sd_setImage(with: url , placeholderImage: UIImage(named: "ic_userIcon"))
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
        controller.shipperID = "\(self.arrData[indexPath.row].id)"
        controller.shipperName = self.arrData[indexPath.row].name
        
        AppDelegate.shared.shipperProfileForChat = self.arrData[indexPath.row].profile
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
