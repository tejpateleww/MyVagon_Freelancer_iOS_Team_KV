//
//  customRegisterBG.swift
//  HC Pro Doctor
//
//  Created by Apple on 04/11/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {
    @IBOutlet weak var lblChat: themeLabel!
    @IBOutlet weak var lblCount: themeLabel!
    @IBOutlet weak var UserImageView: UIImageView!
    @IBOutlet weak var ImageViewMainView: UIView!
    @IBOutlet weak var vWCount: ViewCustomClass!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vWCount.isHidden = true
    }
     var nibName: String = "NavigationTitleView"
    var contentView:UIView?
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask =
            [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
}
