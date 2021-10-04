//
//  BidNowViewModel.swift
//  MyVagon
//
//  Created by Apple on 30/09/21.
//

import Foundation
import UIKit
class BidNowViewModel {
    weak var bidNowPopupViewController : BidNowPopupViewController? = nil
    
    func WebServiceBidPost(ReqModel:BidReqModel){
        Utilities.ShowLoaderButtonInButton(Button: bidNowPopupViewController?.BtnRight ?? themeButton(), vc: bidNowPopupViewController ?? UIViewController())
        WebServiceSubClass.BidPost(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.bidNowPopupViewController?.BtnRight ?? themeButton(), vc: self.bidNowPopupViewController ?? UIViewController())
            if status{
               
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                appDel.NavigateToHome()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
