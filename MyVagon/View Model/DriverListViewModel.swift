//
//  DriverListViewModel.swift
//  MyVagon
//
//  Created by Apple on 18/10/21.
//

import Foundation
import UIKit
class DriverListViewModel {
    weak var driversViewController : DriversViewController? = nil
    weak var changePermissionViewController : ChangePermissionViewController? = nil
    
    func GetDriverList(ReqModel:GetDriverListReqModel){
        
        self.driversViewController?.refreshControl.endRefreshing()
        WebServiceSubClass.GetDriverList(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            if status {
                self.driversViewController?.arrDriverList = response?.data
                self.driversViewController?.tblDrivers.reloadData()
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
    
    
    func UpdatePermissionSettings(ReqModel:ChangePermissionReqModel){
        Utilities.ShowLoaderButtonInButton(Button: changePermissionViewController?.btnSave ?? themeButton(), vc: changePermissionViewController ?? UIViewController())
        WebServiceSubClass.PermissionSettings(reqModel: ReqModel, completion: { (status, apiMessage, response, error) in
            Utilities.HideLoaderButtonInButton(Button: self.changePermissionViewController?.btnSave ?? themeButton(), vc: self.changePermissionViewController ?? UIViewController())
            if status {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetDriverList"), object: nil, userInfo: nil)
                Utilities.ShowAlertOfSuccess(OfMessage: apiMessage)
                self.changePermissionViewController?.navigationController?.popViewController(animated: true)
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }
}
