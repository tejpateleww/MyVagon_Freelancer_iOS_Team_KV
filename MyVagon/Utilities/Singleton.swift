//
//  Singleton.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 09/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
class SingletonClass: NSObject
{
    var SelectedLanguage : String = ""
    
    static let sharedInstance = SingletonClass()
    
   
    
    func clearSingletonClass() {
        
      
        
    }
    
    
}
