//
//  ChatListVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class ChatListVC: BaseViewController {

    @IBOutlet weak var tblChatList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblChatList.delegate = self
        tblChatList.dataSource = self
        tblChatList.reloadData()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Chat", leftImage: NavItemsLeft.back.value, rightImages: [NavItemsRight.contactus.value], isTranslucent: true,IsChatScreenLabel:true,NumberOfChatCount: "5")
        // Do any additional setup after loading the view.
    }
}
extension ChatListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChatListCell = tblChatList.dequeueReusableCell(withIdentifier: ChatListCell.className) as! ChatListCell
        cell.lblNoOfMessage.isHidden = true
        if indexPath.row == 0{
            cell.lblNoOfMessage.isHidden = false
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
