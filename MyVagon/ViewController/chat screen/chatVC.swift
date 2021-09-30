//
//  chatVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 24/08/21.
//

import UIKit
import IQKeyboardManagerSwift

class chatVC: BaseViewController {
    var arrayChat = ["delivered the last shipment","Have you left Athens?","Hello","Hi","delivered the last shipment","Have you left Athens?","Hello","Hi","delivered the last shipment","Have you left Athens?","Hello","Hi","delivered the last shipment","Have you left Athens?","Hello","Hi"]
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var tvWriteMessage: ChatthemeTextView!
    @IBOutlet weak var constraintBottomOfChatBG: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.reloadData()
        scrollToBottom()
        setNavigationBarInViewController(controller: self, naviColor: colors.white.value, naviTitle: "Ankur Thumar", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true,IsChatScreenLabel:true, IsChatScreen:true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupKeyboard(true)
//        allSocketOffMethods()
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
//        SocketIOManager.shared.isSocketOn = false
    }
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.arrayChat.count > 1 {
                let indexPath = IndexPath(row: self.arrayChat.count-1, section: 0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    @IBAction func btnSendClick(_ sender: Any) {
        if tvWriteMessage.text.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            arrayChat.append(tvWriteMessage.text)
            tvWriteMessage.text = ""
            tblChat.reloadData()
            scrollToBottom()
        }
        
    }
}
extension chatVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row % 2) == 0 {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            cell.lblMessage.text = arrayChat[indexPath.row]
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblChat.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
            cell.lblMessage.text = arrayChat[indexPath.row]
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
                if self.arrayChat.count != 0 {
                    
                    self.tblChat.layoutIfNeeded()
                    let indexpath = IndexPath(row: self.arrayChat.count - 1, section: 0)
                    self.tblChat.scrollToRow(at: indexpath , at: .top, animated: false)
                    
                }
            }
            constraintBottomOfChatBG.constant = keyboardSize!.height - view.safeAreaInsets.bottom
        } else {
            
            DispatchQueue.main.async {
                if self.arrayChat.count != 0 {
                    self.tblChat.layoutIfNeeded()
                    let indexpath = IndexPath(row: self.arrayChat.count - 1, section: 0)
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

