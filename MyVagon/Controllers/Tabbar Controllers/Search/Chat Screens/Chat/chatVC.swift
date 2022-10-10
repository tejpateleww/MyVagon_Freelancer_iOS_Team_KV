//
//  chatVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 24/08/21.
//

import UIKit
import IQKeyboardManagerSwift

class ChatVC: BaseViewController {
    
    //MARK: - Propertise
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var tvWriteMessage: ChatthemeTextView!
    @IBOutlet weak var constraintBottomOfChatBG: NSLayoutConstraint!
    
    @IBOutlet weak var viewChat: ViewCustomClass!
    var shipperID:String = ""
    var shipperName:String = ""
    var vhatViewModel = chatViewModel()
    var arrData : [chatData] = []
    var isTblReload = false
    var allowChat = true
    var isLoading = true {
        didSet {
            self.tblChat.isUserInteractionEnabled = !isLoading
            self.tblChat.reloadData()
        }
    }
    
    //MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarInViewController(controller: self, naviColor: colors.white.value, naviTitle: shipperName, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true,IsChatScreenLabel:true, IsChatScreen:true)
        self.prepareView()
        self.addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.ChatSocketOnMethods()
        self.setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
        self.setLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.ChatSocketOffMethods()
        self.setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
    }
    
    //MARK: - Custom method
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func setLocalization(){
        self.tvWriteMessage.placeholder = "Message".localized
    }
    
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.addNotificationObs()
        self.registerNib()
        viewChat.isHidden = !self.allowChat
    }
    
    func registerNib(){
        let nib = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblChat.register(nib, forCellReuseIdentifier: NoDataTableViewCell.className)
        let nib2 = UINib(nibName: ChatShimmerCell.className, bundle: nil)
        self.tblChat.register(nib2, forCellReuseIdentifier: ChatShimmerCell.className)
    }
    
    func setupData(){
        self.callChatHistoryAPI()
    }
    
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .reloadChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadChatScreen), name: .reloadChatScreen, object: nil)
        NotificationCenter.default.removeObserver(self, name: .reloadNewUserChatScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadNewUserChatScreen), name: .reloadNewUserChatScreen, object: nil)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.arrData.count > 1 {
                let indexPath = IndexPath(row: self.arrData.count-1, section: 0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func reloadChatScreen() {
        self.arrData = []
        self.isTblReload = false
        self.isLoading = true
        self.callChatHistoryAPI()
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    @objc func reloadNewUserChatScreen() {
        self.shipperID = AppDelegate.shared.shipperIdForChat
        self.shipperName = AppDelegate.shared.shipperNameForChat
        self.setNavigationBarInViewController(controller: self, naviColor: colors.white.value, naviTitle: shipperName, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true,IsChatScreenLabel:true, IsChatScreen:true)
        self.callChatHistoryAPI()
        AppDelegate.pushNotificationObj = nil
        AppDelegate.pushNotificationType = nil
    }
    
    //MARK: - IBAction method
    @IBAction func btnSendClick(_ sender: Any) {
        if tvWriteMessage.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let param = ["sender_id" : "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)",
                         "receiver_id" : self.shipperID,
                         "message" : self.tvWriteMessage.text ?? "",
                         "type" : "shipper"] as [String : Any]
            self.emitSocket_SendMessage(param: param)
            tvWriteMessage.text = ""
        }else{
            Utilities.ShowAlertOfInfo(OfMessage: "Pleaseentermessage.".localized)
        }
    }
}

//MARK: - WebServise method
extension ChatVC {
    func callChatHistoryAPI() {
        self.vhatViewModel.VC = self
        let reqModel = chatMessageReqModel ()
        reqModel.driver_id = "\(SingletonClass.sharedInstance.UserProfileData?.id ?? 0)"
        reqModel.shipper_id = self.shipperID
        self.vhatViewModel.WebServiceChatHistory(ReqModel: reqModel)
    }
}

//MARK: - tableview datasource and delegate
extension ChatVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.arrData.count > 0){
            return self.arrData.count
        }else{
            return (!self.isTblReload) ? 10 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(!self.isTblReload){
            let cell = tblChat.dequeueReusableCell(withIdentifier: ChatShimmerCell.className) as! ChatShimmerCell
            return cell
        }else{
            if(self.arrData.count > 0){
                if(arrData[indexPath.row].senderId == SingletonClass.sharedInstance.UserProfileData?.id){
                    let cell = tblChat.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                    cell.lblMessage.text = arrData[indexPath.row].message?.html2String
                    cell.lblDate.text = arrData[indexPath.row].createdAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: timeFormatForDisplay)
                    cell.selectionStyle = .none
                    return cell
                }else{
                    let cell = tblChat.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                    cell.lblMessage.text = arrData[indexPath.row].message?.html2String
                    cell.lblDate.text = arrData[indexPath.row].createdAt?.ConvertDateFormat(FromFormat: "yyyy-MM-dd HH:mm:ss", ToFormat: timeFormatForDisplay)
                    cell.selectionStyle = .none
                    return cell;
                }
            }else{
                let NoDatacell = self.tblChat.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
                NoDatacell.imgNoData.image = UIImage(named: "ic_chat")?.withTintColor(#colorLiteral(red: 0.6078431373, green: 0.3176470588, blue: 0.8784313725, alpha: 1))
                NoDatacell.lblNoDataTitle.text = "No data found".localized
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
            if(self.arrData.count > 0){
                return UITableView.automaticDimension
            }else{
                return tableView.frame.height
            }
        }
    }
}

extension ChatVC {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboards))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboards(){
        view.endEditing(true)
    }
    
    func setupKeyboard(_ enable: Bool) {
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.enableAutoToolbar = enable
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !enable
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        constraintBottomOfChatBG.constant = 10
        self.animateConstraintWithDuration()
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
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
