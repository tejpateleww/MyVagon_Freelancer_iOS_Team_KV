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

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_: [UIMenuElement]) -> UIMenu? in
           
            let all = UIAction(title: "All", image: nil) { _ in }
            let bid = UIAction(title: "Bid", image: nil) { _ in }
            let book = UIAction(title: "Book", image: nil)  { _ in }
            let postedtruck = UIAction(title: "Posted truck", image: nil)  { _ in }
                   
                   return UIMenu(title: "Select Option", children: [all,bid,book,postedtruck])
               }
    }
    var SearchResetClosour : (() -> ())?
    var BackClosure : (() -> ())?
    var btnOptionClosour : (() -> ())?
    
    let btnOption = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
 
    let NavBackButton = UIButton()
   
       
  
    
    
    func setNavigationBarInViewController (controller : UIViewController,naviColor : UIColor, naviTitle : String, leftImage : String , rightImages : [String], isTranslucent : Bool, ShowShadow:Bool? = false,IsChatScreenLabel:Bool? = false,IsChatScreen:Bool? = false,NumberOfChatCount:String? = "",subTitleString:String? = "")
    {
        UIApplication.shared.statusBarStyle = .lightContent
        controller.navigationController?.isNavigationBarHidden = false
        controller.navigationController?.navigationBar.isOpaque = false;
        
        controller.navigationController?.navigationBar.isTranslucent = isTranslucent
        
        controller.navigationController?.navigationBar.barTintColor = naviColor;
        controller.navigationController?.navigationBar.tintColor = colors.white.value;
       
        controller.navigationController?.navigationBar.clipsToBounds = true
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        if ShowShadow ?? false {
            let viewforshadow = UIView()
            controller.navigationController?.navigationBar.clipsToBounds = false
            viewforshadow.backgroundColor = .white
            viewforshadow.frame = CGRect(x: 0, y: (controller.navigationController?.navigationBar.frame.size.height ?? 0.0) - 3, width: (controller.navigationController?.navigationBar.frame.size.width ?? 0.0), height: 1)
            viewforshadow.dropShadow(color: UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), opacity: 0.7, offSet: CGSize(width: 0.0, height: 1.0), radius: 0, scale: true)
            
            //controller.navigationController?.navigationBar.shadowImage =  UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).image(CGSize(width: self.view.frame.width, height: 1))
            
            controller.navigationController?.navigationBar.addSubview(viewforshadow)
            
        }
        if naviTitle == NavTitles.none.value {
            controller.navigationItem.titleView = UIView()
        } else {
            if IsChatScreenLabel ?? false {
                if IsChatScreen ?? false {
                    let ViewNavTitle = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
                    let myCustomView: NavigationTitleView = UIView.fromNib()
                    myCustomView.lblChat.text = naviTitle
                    myCustomView.lblCount.isHidden = true
                    myCustomView.ImageViewMainView.isHidden = false
                    let FullURL = AppDelegate.shared.shipperProfileForChat
                    let url1 = URL.init(string: BaseURLS.ShipperImageURL.rawValue + FullURL)
                    myCustomView.UserImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    myCustomView.UserImageView.sd_setImage(with: url1 , placeholderImage: UIImage(named: "ic_userIcon"))
                    ViewNavTitle.addSubview(myCustomView)
                    self.navigationItem.titleView = ViewNavTitle
                
                }else {
                    let ViewNavTitle = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
                    let myCustomView: NavigationTitleView = UIView.fromNib()
                    myCustomView.lblChat.text = naviTitle
                    myCustomView.lblCount.text = NumberOfChatCount
                    myCustomView.ImageViewMainView.isHidden = true
                    ViewNavTitle.addSubview(myCustomView)
                    self.navigationItem.titleView = ViewNavTitle
                }
              
            } else {
                if subTitleString != "" {
                    let subTitalFinal = " \(subTitleString ?? "")"
                    let lblNavTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
                    lblNavTitle.backgroundColor = UIColor.clear
                    lblNavTitle.numberOfLines = 0
                    lblNavTitle.center = CGPoint(x: 0, y: 0)
                    lblNavTitle.textAlignment = .left
                    let AttributedStringFinal = naviTitle.Medium(color: UIColor.appColor(ThemeColor.NavigationTitleColor), FontSize: 18)
                  
                    AttributedStringFinal.append(subTitalFinal.Regular(color: UIColor.appColor(ThemeColor.NavigationTitleColor), FontSize: 14))
                 
                  
                    lblNavTitle.attributedText = AttributedStringFinal
                    self.navigationItem.titleView = lblNavTitle
                } else {
                    let lblNavTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
                    lblNavTitle.font = CustomFont.PoppinsMedium.returnFont(18)
                    lblNavTitle.backgroundColor = UIColor.clear
                    lblNavTitle.textColor = UIColor.appColor(ThemeColor.NavigationTitleColor)
                    lblNavTitle.numberOfLines = 0
                    lblNavTitle.center = CGPoint(x: 0, y: 0)
                    lblNavTitle.textAlignment = .left
                    lblNavTitle.text = naviTitle
                    self.navigationItem.titleView = lblNavTitle
                }
                
            }
            
        }
            if leftImage != "" {
                if leftImage == NavItemsLeft.back.value {
                    
                    NavBackButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                   // let btnLeft = UIButton(frame: )
                    NavBackButton.setImage(UIImage.init(named: "ic_navigation_back"), for: .normal)
                    NavBackButton.layer.setValue(controller, forKey: "controller")
                    NavBackButton.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
                    let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                    LeftView.addSubview(NavBackButton)
                    NavBackButton.isExclusiveTouch = true
                    NavBackButton.isMultipleTouchEnabled = false
                    let btnLeftBar : UIBarButtonItem = UIBarButtonItem.init(customView: LeftView)
                    btnLeftBar.style = .plain
                    controller.navigationItem.leftBarButtonItem = btnLeftBar
                }else if leftImage == NavItemsLeft.chat.value{
                    let button = UIButton(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
                    button.setImage(UIImage.init(named: "ic_navigation_back"), for: .normal)
                    button.layer.setValue(controller, forKey: "controller")
                    button.addTarget(self, action: #selector(self.btnBackAction), for: .touchUpInside)
                    
                    let LeftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
                    LeftView.addSubview(button)
                    
                    let ImgX = button.frame.origin.x +  50
                    let image = UIImageView(frame: CGRect(x: ImgX , y: 5, width: 32, height: 32))
                    image.image = UIImage(named: "ic_ChatProfile")
                    LeftView.addSubview(image)
                    
                    let labelX = image.frame.origin.x + 50
                    let label = UILabel(frame: CGRect(x: labelX , y: 0, width: 200, height: 40))
                    label.text = "Mike Ross"
                    LeftView.addSubview(label)
                    

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
                        
                        let ViewSkip = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))

                        let btnSkip = UIButton.init()
                        btnSkip.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
                        btnSkip.setTitle("Skip", for: .normal)
                        
                        btnSkip.setTitleColor(colors.black.value, for: .normal)
                        btnSkip.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(15)
                       
                        btnSkip.addTarget(self, action: #selector(btnSkipClick(_:)), for: .touchUpInside)
                        btnSkip.contentHorizontalAlignment = .right
                        btnSkip.layer.setValue(controller, forKey: "controller")
                        ViewSkip.addSubview(btnSkip)



                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewSkip)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    } else  if title == NavItemsRight.reset.value {
                        
                        let ViewSkip = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))

                        let btnSkip = UIButton.init()
                        btnSkip.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
                        btnSkip.setTitle("Reset", for: .normal)
                        
                        btnSkip.setTitleColor(colors.black.value, for: .normal)
                        btnSkip.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(15)
                       
                        btnSkip.addTarget(self, action: #selector(btnResetSearchClick(_:)), for: .touchUpInside)
                        btnSkip.contentHorizontalAlignment = .right
                        btnSkip.layer.setValue(controller, forKey: "controller")
                        ViewSkip.addSubview(btnSkip)
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewSkip)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    } else if title == NavItemsRight.chat.value {
                        
                        let BtnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        BtnRight.setImage(UIImage.init(named: "ic_chat"), for: .normal)
                        BtnRight.layer.setValue(controller, forKey: "controller")
                        BtnRight.addTarget(self, action: #selector(self.BtnChatAction), for: .touchUpInside)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        ViewRight.addSubview(BtnRight)
                    
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                       
                    } else if title == NavItemsRight.chatDirect.value {
                        
                        let BtnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        BtnRight.setImage(UIImage.init(named: "ic_chatDirect"), for: .normal)
                        BtnRight.layer.setValue(controller, forKey: "controller")
                        BtnRight.addTarget(self, action: #selector(self.BtnChatDirectAction), for: .touchUpInside)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        ViewRight.addSubview(BtnRight)
                    
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                       
                    } else if title == NavItemsRight.notification.value {
                        
                        let BtnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        BtnRight.setImage(UIImage.init(named: "ic_notification"), for: .normal)
                        BtnRight.layer.setValue(controller, forKey: "controller")
                        BtnRight.addTarget(self, action: #selector(self.BtnNotificationAction), for: .touchUpInside)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        ViewRight.addSubview(BtnRight)
                    
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                       
                    } else if title == NavItemsRight.RequestEdit.value {
                        let BtnRight = themeButton(frame: CGRect(x: 30, y: 5, width: 140, height: 30))
                        BtnRight.FontSize = 14
                        BtnRight.TextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        BtnRight.semanticContentAttribute = .forceLeftToRight
                        BtnRight.setImage(UIImage.init(named: "ic_edit"), for: .normal)
                        BtnRight.setTitle("Request Edit", for: .normal)
                        BtnRight.addTarget(self, action: #selector(self.btnRequestEdit(sender:)), for: .touchUpInside)
                        BtnRight.roundCorners(corners: [.topLeft,.bottomLeft], radius: 14)
                        BtnRight.backgroundColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
                        BtnRight.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
                        ViewRight.addSubview(BtnRight)
                        
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                    }else if title == NavItemsRight.contactus.value{
                        let BtnRight = themeButton(frame: CGRect(x: 30, y: 5, width: 140, height: 30))
                        BtnRight.FontSize = 14
                        BtnRight.TextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        BtnRight.semanticContentAttribute = .forceLeftToRight
                        BtnRight.setImage(UIImage.init(named: "ic_call"), for: .normal)
                        BtnRight.setTitle(" Support", for: .normal)
                        BtnRight.roundCorners(corners: [.topLeft,.bottomLeft], radius: 14)
                        BtnRight.backgroundColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
                        BtnRight.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        BtnRight.addTarget(self, action: #selector(self.btnSupportAction(sender:)), for: .touchUpInside)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
                        ViewRight.addSubview(BtnRight)
                        
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                        
                    }else if title == NavItemsRight.search.value{
                        let BtnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        BtnRight.setImage(UIImage.init(named: "ic_searchNavigation"), for: .normal)
                        BtnRight.layer.setValue(controller, forKey: "controller")
                        BtnRight.addTarget(self, action: #selector(self.btnSearchAction(sender:)), for: .touchUpInside)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        ViewRight.addSubview(BtnRight)
                    
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                        
                    }else if title == NavItemsRight.option.value{
                        
                        
                        btnOption.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                        btnOption.setImage(UIImage.init(named: "ic_option"), for: .normal)
                        btnOption.layer.setValue(controller, forKey: "controller")
                        btnOption.addTarget(self, action: #selector(self.btnOptionAction(sender:)), for: .touchUpInside)
                        
//                        let btnInteraction = UIContextMenuInteraction(delegate: self)
//                        btnOption.addInteraction(btnInteraction)
//                        if #available(iOS 14.0, *) {
//                            btnOption.showsMenuAsPrimaryAction = true
//                        } else {
//                           
//                        }
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                        ViewRight.addSubview(btnOption)
                    
                        let btnRightBar : UIBarButtonItem = UIBarButtonItem.init(customView: ViewRight)
                        btnRightBar.style = .plain
                        arrButtons.append(btnRightBar)
                        
                    }
                   
                }
                controller.navigationItem.rightBarButtonItems = arrButtons
            }
        
    }
    @objc func btnSkipClick(_ sender: UIButton?) {
        
        
        appDel.NavigateToLogin()
//        controller?.navigationController?.pushViewController(docInfoVc, animated: true)
    }
    @objc func btnResetSearchClick(_ sender: UIButton?) {
        if let click = self.SearchResetClosour {
            click()
        }
   
    }
    
    @objc func btnBackAction(sender:UIButton) {
       
        if self.navigationController?.children.count == 1 {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        if let click = self.BackClosure {
            click()
        }
    }
    
    @objc func BtnChatAction(sender:UIButton) {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: ChatListVC.storyboardID) as! ChatListVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func BtnChatDirectAction(sender:UIButton) {
        let controller = AppStoryboard.Chat.instance.instantiateViewController(withIdentifier: chatVC.storyboardID) as! chatVC
        controller.shipperID = AppDelegate.shared.shipperIdForChat
        controller.shipperName = AppDelegate.shared.shipperNameForChat
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func BtnNotificationAction(sender:UIButton) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: NotificationViewController.storyboardID) as! NotificationViewController
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @objc func BtnContactAction(sender:UIButton) {
        
    }
    
    @objc func btnSearchAction(sender:UIButton) {
        
    }
    @objc func btnRequestEdit(sender:UIButton) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: NewEditProfile.storyboardID) as! NewEditProfile
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @objc func btnOptionAction(sender:UIButton) {
        

        if let click = btnOptionClosour {
                        click()
                    }

//        if #available(iOS 14.0, *) {
//          
//        } else {
//
//        }
//        
        
    }

    @objc func btnSupportAction(sender:UIButton) {
        NotificationCenter.default.post(name: .openSupportPopUp, object: nil)
    }
   

}


