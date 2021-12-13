//
//  NoBookingView.swift
//  MyVagon
//
//  Created by Apple on 01/12/21.
//

import UIKit



class NoBookingView: UIView {
    var isPostTruct : (() -> ())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
       
    }
    
    @IBAction func btnPostClick(_ sender: themeButton) {
        if let click = self.isPostTruct{
            click()
        }
        
    }
}
