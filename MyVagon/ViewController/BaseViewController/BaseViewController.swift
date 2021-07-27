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
 
    let NavBackButton = UIButton()
    
  
    
    func setNavigationBarInViewController (controller : UIViewController,naviColor : UIColor, naviTitle : String, leftImage : String , rightImages : [String], isTranslucent : Bool)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        controller.navigationController?.isNavigationBarHidden = false
        controller.navigationController?.navigationBar.isOpaque = false;
        
        controller.navigationController?.navigationBar.isTranslucent = isTranslucent
        
        controller.navigationController?.navigationBar.barTintColor = naviColor;
        controller.navigationController?.navigationBar.tintColor = colors.white.value;
       
        
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
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
        
    }
  
    
 



}

