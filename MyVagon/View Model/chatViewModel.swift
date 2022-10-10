//
//  chatViewModel.swift
//  MyVagon
//
//  Created by Tej P on 26/01/22.
//

import Foundation

class chatViewModel {
    
    weak var VC : ChatVC? = nil
    
    func WebServiceChatHistory(ReqModel:chatMessageReqModel){
        WebServiceSubClass.chatHistory(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            self.VC?.isTblReload = true
            self.VC?.isLoading = false
            if status{
                self.VC?.arrData = response?.data ?? []
                self.VC?.tblChat.reloadData()
                self.VC?.scrollToBottom()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

class chatListViewModel {
    
    weak var chatListVC : ChatListVC? = nil
    weak var myAccountViewController : MyAccountVC? = nil
    
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
    
    func WebServiceSupportAPI(isCall:Bool){
        WebServiceSubClass.getSupportAPI(completion: { (status, apiMessage, response, error) in
            if status{
                if(isCall){
                    self.chatListVC?.callAdmin(strPhone: response?.data?.call ?? "")
                }else{
                    self.chatListVC?.chatWithAdmin(chatObj: (response?.data?.chat)!)
                }
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func WebServiceSupportAPIForSetting(isCall:Bool){
        WebServiceSubClass.getSupportAPI(completion: { (status, apiMessage, response, error) in
            if status{
                if(isCall){
                    self.myAccountViewController?.callAdmin(strPhone: response?.data?.call ?? "")
                }else{
                    self.myAccountViewController?.chatWithAdmin(chatObj: (response?.data?.chat)!)
                }
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
