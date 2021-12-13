//
//  PostedTruckBidsViewModel.swift
//  MyVagon
//
//  Created by Apple on 02/12/21.
//

import Foundation
import UIKit
class PostedTruckBidsViewModel {
    weak var postedTruckBidsViewController : PostedTruckBidsViewController? = nil

    
    func PostedTruckBid(ReqModel:PostTruckBidReqModel){
     
        WebServiceSubClass.PostedTruckBid(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
          
    
            if status {
                
                let tempArrHomeData = response?.data ?? []
                
                var datesArray = tempArrHomeData.compactMap({$0.date})
              
                datesArray = datesArray.uniqued()
                // let datesArray = self.MainSessionListArray.compactMap { $0.bookingDate} // return array of date
                var dic = [[SearchLoadsDatum]]() // Your required result
                
                datesArray.forEach { (element) in
                    
                    let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                    
                    
                    dic.append(NewDictonary)
                }
                self.postedTruckBidsViewController?.arrHomeData = dic
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.postedTruckBidsViewController?.isLoading = false
                }
                self.postedTruckBidsViewController?.tblLocations.tableFooterView?.isHidden = true
                
                
                
                self.postedTruckBidsViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
                
               // self.postedTruckBidsViewController?.tblLocations.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
