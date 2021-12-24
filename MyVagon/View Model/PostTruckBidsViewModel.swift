//
//  PostTruckBidsViewModel.swift
//  MyVagon
//
//  Created by Apple on 02/12/21.
//

import Foundation
import UIKit
class PostTruckBidsViewModel {
    weak var bidRequestViewController : BidRequestViewController? = nil
    weak var bidRequestDetailViewController : BidRequestDetailViewController? = nil
 
    func BidRequest(ReqModel:PostTruckBidReqModel){
     
        WebServiceSubClass.BidRequest(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
          
    
            if status {
                
                let tempArrHomeData = response?.data?.booking_request ?? []
                
                self.bidRequestViewController?.arrBidsData = tempArrHomeData
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.bidRequestViewController?.isLoading = false
                }
                self.bidRequestViewController?.tblAvailableData.tableFooterView?.isHidden = true
                
                self.bidRequestViewController?.tblAvailableData.reloadDataWithAutoSizingCellWorkAround()

                
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
