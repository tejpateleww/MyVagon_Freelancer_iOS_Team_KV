//
//  BidNowViewModel.swift
//  MyVagon
//
//  Created by Apple on 30/09/21.
//

import Foundation
import UIKit
import FittedSheets
class BidNowViewModel {
    weak var bidNowPopupViewController : BidNowPopupViewController? = nil
    
    func WebServiceBidPost(ReqModel:BidReqModel){
        Utilities.ShowLoaderButtonInButton(Button: bidNowPopupViewController?.BtnRight ?? themeButton(), vc: bidNowPopupViewController ?? UIViewController())
        WebServiceSubClass.BidPost(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.bidNowPopupViewController?.BtnRight ?? themeButton(), vc: self.bidNowPopupViewController ?? UIViewController())
            if status{
                self.bidNowPopupViewController?.dismiss(animated: true, completion: {
                    let controller = AppStoryboard.Popup.instance.instantiateViewController(withIdentifier: CommonAcceptRejectPopupVC.storyboardID) as! CommonAcceptRejectPopupVC
                 
                    let TitleAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
                    
                    let DescriptionAttribute = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1), NSAttributedString.Key.font: CustomFont.PoppinsMedium.returnFont(16)] as [NSAttributedString.Key : Any]
                    
                    controller.TitleAttributedText = NSAttributedString(string: "Bid placed of amount : \(Currency)\(ReqModel.amount ?? "")", attributes: TitleAttribute)
                    controller.DescriptionAttributedText = NSAttributedString(string: "You will get confirmation if shipper has decided to go with you. Till then keep booking loads", attributes: DescriptionAttribute)
                    controller.IsHideImage = true
                    controller.LeftbtnTitle = "Book more loads"
                    controller.RightBtnTitle = ""
                    controller.modalPresentationStyle = .overCurrentContext
                    controller.modalTransitionStyle = .coverVertical
                    controller.LeftbtnClosour = {
                        appDel.NavigateToHome()
                    }
                    controller.RightbtnClosour = {
                        
                        controller.view.backgroundColor = .clear
                        controller.dismiss(animated: true, completion: nil)
                    }
                 
                    let sheetController = SheetViewController(controller: controller,sizes: [.fixed(CGFloat(250) + appDel.GetSafeAreaHeightFromBottom())])
                    sheetController.dismissOnPull = false
                    sheetController.dismissOnOverlayTap = false
                    sheetController.allowPullingPastMaxHeight = false
                    UIApplication.topViewController()?.present(sheetController, animated: true, completion: nil)
                })
                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
