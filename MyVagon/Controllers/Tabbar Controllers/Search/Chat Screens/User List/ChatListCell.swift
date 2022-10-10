//
//  ChatListCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit
import UIView_Shimmer

class ChatListCell: UITableViewCell {

    //MARK: - Propertise
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: themeLabel!
    @IBOutlet weak var lblDate: themeLabel!
    @IBOutlet weak var lblMessage: themeLabel!
    @IBOutlet weak var lblNoOfMessage: themeLabel!
    @IBOutlet weak var vwNumber: UIView!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.imgProfile,
            self.lblName,
            self.lblDate,
            self.lblMessage,
        ]
    }
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwNumber.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
