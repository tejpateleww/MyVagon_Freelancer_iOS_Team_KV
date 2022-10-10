//
//  NotificationListData.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/06/22.
//

import Foundation
class NotificationData : NSObject {
    
    var title : String!
    var isSelect : Bool!
    
    init(Title : String , IsSelect : Bool) {
        self.title = Title
        self.isSelect = IsSelect
    }
}
