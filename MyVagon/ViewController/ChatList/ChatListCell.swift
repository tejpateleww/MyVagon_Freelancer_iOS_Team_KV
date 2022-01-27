//
//  ChatListCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class ChatListCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblDate: themeLabel!
    @IBOutlet weak var lblMessage: themeLabel!
    @IBOutlet weak var lblNoOfMessage: themeLabel!
    @IBOutlet weak var vwNumber: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.vwNumber.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
