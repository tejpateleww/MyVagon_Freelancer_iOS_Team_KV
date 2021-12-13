//
//  LoadDetailViewModel.swift
//  MyVagon
//
//  Created by Apple on 30/11/21.
//

import Foundation
import UIKit
class LoadDetailViewModel {
    weak var loadDetailsVC : LoadDetailsVC? = nil
    weak var commonAcceptRejectPopupVC : CommonAcceptRejectPopupVC? = nil
    
    func BookNow(ReqModel:BookNowReqModel){
        Utilities.ShowLoaderButtonInButton(Button: commonAcceptRejectPopupVC?.BtnRight ?? themeButton(), vc: commonAcceptRejectPopupVC ?? UIViewController())
      
        WebServiceSubClass.BookNow(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.commonAcceptRejectPopupVC?.BtnRight ?? themeButton(), vc: self.commonAcceptRejectPopupVC ?? UIViewController())
            self.commonAcceptRejectPopupVC?.dismiss(animated: true, completion: nil)
            if status {
                self.loadDetailsVC?.navigationController?.popToRootViewController(animated: false)
                if SingletonClass.sharedInstance.UserProfileData?.permissions?.myLoads ?? 0 == 0 {
                    
                    self.loadDetailsVC?.navigationController?.popToRootViewController(animated: false)


                } else {
                
                    let tabBar = self.loadDetailsVC?.customTabBarController?.tabBar

                    tabBar?.items?.forEach({ element in
                        element.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    })
                    self.loadDetailsVC?.customTabBarController?.selectedIndex = 1
//
                    let topEdge = (tabBar?.items![0].imageInsets.top ?? 0) - 10
                    let leftEdge = tabBar?.items![0].imageInsets.left ?? 0
                    let rightEdge = tabBar?.items![0].imageInsets.right ?? 0


                    tabBar?.items![1].imageInsets = UIEdgeInsets(top: topEdge, left: leftEdge, bottom: 10, right: rightEdge)
//
                  
               //     appDel.NavigateToSchedual()

                    self.loadDetailsVC?.navigationController?.popToRootViewController(animated: false)

                }
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

