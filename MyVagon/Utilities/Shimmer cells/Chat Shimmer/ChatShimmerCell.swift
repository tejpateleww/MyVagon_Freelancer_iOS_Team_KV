//
//  ChatShimmerCell.swift
//  MyVagon
//
//  Created by Tej P on 14/02/22.
//

import UIKit
import UIView_Shimmer

class ChatShimmerCell: UITableViewCell {
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var lblSender: UILabel!
    @IBOutlet weak var lblReceiver: UILabel!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.lblSender,
            self.lblReceiver
        ]
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        vwContainer.layer.masksToBounds = true
        vwContainer.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.200366896)
        vwContainer.layer.borderWidth = 1.0
        vwContainer.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
