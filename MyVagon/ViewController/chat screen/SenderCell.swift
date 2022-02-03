//
//  SenderCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 24/08/21.
//

import UIKit
import UIView_Shimmer

class SenderCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: themeLabel!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.lblMessage,
            self.lblDate
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
