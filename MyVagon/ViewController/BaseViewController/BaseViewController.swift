//
//  ViewController.swift
//  HJM
//
//  Created by EWW082 on 19/08/19.
//  Copyright © 2019 EWW082. All rights reserved.
//

import UIKit
import SDWebImage
//import LGSideMenuController

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    var SessionNote = ""
//    
//    var lblNavNotifBadge = badgeLabel()
//    var btnNavProfile = buttonForProfile()
//    var switchNavLanguage = switchLanguageSegment()
//    var btnNavSkip = themeSubmitBtn()
    var backButtonClick : (() -> ())?
    
    var btnAddNotesClick : (() -> ())?
    
    var btnViewNotesClick : (() -> ())?
    
    var likeButtonClick : (() -> ())?
    let NavBackButton = UIButton()
    
  
    var rightSideButtonIsSelected : Bool = false
    
    func setNavigationBarInViewController (controller : UIViewController,naviColor : UIColor, naviTitle : String, leftImage : String , rightImages : [String], isTranslucent : Bool,isShowTitleOnTop : Bool,TopTitleTExt : String,isChatScreen:Bool,userImage : String)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        controller.navigationController?.isNavigationBarHidden = false
        controller.navigationController?.navigationBar.isOpaque = false;
        
        controller.navigationController?.navigationBar.isTranslucent = isTranslucent
        
        controller.navigationController?.navigationBar.barTintColor = naviColor;
        controller.navigationController?.navigationBar.tintColor = colors.white.value;
        if naviTitle == NavTitles.Home.value {
            controller.navigationItem.titleView = UIView()
        } else {
          
           // controller.navigationItem.title = naviTitle //.Localized()
            
            
            if isChatScreen {
             
               let navView = setTitle(naviTitle, andImage: userImage)
                controller.navigationItem.titleView = navView
               
            } else {
                let label = UILabel()
                label.text = naviTitle
                label.textColor = colors.white.value
                label.font = CustomFont.medium.returnFont(18)
                label.adjustsFontSizeToFitWidth = true
                controller.navigationItem.titleView = label
            }
            
           
        }
            //controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : colors.black.value, NSAttributedString.Key.font: CustomFont.bold.returnFont(20)]
      //  controller.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-3, for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        if isShowTitleOnTop {
            let TitleVIewOnTOp = UIView.init(frame: CGRect(x: 0, y: 0, width: ((controller.navigationController?.navigationBar.frame.size.width)!), height: 40))
            let titleLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: TitleVIewOnTOp.frame.size.width - 20, height: TitleVIewOnTOp.frame.size.height))
            titleLabel.text = TopTitleTExt
            titleLabel.font = CustomFont.medium.returnFont(33)
            
            titleLabel.textColor = colors.appColor.value
            TitleVIewOnTOp.addSubview(titleLabel)
            
            
                let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: TitleVIewOnTOp)
                btnLeftBar.style = .plain
                controller.navigationItem.leftBarButtonItem = btnLeftBar
         
           // controller.navigationItem.titleView = TitleVIewOnTOp
            
        }  else {
            if leftImage != "" {
                if leftImage == NavItemsLeft.back.value {
                    
                    NavBackButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                   // let btnLeft = UIButton(frame: )
                    NavBackButton.setImage(UIImage.init(named: "nav_back"), for: .normal)
                    NavBackButton.layer.setValue(controller, forKey: "controller")
                    NavBackButton.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
                    let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    LeftView.addSubview(NavBackButton)
                    NavBackButton.isExclusiveTouch = true
                    NavBackButton.isMultipleTouchEnabled = false
                    let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: LeftView)
                    btnLeftBar.style = .plain
                    controller.navigationItem.leftBarButtonItem = btnLeftBar
                } else if leftImage == NavItemsLeft.back.value {
                    let btnLeft = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    btnLeft.setImage(UIImage.init(named: "nav_back"), for: .normal)
                    btnLeft.layer.setValue(controller, forKey: "controller")
                    btnLeft.addTarget(self, action: #selector(self.btnBackFromPresentAction), for: .touchUpInside)
                    let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    LeftView.addSubview(btnLeft)
                
                    let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: LeftView)
                    btnLeftBar.style = .plain
                    controller.navigationItem.leftBarButtonItem = btnLeftBar
                } else if leftImage == NavItemsLeft.cancel.value {
                    
                    NavBackButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                   // let btnLeft = UIButton(frame: )
                    NavBackButton.setImage(UIImage.init(named: "nav_back"), for: .normal)
                    NavBackButton.layer.setValue(controller, forKey: "controller")
                    NavBackButton.addTarget(self, action: #selector(self.btnBackForSkipAction), for: .touchUpInside)
                    let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    LeftView.addSubview(NavBackButton)
                    NavBackButton.isExclusiveTouch = true
                    NavBackButton.isMultipleTouchEnabled = false
                    let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: LeftView)
                    btnLeftBar.style = .plain
                    controller.navigationItem.leftBarButtonItem = btnLeftBar
                }
            } else {
                let emptyView = UIView()
                let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: emptyView)
                btnLeftBar.style = .plain
                controller.navigationItem.leftBarButtonItem = btnLeftBar
            }
           
            if rightImages.count != 0 {
                var arrButtons = [UIBarButtonItem]()
                rightImages.forEach { (title) in
                    if title == NavItemsRight.skip.value {
                        
                        let viewLogin = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))

                        let btnLogin = UIButton.init()
                        btnLogin.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
                        btnLogin.setunderline(title: "Skip", color: colors.white.value, font: CustomFont.bold.returnFont(22))
                        btnLogin.addTarget(self, action: #selector(btnSkipClick(_:)), for: .touchUpInside)
                        btnLogin.contentHorizontalAlignment = .right
                        btnLogin.layer.setValue(controller, forKey: "controller")
                        viewLogin.addSubview(btnLogin)



                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: viewLogin)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    } else if title == NavItemsRight.like.value {
                        
                        let viewLogin = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

                        let btnLogin = UIButton.init()
                        btnLogin.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                        btnLogin.setImage(UIImage(named: "ic_navigation_like_unselected"), for: .normal)
                        btnLogin.setImage(UIImage(named: "ic_navigation_like_selected"), for: .selected)
                        btnLogin.addTarget(self, action: #selector(LikeDisLike(_:)), for: .touchUpInside)
                     
                        btnLogin.layer.setValue(controller, forKey: "controller")
                        viewLogin.addSubview(btnLogin)

                        if rightSideButtonIsSelected {
                            btnLogin.isSelected = true
                        } else {
                            btnLogin.isSelected = false
                        }

                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: viewLogin)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    } else if title == NavItemsRight.edit.value {
                        
                        let viewLogin = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

                        let btnLogin = UIButton.init()
                        btnLogin.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                        btnLogin.setImage(UIImage(named: "ic_navigation_Edit"), for: .normal)
                       
                        btnLogin.addTarget(self, action: #selector(Edit(_:)), for: .touchUpInside)
                     
                        btnLogin.layer.setValue(controller, forKey: "controller")
                        viewLogin.addSubview(btnLogin)

                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: viewLogin)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    }
                    else if title == NavItemsRight.AddNotes.value {

                        let viewLogin = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))

                        let btnLogin = UIButton.init()
                        btnLogin.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
                        btnLogin.setunderline(title: title, color: colors.white.value, font: CustomFont.regular.returnFont(12))

                        btnLogin.addTarget(self, action: #selector(btnAddNotes(_:)), for: .touchUpInside)

                        btnLogin.layer.setValue(controller, forKey: "controller")
                        viewLogin.addSubview(btnLogin)

                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: viewLogin)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    }
                    else if title == NavItemsRight.viewNotes.value {

                        let viewLogin = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))

                        let btnLogin = UIButton.init()
                        btnLogin.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
                        btnLogin.setunderline(title: title, color: colors.white.value, font: CustomFont.regular.returnFont(12))

                        btnLogin.addTarget(self, action: #selector(btnViewNotes(_:)), for: .touchUpInside)

                        btnLogin.layer.setValue(controller, forKey: "controller")
                        viewLogin.addSubview(btnLogin)

                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: viewLogin)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    }
                     else if title == NavItemsRight.skipTour.value {

                        let viewLogin = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 40))

                        let btnLogin = UIButton.init()
                        btnLogin.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
                        btnLogin.setunderline(title: "Skip Tour", color: colors.white.value, font: CustomFont.bold.returnFont(18))
                        btnLogin.addTarget(self, action: #selector(btnSkipTourClick(_:)), for: .touchUpInside)
                        btnLogin.contentHorizontalAlignment = .right
                        btnLogin.layer.setValue(controller, forKey: "controller")
                        viewLogin.addSubview(btnLogin)

                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: viewLogin)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    }
                   
                }
                controller.navigationItem.rightBarButtonItems = arrButtons
            }
        }
    }
    func setTitle(_ title: String, andImage image: String) -> UIStackView {
        let titleLbl = UILabel()
        titleLbl.text = title
        titleLbl.textColor = colors.white.value
        titleLbl.font = CustomFont.medium.returnFont(18)
        
        let imageView = UIImageView()
        if image != ""{
            let strUrl = ""//"\(APIEnvironment.self)"
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            imageView.sd_setImage(with: URL(string: strUrl),  placeholderImage: UIImage())
        }else{
            imageView.image = UIImage.init(named: "user_dummy_profile")
        }
        
        
      //  imageView = CGRect(x: 0, y: 0, width: 30, height: 30)
//        if imageView.frame.size.width > imageView.frame.size.height {
//            imageView.frame.size = CGSize(width: imageView.frame.size.height, height: imageView.frame.size.height)
//        } else {
//            imageView.frame.size = CGSize(width: imageView.frame.size.width, height: imageView.frame.size.width)
//        }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
//        imageView.backgroundColor = .red
//        titleLbl.backgroundColor = .yellow
//        
//        
        let uiview = UIView()
        uiview.backgroundColor = .yellow
        
        let titleView = UIStackView(arrangedSubviews: [imageView,titleLbl,uiview])
        titleView.axis = .horizontal
        titleView.spacing = 8.0
       
        return titleView
        //    navigationItem.titleView = titleView
    }
    
    @objc func Edit(_ sender: UIButton?) {
//        if let topController = UIApplication.topViewController() {
//            var booingIdFromPrevious = ""
//            var isFromMessage : Bool = false
//            if topController.isKind(of: AdviserCommonPopupViewController.self) {
//                let CommonVC = topController as! AdviserCommonPopupViewController
//                booingIdFromPrevious = CommonVC.bookingID
//                isFromMessage = CommonVC.isFromAdvisorMessageController
//            }
//            if topController.presentingViewController != nil {
//                let controller = AppStoryboard.AdviserMain.instance.instantiateViewController(withIdentifier: AdviserCommonPopupViewController.storyboardID) as! AdviserCommonPopupViewController
//                controller.bookingID = booingIdFromPrevious
//                controller.StringButton = "SUBMIT"
//                controller.isShowLeftIcon = true
//                controller.isShowRightIcon = false
//                controller.isShowNoteTextView = true
//                controller.SessionNoteDescripiton = SessionNote
//                controller.stringDescription = "Add Session Note"
//                controller.isFromAdvisorMessageController = isFromMessage
//                controller.btnSubmitClosour = {
//                    self.dismiss(animated: true, completion: {
//
//                        if let TopVC = UIApplication.topViewController() {
//                            if TopVC.isKind(of: AdviserMySessionViewController.self) {
//                                let CommonVC = TopVC as! AdviserMySessionViewController
//                                CommonVC.ReloadAllLoadedSessionData()
//                            }
//                        }
//
//                    })
//
//                }
//        //            controller.textForShow = "Waiting for client to add minutes..."
//
//                topController.navigationController?.pushViewController(controller, animated: true)
//               // appDel.window?.rootViewController?.present(navigationController, animated: true, completion: nil)
//            } else {
//                let controller = AppStoryboard.AdviserMain.instance.instantiateViewController(withIdentifier: AdviserCommonPopupViewController.storyboardID) as! AdviserCommonPopupViewController
//                controller.bookingID = booingIdFromPrevious
//                controller.StringButton = "SUBMIT"
//                controller.isShowLeftIcon = true
//                controller.isShowRightIcon = false
//                controller.isShowNoteTextView = true
//                controller.SessionNoteDescripiton = SessionNote
//                controller.stringDescription = "Add Session Note"
//                controller.isFromAdvisorMessageController = false
//                controller.btnSubmitClosour = {
//                    self.dismiss(animated: true, completion: {
//
//                        if let TopVC = UIApplication.topViewController() {
//                            if TopVC.isKind(of: AdviserMySessionViewController.self) {
//                                let CommonVC = TopVC as! AdviserMySessionViewController
//                                CommonVC.ReloadAllLoadedSessionData()
//                            }
//                        }
//
//
////                        let TopVC = UIApplication.topViewController()
////                            if ((TopVC?.isKind(of: AdviserMySessionViewController.self)) != nil) {
////                                let CommonVC = TopVC as! AdviserMySessionViewController
////                                CommonVC.getSessionData()
////
////                            }
//
//                        })
//                }
//        //            controller.textForShow = "Waiting for client to add minutes..."
//                let navigationController = UINavigationController(rootViewController: controller)
//                navigationController.modalPresentationStyle = .overCurrentContext
//                navigationController.modalTransitionStyle = .crossDissolve
//                appDel.window?.rootViewController?.present(navigationController, animated: true, completion: nil)
//            }
//
//            print(topController.presentedViewController)
//
//        }
        
        
        
//        controller?.navigationController?.pushViewController(docInfoVc, animated: true)
    }
