//
//  HomeViewModel.swift
//  MyVagon
//
//  Created by Apple on 16/09/21.
//

import Foundation

import UIKit
class HomeViewModel {
    weak var homeViewController : HomeViewController? = nil
    
    func GetShipmentList(ReqModel:ShipmentListReqModel){
        WebServiceSubClass.GetShipmentList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            
            self.homeViewController?.refreshControl.endRefreshing()
            if status {
                self.homeViewController?.arrHomeData = response?.data
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.homeViewController?.isLoading = false
                }
                self.homeViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
                
               // self.homeViewController?.tblLocations.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}

