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
        self.homeViewController?.isNeedToReload = false
        WebServiceSubClass.GetShipmentList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.hideHud()
            self.homeViewController?.refreshControl.endRefreshing()
            if status {
                let numberOfCount = response?.data?.count ?? 0
                if numberOfCount == PageLimit {
                    self.homeViewController?.isNeedToReload = true
                }
                else {
                    self.homeViewController?.isNeedToReload = false
                }
                if ReqModel.page == "1" {
                    let tempArrHomeData = response?.data ?? []
                    
                    var datesArray = tempArrHomeData.compactMap({$0.date})
                  
                    datesArray = datesArray.uniqued()
                    // let datesArray = self.MainSessionListArray.compactMap { $0.bookingDate} // return array of date
                    var dic = [[SearchLoadsDatum]]() // Your required result
                    
                    datesArray.forEach { (element) in
                        
                        let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                        
                        
                        dic.append(NewDictonary)
                    }
                    self.homeViewController?.arrHomeData = dic
                    
                } else {
                    var tempArrHomeData = [SearchLoadsDatum]()
                    self.homeViewController?.arrHomeData?.forEach({ element in
                        tempArrHomeData.append(contentsOf: element)
                    })
                     
                    tempArrHomeData.append(contentsOf: response?.data ?? [])
                   
                    var datesArray = tempArrHomeData.compactMap({$0.date})
                  
                    datesArray = datesArray.uniqued()
                    // let datesArray = self.MainSessionListArray.compactMap { $0.bookingDate} // return array of date
                    var dic = [[SearchLoadsDatum]]() // Your required result
                    
                    datesArray.forEach { (element) in
                        
                        let NewDictonary =  tempArrHomeData.filter({$0.date == element})
                        
                        
                        dic.append(NewDictonary)
                    }
                    self.homeViewController?.arrHomeData = dic
                    
                    
                    
                   
                }
                self.homeViewController?.isLoading = false
                self.homeViewController?.tblLocations.tableFooterView?.isHidden = true
                
                
                
                self.homeViewController?.tblLocations.reloadDataWithAutoSizingCellWorkAround()
                
               // self.homeViewController?.tblLocations.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
  
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
