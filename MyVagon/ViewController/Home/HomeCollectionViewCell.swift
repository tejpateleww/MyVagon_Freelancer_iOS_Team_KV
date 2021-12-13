//
//  HomeCollectionViewCell.swift
//  MyVagon
//
//  Created by Admin on 10/08/21.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    //MARK:- ======= Outlets =========
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblStatus.font = CustomFont.PoppinsRegular.returnFont(FontSize.size15.rawValue)
    }

}
