//
//  MakeAsDefaultTruckViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 07/04/22.
//

import Foundation
class MakeAsDefaultTruckViewModel{
    
    var registerTruckListVC: RegisterTruckListVC?
    
    func callWebServiceToMakeDefaultTruck(req: MakeAsDefaultTruckReqModel,index: Int){
        Utilities.showHud()
        WebServiceSubClass.makeAsDefaultTruck(reqModel: req) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                self.registerTruckListVC?.arrtruckData[index].default_truck = "1"
                self.registerTruckListVC?.defaultTruckData[index].default_truck = "1"
                SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckDetails?[index].defaultTruck = 1
                self.registerTruckListVC?.arrtruckData[self.registerTruckListVC?.defaultTruckIndex ?? Int()].default_truck = "0"
                self.registerTruckListVC?.defaultTruckData[self.registerTruckListVC?.defaultTruckIndex ?? Int()].default_truck = "0"
                SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckDetails?[self.registerTruckListVC?.defaultTruckIndex ?? Int()].defaultTruck = 0
                self.registerTruckListVC?.defaultTruckIndex = index
                UserDefault.setUserData()
                self.registerTruckListVC?.tblTruckList.reloadData()
            }else{
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
}
 
