//
//  NotificationListViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/01/22.
//

import Foundation

import UIKit
class NotificationListViewModel {
    weak var notificationViewController : NotificationViewController? = nil
    
    func WebServiceForNotificationList(){
       
        WebServiceSubClass.NotificationList(completion: { (status, apiMessage, response, error) in
           
            if status{
                self.notificationViewController?.arrNotification = response?.data ?? []
                self.notificationViewController?.isLoading = false
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
