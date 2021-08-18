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
    var BackClosure : (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
 
    let NavBackButton = UIButton()
    
  
    
    func setNavigationBarInViewController (controller : UIViewController,naviColor : UIColor, naviTitle : String, leftImage : String , rightImages : [String], isTranslucent : Bool, ShowShadow:Bool? = false)
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
//            self.navigationController?.addCustomBottomLine()
//            self.navigationController?.navigationBar.layer.masksToBounds = true
//            self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//                self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//                self.navigationController?.navigationBar.layer.shadowRadius = 4.0
            controller.navigationController?.navigationBar.clipsToBounds = false
            controller.navigationController?.navigationBar.shadowImage =  UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0).image(CGSize(width: self.view.frame.width, height: 1))
//                self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
           
          
              
            
            
        }
        if naviTitle == NavTitles.none.value {
            controller.navigationItem.titleView = UIView()
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
                        BtnRight.roundCorners(corners: [.topLeft,.bottomLeft], radius: 14)
                        BtnRight.backgroundColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
                        BtnRight.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        let ViewRight = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
                        ViewRight.addSubview(BtnRight)
                        
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
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostTruckViewController.storyboardID) as! PostTruckViewController
        controller.hidesBottomBarWhenPushed = true
//        controller.IsHideImage = true
//
//        controller.TitleAttributedText = NSAttributedString(string: "You have successfully posted your availability")
//            controller.DescriptionAttributedText = NSAttributedString(string: "3 matches have been found, would you like to view them?")
//
//        controller.LeftbtnTitle = "Cancel"
//        controller.RightBtnTitle = "Yes"
//        controller.modalPresentationStyle = .overCurrentContext
//        controller.modalTransitionStyle = .crossDissolve
//        self.present(controller, animated: true, completion: nil)
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @objc func BtnNotificationAction(sender:UIButton) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: NotificationViewController.storyboardID) as! NotificationViewController
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    



}

