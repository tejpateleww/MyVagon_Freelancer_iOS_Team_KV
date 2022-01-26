//
//  chatVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 24/08/21.
//

import UIKit
import IQKeyboardManagerSwift

class chatVC: BaseViewController {
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var tvWriteMessage: ChatthemeTextView!
    @IBOutlet weak var constraintBottomOfChatBG: NSLayoutConstraint!
    
    var shipperID:String = ""
    var shipperName:String = ""
    var vhatViewModel = chatViewModel()
    var arrData : [chatData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarInViewController(controller: self, naviColor: colors.white.value, naviTitle: shipperName, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true,IsChatScreenLabel:true, IsChatScreen:true)
        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.ChatSocketOnMethods()
        self.setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.ChatSocketOffMethods()
        self.setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
    }
    
    func setupData(){
        self.callChatHistoryAPI()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.arrData.count > 1 {
                let indexPath = IndexPath(row: self.arrData.count-1, section: 0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @IBAction func btnSendClick(_ sender: Any) {
        if tvWriteMessage.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let param = ["sender_id" : "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)",
                         "receiver_id" : self.shipperID,
                         "message" : self.tvWriteMessage.text ?? "",
                         "type" : "shipper"] as [String : Any]
            self.emitSocket_SendMessage(param: param)
            tvWriteMessage.text = ""
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: "Please enter message.")
        }
        
    }
}

extension chatVC{
    func callChatHistoryAPI() {
        self.vhatViewModel.chatVC = self
        
        let reqModel = chatMessageReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.shipper_id = self.shipperID

        self.vhatViewModel.WebServiceChatHistory(ReqModel: reqModel)
    }
}

extension chatVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(arrData[indexPath.row].senderId == SingletonClass.sharedInstance.UserProfileData?.id){
            let cell = tblChat.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            cell.lblMessage.text = arrData[indexPath.row].message
            cell.lblDate.text = arrData[indexPath.row].createdAt.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: DateFormatForDisplay)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tblChat.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
            cell.lblMessage.text = arrData[indexPath.row].message
            cell.lblDate.text = arrData[indexPath.row].createdAt.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: DateFormatForDisplay)
            cell.selectionStyle = .none
            return cell
        }
       
    }
    
    
}
extension chatVC{
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboards))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboards()
    {
        view.endEditing(true)
    }
    
    
    func setupKeyboard(_ enable: Bool) {
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.enableAutoToolbar = enable
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !enable
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        //        viewScroll.contentInset = UIEdgeInsets.zero
        //        viewScroll.scrollIndicatorInsets = UIEdgeInsets.zero
        constraintBottomOfChatBG.constant = 10
        self.animateConstraintWithDuration()
    }
    @objc func keyboardWasShown(notification: NSNotification){
        
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        
        
        //        viewScroll.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        //        viewScroll.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)
        //           viewScroll.isScrollEnabled = false
        
        
        
        if #available(iOS 11.0, *) {
            
            DispatchQueue.main.async {
                if self.arrData.count != 0 {
                    
                    self.tblChat.layoutIfNeeded()
                    let indexpath = IndexPath(row: self.arrData.count - 1, section: 0)
                    self.tblChat.scrollToRow(at: indexpath , at: .top, animated: false)
                    
                }
            }
            constraintBottomOfChatBG.constant = keyboardSize!.height - view.safeAreaInsets.bottom
        } else {
            
            DispatchQueue.main.async {
                if self.arrData.count != 0 {
                    self.tblChat.layoutIfNeeded()
                    let indexpath = IndexPath(row: self.arrData.count - 1, section: 0)
                    self.tblChat.scrollToRow(at: indexpath , at: .top, animated: false)
                    
                }
            }
            constraintBottomOfChatBG.constant = keyboardSize!.height - 10
        }
        self.animateConstraintWithDuration()
    }
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.loadViewIfNeeded() ?? ()
        })
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

