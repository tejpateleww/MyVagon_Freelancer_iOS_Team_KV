//
//  RemoveTruckDetailViewModel.swift
//  MyVagon
//
//  Created by Dhanajay  on 31/03/22.
//

import Foundation
class RemoveTruckDetailViewModel{
    
    var registerTruckListVC : RegisterTruckListVC?
    
    func callWebServiceToRemoveTruckDetail(req: RemoveTruckDetailReqModel,index: Int){
        Utilities.showHud()
        WebServiceSubClass.removeTruckDetail(reqModel: req) { (status, apiMessage, response, error) in
            Utilities.hideHud()
            if status{
                SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckDetails?.remove(at: index)
                UserDefault.setUserData()
                self.registerTruckListVC?.arrtruckData.remove(at: index)
                self.registerTruckListVC?.defaultTruckData.remove(at: index)
                self.registerTruckListVC?.tblTruckList.reloadData()
            }else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        }
    }
    
}
