//
//  NoBookingTblCell.swift
//  MyVagon
//
//  Created by Admin on 18/08/21.
//

import UIKit

class NoBookingTblCell: UITableViewCell {
    
    var isPostTruct : (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnPostClick(_ sender: themeButton) {
        if let click = self.isPostTruct{
            click()
        }
        
    }
}
