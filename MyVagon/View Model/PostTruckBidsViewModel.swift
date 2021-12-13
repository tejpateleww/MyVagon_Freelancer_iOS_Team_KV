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
    
    func PostedTruckBid(ReqModel:PostTruckBidReqModel){
     
        WebServiceSubClass.PostedTruckBid(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
          
    
            if status {
                
                let tempArrHomeData = response?.data ?? []
                
                self.bidRequestViewController?.arrBidsData = tempArrHomeData
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.bidRequestViewController?.isLoading = false
                }
                self.bidRequestViewController?.tblAvailableData.tableFooterView?.isHidden = true
                
                self.bidRequestViewController?.tblAvailableData.reloadDataWithAutoSizingCellWorkAround()
                
               // self.postedTruckBidsViewController?.tblLocations.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    func AcceptReject(ReqModel:BidAcceptRejectReqModel){
     
        WebServiceSubClass.AcceptReject(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
          
    
            if status {
                
                self.bidRequestViewController?.navigationController?.popViewController(animated: true)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    
}
