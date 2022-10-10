//
//  NotificationListViewModel.swift
//  MyVagon
//
//  Created by Apple on 04/01/22.
//

import Foundation

import UIKit
class NotificationListViewModel {
    weak var notificationViewController : NotificationVC? = nil
    
    func WebServiceForNotificationList(){
       
        WebServiceSubClass.NotificationList(completion: { (status, apiMessage, response, error) in
           
            self.notificationViewController?.isTblReload = true
            self.notificationViewController?.isLoading = false
            DispatchQueue.main.async {
                self.notificationViewController?.refreshControl.endRefreshing()
            }
            
            if status{
                self.notificationViewController?.arrNotification = response?.data ?? []
                self.notificationViewController?.isLoading = false
            } else {
                Utilities.ShowAlertOfValidation(OfMessage: apiMessage)
            }
        })
    }

    
}
