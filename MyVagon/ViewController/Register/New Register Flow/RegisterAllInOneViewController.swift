//
//  RegisterAllInOneViewController.swift
//  MyVagon
//
//  Created by Apple on 02/08/21.
//

import UIKit

class RegisterAllInOneViewController: BaseViewController,UIScrollViewDelegate {
    
    //MARK: - Properties
    @IBOutlet var MainScrollView: UIScrollView!
    
    //MARK: - Life-Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        self.MainScrollView.delegate = self
        
        self.BackClosure = {
            let ScreenNumber = self.MainScrollView.contentOffset.x/UIScreen.main.bounds.width
            switch ScreenNumber {
            case 0:
                SingletonClass.sharedInstance.clearSingletonClassForRegister()
                appDel.NavigateToLogin()
                break
            case 1:
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 0
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            case 2:
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 1
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            case 3:
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 2
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            case 4:
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 3
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            case 5:
                let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
                let x = self.view.frame.size.width * 4
                RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                RegisterMainVC.viewDidLayoutSubviews()
            default:
                break
            }
        }
        
        DispatchQueue.main.async {
            let CheckUserDefaultRegisterComeplete = UserDefault.value(forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue) as? Int ?? -1
            switch CheckUserDefaultRegisterComeplete {
            case 0:
                let x = self.view.frame.size.width * 1
                self.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            case 1:
                let x = self.view.frame.size.width * 2
                self.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            case 2:
                let x = self.view.frame.size.width * 3
                self.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            case 3:
                let x = self.view.frame.size.width * 4
                self.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            case 4:
                let x = self.view.frame.size.width * 5
                self.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
            default:
                break
            }
        }
    }
    
    //MARK: - Custom Methods
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let ScreenNumber = scrollView.contentOffset.x/UIScreen.main.bounds.width
        switch ScreenNumber {
        case 0:
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        case 1:
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        case 2:
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        case 3:
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.none.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        case 4:
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: "Payment Method", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        case 5:
            setNavigationBarInViewController(controller: self, naviColor: UIColor.white, naviTitle: NavTitles.TermsCondition.value, leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        default:
            break
        }
    }
    
}
