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
                self.loadDetailsVC?.openReloadView(strTitle: apiMessage)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

