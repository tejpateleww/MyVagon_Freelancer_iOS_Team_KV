//
//  MessageBarController.swift
//  HealthyBlackMen
//
//  Created by HealthyBlackMen on 10/05/17.
//  Copyright © 2017 HealthyBlackMen. All rights reserved.
//

import UIKit
import SwiftMessages

class MessageBarController: NSObject {
    
    
    func MessageShow(title : NSString , alertType : MessageView.Layout , alertTheme : Theme , TopBottom : Bool) -> Void {
        //Hide All popup when present any one popup
       // SwiftMessages.hideAll()
        
        //Top Bottom
        //1 = Top , 2 = Bottom
        
        let alert = MessageView.viewFromNib(layout: alertType)
        alert.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        alert.titleLabel?.numberOfLines = 0
        alert.bodyLabel?.font =  UIFont.systemFont(ofSize: 13)
        //SJ_Change :
        alert.bodyLabel?.numberOfLines = 6
        
        //Alert Type
        alert.configureTheme(alertTheme)
        alert.configureDropShadow()
        alert.button?.isHidden = true
        
        //Set title value
//       alertTheme.hashValue
        alert.configureContent(title: alertTheme == .success ? "Success".Localized() : "", body: title as String)

        var successConfig = SwiftMessages.Config()
        
        //Type for present popup is bottom or top
        (TopBottom == true) ? (successConfig.presentationStyle = .top):(successConfig.presentationStyle = .bottom)
        successConfig.duration = .seconds(seconds: 3.0)
        
        //Configaration with Start with status bar
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        
        SwiftMessages.show(config: successConfig, view: alert)
    }
}