//    func UpdateView() {
//
//        if let lang = userDefault.value(forKey: "language") as? String {
////            if lang == LanguageKey.EnglishLanguage {
////                UIView.appearance().semanticContentAttribute = .forceLeftToRight
////                UITableView.appearance().semanticContentAttribute = .forceLeftToRight
////                self.view.semanticContentAttribute = .forceLeftToRight
////                UITextView.appearance().semanticContentAttribute = .forceLeftToRight
////                UITextField.appearance().semanticContentAttribute = .forceLeftToRight
////                UILabel.appearance().semanticContentAttribute = .forceLeftToRight
////            }
////            else {
////                UIView.appearance().semanticContentAttribute = .forceRightToLeft
////                UITableView.appearance().semanticContentAttribute = .forceRightToLeft
////                self.view.semanticContentAttribute = .forceRightToLeft
////                UITextView.appearance().semanticContentAttribute = .forceRightToLeft
////                UITextField.appearance().semanticContentAttribute = .forceRightToLeft
////                UILabel.appearance().semanticContentAttribute = .forceRightToLeft
////            }
//        }
//    }
    
//    func LanguageUpdate() {
//
//        if let lang = userDefault.value(forKey: "language") as? String {
////            if lang == LanguageKey.EnglishLanguage {
////                self.navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
////                if let NavController = self.navigationController?.children {
////                    NavController.last?.view.semanticContentAttribute = .forceLeftToRight
////                }
////            }
////            else {
//                self.navigationController?.navigationBar.semanticContentAttribute = .forceRightToLeft
//                if let NavController = self.navigationController?.children {
//                    NavController.last?.view.semanticContentAttribute = .forceRightToLeft
//                }
////            }
//        }
//    }
//    @objc func LikeDisLike(_ sender: UIButton?) {
//        if userDefault.bool(forKey: UserDefaultsKey.isUserSkip.rawValue) {
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: LoginViewController.self) {
//                    self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//        } else {
//            if sender?.isSelected == true {
//                rightSideButtonIsSelected = false
//                sender?.isSelected = false
//            } else {
//                sender?.isSelected = true
//                rightSideButtonIsSelected = true
//            }
//        }
//
//        if let click = self.likeButtonClick {
//
//            click()
//        }
//
//
////        controller?.navigationController?.pushViewController(docInfoVc, animated: true)
//    }
    @objc func btnAddNotes(_ sender: UIButton?) {
        if let click = self.btnAddNotesClick {
            click()
        }

    }
    @objc func btnViewNotes(_ sender: UIButton?) {
        if let click = self.btnViewNotesClick {
            click()
        }

    }
    
//    @objc func  EditProfileViewController(_ sender: UIButton?) {
//        guard let ProfilePage = sender?.layer.value(forKey: "controller") as? ProfileViewController else {
//            return
//        }
//        ProfilePage.EditTapped()
//    }
    
//    @objc func  ShowTickets(_ sender: UIButton?) {
//        guard let controller = sender?.layer.value(forKey: "controller") as? GenerateTicketVC else {
//            return
//        }
//        let TickelistPage:MyTicketVC = UIViewController.viewControllerInstance(storyBoard: AppStoryboards.Help)
//        controller.navigationController?.pushViewController(TickelistPage, animated: true)
//    }
    
//    @objc func  SelectPremium(_ sender: UIButton?) {
////        guard sender == UIButton else {
////            return
////        }
//        self.btnPremium.isSelected = !self.btnPremium.isSelected
//        self.isPremiumBooking = self.btnPremium.isSelected
//        if self.btnPremium.isSelected {
//
//            let  infoPopup:HeaderWithDescription = UIViewController.viewControllerInstance(storyBoard: AppStoryboards.CustomPopup)
//            infoPopup.Title = "Premium Search"
//            infoPopup.Desc = UtilityClass.GetPremiumDesc()
//        appDel.window?.rootViewController?.present(infoPopup, animated: true, completion: nil)
//        }
//
//    }
    
    @objc func OpenSideMenu(_ sender: UIButton?) {
//        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//        let vc = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: SideMenuVC.storyboardID)
//        let navController = UINavigationController.init(rootViewController: vc)
//        navController.modalPresentationStyle = .overFullScreen
//        navController.navigationController?.modalTransitionStyle = .crossDissolve
//        controller?.present(navController, animated: false, completion: nil)
    }
    @objc func LikeDisLike(_ sender: UIButton?) {
        
        
        
    }
    @objc func btnSkipClick(_ sender: UIButton?) {
        
//        userDefault.setValue(true, forKey: UserDefaultsKey.isUserSkip.rawValue)
//        userDefault.setValue(false, forKey: UserDefaultsKey.isUserLoginAsAdviser.rawValue)
//        userDefault.setValue(false, forKey: UserDefaultsKey.isUserLoginAsCustomer.rawValue)
//        SingletonClass.sharedInstance.usertype = ""
//        userDefault.setValue("", forKey: UserDefaultsKey.selectedUserType.rawValue)
//        userDefault.synchronize()
//        appDel.navigateToHomeCustomer()
//        controller?.navigationController?.pushViewController(docInfoVc, animated: true)
    }
    @objc func btnSkipTourClick(_ sender: UIButton?) {
        

    //    appDel.navigateToHomeCustomer()
//        controller?.navigationController?.pushViewController(docInfoVc, animated: true)
    }
    @objc func OpenMailVC(_ sender: UIButton?) {
   
//        controller?.navigationController?.pushViewController(docInfoVc, animated: true)
    }
    
    @objc func OpenNotificationsVC(_ sender: UIButton?) {
//        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//        let notifVc = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: NotificationsListVC.storyboardID)
//        controller?.navigationController?.pushViewController(notifVc, animated: true)
    }
    
    @objc func OpenOtherProfileVC(_ sender: UIButton?) {
//        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//        let notifVc = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ProfileVC.storyboardID)
//        controller?.navigationController?.pushViewController(notifVc, animated: true)
    }
    
    @objc func OpenChatVC(_ sender: UIButton?) {
//            let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//            let chatVc = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: MedicalFollowUpChatVC.storyboardID)
           // controller?.navigationController?.pushViewController(chatVc, animated: true)
        }
    @objc func OpenEditProfileVC(_ sender: UIButton?) {
//        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//        let notifVc = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ProfileVC.storyboardID)
//        controller?.navigationController?.pushViewController(notifVc, animated: true)
    }
    @objc func EditUserProfile(_ sender: UIButton?) {
     
        
    }
    @objc func DismissViewController (_ sender: UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
        controller?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func poptoViewController (_ sender: UIButton?)
    {
        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
        controller?.navigationController?.popViewController(animated: true)
    }
    @objc func OpenMenuViewController (_ sender: UIButton?)
    {
       
//        let controller = sender?.layer.value(forKey: "controller") as? UIViewController
//        controller?.frostedViewController.view.endEditing(true)
//        controller?.frostedViewController.presentMenuViewController()
        //        controller?.sideMenuViewController?._presentLeftMenuViewController()
    }
    
    
    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool){
        
        if Title == "Home"
        {
            //            let titleImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 100, height: 30))
            //            titleImage.contentMode = .scaleAspectFit
            //            titleImage.image = UIImage(named: "Title_logo")
            ////            titleImage.backgroundColor  = themeYellowColor
            //             self.navigationItem.titleView = titleImage
            self.title = title?.uppercased()
        }
        else
        {
            self.navigationItem.title = Title.uppercased()
        }
        
//        self.navigationController?.navigationBar.barTintColor = colors.black.value
//        self.navigationController?.navigationBar.tintColor = colors.black.value
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
//        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
       
    }
    
    
    // MARK:- Navigation Bar Button Action Methods
    
//    @objc func OpenMenuAction()
//    {
//        if sideMenuController?.isRightViewVisible == true{
//            sideMenuController?.hideRightView()
//        }
//        else if sideMenuController?.isLeftViewVisible == true  {
//            sideMenuController?.hideLeftView()
//        }
//        else {
////            sideMenuController?.showLeftView(animated: true, completionHandler: nil)
////            appDel.setLanguage()
//
//            if let lang = userDefault.value(forKey: "language") as? String{
//                if lang == LanguageKey.EnglishLanguage {
//                    sideMenuController?.showLeftView(animated: true, completionHandler: nil)
//                }
//                else {
//                    sideMenuController?.showRightView(animated: true, completionHandler: nil)
//                }
////                appDel.setLanguage()
//            }
//        }
//    }
    
    @objc func btnBackAction(sender:UIButton) {
       
        
//        if let topVC = UIApplication.topViewController() {
//            if topVC.isKind(of: MessageViewController.self) {
//              
//            } else {
//                if self.navigationController?.children.count == 1 {
//                    self.navigationController?.dismiss(animated: true, completion: nil)
//                }
//                else {
//                    self.navigationController?.popViewController(animated: true)
//                }
//            }
//        } else {
//            if self.navigationController?.children.count == 1 {
//                self.navigationController?.dismiss(animated: true, completion: nil)
//            }
//            else {
//                self.navigationController?.popViewController(animated: true)
//            }
//            
//           
//        }
        
        if let click = backButtonClick {
            click()
        }
        
    }
    @objc func btnBackForSkipAction(sender:UIButton) {
        
        if let click = backButtonClick {
            click()
        }
        
    }
    @objc func btnBackFromPresentAction() {
        self.dismiss(animated: true, completion: nil)
       
    }
    @objc func btMenuAction() {
        
        
        
    }
    @objc func btnSkipAction() {
        //appDel.navigateToHome()
    }
//    @objc func DeleteAllNotification()
//    {
//        let AlrtMsg = UIAlertController(title: "", message: "Are you sure want to clear all notifications?".Localized(), preferredStyle: .alert)
//        AlrtMsg.addAction(UIAlertAction(title: "OK".Localized(), style: .default, handler: { (UIAlertAction) in
//            self.webServiceForDeleteAllNotifications()
//        }))
//
//        AlrtMsg.addAction(UIAlertAction(title: "Cancel".Localized(), style: .cancel, handler: nil))
//        AlrtMsg.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
//        appDel.window?.rootViewController?.present(AlrtMsg, animated: true, completion: nil)
//    }
    
//    @objc func btnCallAction() {
//
//                let contactNumber = helpLineNumber
//                if contactNumber == "" {
////                    UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
////                    }
//                }
//                else
//                {
//                    callNumber(phoneNumber: contactNumber)
//                }
//    }
//
    
  func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }

    //MARK:- Webservice Methods
    
//    func webServiceForDeleteAllNotifications() {
//
//        UserWebserviceSubclass.deleteNotificationListService(strURL: "") { (Response, Status) in
//            if Status {
//                NotificationCenter.default.post(name: NotificationListReloadKey, object: nil)
//            }
//            else {
//                if let ResponseDict = Response.dictionary {
//                    if let errorMsg = ResponseDict[UtilityClass.GetResponseErrorMessageKey()]?.string {
//                       AlertMessage.showMessageForError(errorMsg)
//                    }
//                }
//            }
//        }
//    }

}

