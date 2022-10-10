//
//  MyAccountSection.swift
//  MyVagon
//
//  Created by Dhanajay  on 21/06/22.
//

import Foundation
class MyAccountSection {
    var TitleName:String?
    var HaslanguageButton : Bool?
    init(Name:String,isLanguageButton:Bool) {
        self.TitleName = Name
        self.HaslanguageButton = isLanguageButton
    }
}
