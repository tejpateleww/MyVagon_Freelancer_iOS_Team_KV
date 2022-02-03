//
//  chatViewModel.swift
//  MyVagon
//
//  Created by Tej P on 26/01/22.
//

import Foundation

class chatViewModel {
    
    weak var chatVC : chatVC? = nil
    
    func WebServiceChatHistory(ReqModel:chatMessageReqModel){
        WebServiceSubClass.chatHistory(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status{
                self.chatVC?.arrData = response?.data ?? []
                self.chatVC?.tblChat.reloadData()
                self.chatVC?.scrollToBottom()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

class chatListViewModel {
    
    weak var chatListVC : ChatListVC? = nil
    
    func WebServiceChatList(ReqModel:chatListReqModel){
        WebServiceSubClass.chatUserList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.chatListVC?.tblChatList.isHidden = false
            self.chatListVC?.isTblReload = true
            self.chatListVC?.isLoading = false
            DispatchQueue.main.async {
                self.chatListVC?.refreshControl.endRefreshing()
            }
            if status{
                self.chatListVC?.arrData = response?.data ?? []
                self.chatListVC?.tblChatList.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
