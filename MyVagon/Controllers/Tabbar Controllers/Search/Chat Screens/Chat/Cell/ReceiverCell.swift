//
//  ReceiverCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 24/08/21.
//

import UIKit
import UIView_Shimmer

class ReceiverCell: UITableViewCell {

    //MARK: - Propertise
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: themeLabel!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.lblMessage,
            self.lblDate,
        ]
    }
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
