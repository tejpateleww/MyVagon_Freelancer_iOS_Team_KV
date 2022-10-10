//
//  PostTruckBidsViewModel.swift
//  MyVagon
//
//  Created by Apple on 02/12/21.
//

import Foundation
import UIKit

class NewPostTruckBidsViewModel {
    weak var bidRequestViewController : PostedTruckBidRequestVC? = nil
    weak var bidRequestDetailViewController : PostedTruckBidReqDetailVC? = nil
    func BidRequest(ReqModel:PostTruckBidReqModel){
        WebServiceSubClass.BidRequest(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status {
                let tempArrHomeData = response?.data?.booking_request ?? []
                self.bidRequestViewController?.arrBidsData = tempArrHomeData
                self.bidRequestViewController?.lblMatchFount.text = "\("matchGreek".localized)\(tempArrHomeData.count) \("Matches_Found".localized)"
                self.bidRequestViewController?.isLoading = false
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//
//                }
                self.bidRequestViewController?.tblBidRequest.tableFooterView?.isHidden = true
                
                self.bidRequestViewController?.tblBidRequest.reloadDataWithAutoSizingCellWorkAround()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

class BidRequestViewModel {
    weak var scheduleVC : NewScheduleVC? = nil
 
    func BidRequest(ReqModel:PostTruckBidReqModel){
        Utilities.showHud()
        WebServiceSubClass.BidRequest(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status {
                let tempArrHomeData = response?.data?.booking_request ?? []
                let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: PostedTruckBidReqDetailVC.storyboardID) as! PostedTruckBidReqDetailVC
                controller.hidesBottomBarWhenPushed = true
                controller.LoadDetails = tempArrHomeData.first
                self.scheduleVC?.navigationController?.pushViewController(controller, animated: true)
                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
