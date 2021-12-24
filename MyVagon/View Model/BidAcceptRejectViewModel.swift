//
//  BidAcceptRejectViewModel.swift
//  MyVagon
//
//  Created by Apple on 20/12/21.
//

import Foundation
import UIKit
class BidAcceptRejectViewModel {
    weak var bidAcceptRejectViewController : BidAcceptRejectViewController? = nil
    weak var bidRequestViewController : BidRequestViewController? = nil
    weak var bidRequestDetailViewController : BidRequestDetailViewController? = nil

    
    func AcceptReject(ReqModel:BidAcceptRejectReqModel,isFromDetail:Bool = false){
        Utilities.ShowLoaderButtonInButton(Button: bidAcceptRejectViewController?.BtnRight ?? themeButton(), vc: bidAcceptRejectViewController ?? UIViewController())
        WebServiceSubClass.AcceptReject(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.bidAcceptRejectViewController?.BtnRight ?? themeButton(), vc: self.bidAcceptRejectViewController ?? UIViewController())
            self.bidAcceptRejectViewController?.dismiss(animated: true, completion: nil)

            if status {
                if ReqModel.status == "accept" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                    if isFromDetail {
                        self.bidRequestDetailViewController?.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.bidRequestViewController?.navigationController?.popViewController(animated: true)
                    }
                   
                } else if (response?.data?.booking_request?.count ?? 0) == 0 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                    if isFromDetail {
                        self.bidRequestDetailViewController?.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.bidRequestViewController?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    let tempArrHomeData = response?.data?.booking_request ?? []
                    
                    self.bidRequestViewController?.arrBidsData = tempArrHomeData
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.bidRequestViewController?.isLoading = false
                    }
                    self.bidRequestViewController?.tblAvailableData.tableFooterView?.isHidden = true
                    
                    self.bidRequestViewController?.tblAvailableData.reloadDataWithAutoSizingCellWorkAround()
                    
                }
                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    func RejectBooking(ReqModel:BidAcceptRejectReqModel,isFromDetail:Bool = false){
        Utilities.ShowLoaderButtonInButton(Button: bidAcceptRejectViewController?.BtnRight ?? themeButton(), vc: bidAcceptRejectViewController ?? UIViewController())
        WebServiceSubClass.AcceptReject(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.bidAcceptRejectViewController?.BtnRight ?? themeButton(), vc: self.bidAcceptRejectViewController ?? UIViewController())
            self.bidAcceptRejectViewController?.dismiss(animated: true, completion: nil)

            if status {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshViewForPostTruck"), object: nil, userInfo: nil)
                if isFromDetail {
                    self.bidRequestDetailViewController?.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.bidRequestViewController?.navigationController?.popViewController(animated: true)
                }
                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
