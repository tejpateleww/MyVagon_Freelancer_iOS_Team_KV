//
//  StatusListCell.swift
//  MyVagon
//
//  Created by Admin on 10/08/21.
//

import UIKit

class StatusListCell: UICollectionViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblStatus.font = CustomFont.PoppinsRegular.returnFont(FontSize.size15.rawValue)
    }
}
