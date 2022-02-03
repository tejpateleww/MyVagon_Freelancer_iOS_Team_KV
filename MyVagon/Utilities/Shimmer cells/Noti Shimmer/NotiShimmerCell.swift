//
//  NotiShimmerCell.swift
//  Curbside Delivery
//
//  Created by Tej P on 29/11/21.
//

import UIKit
import UIView_Shimmer

class NotiShimmerCell: UITableViewCell, ShimmeringViewProtocol {
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vWImage: UIView!
    @IBOutlet weak var imgNoti: UIImageView!
    @IBOutlet weak var lblNotiTitle: UILabel!
    @IBOutlet weak var lblNotiDesc: UILabel!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.vWImage,
            self.lblNotiTitle,
            self.lblNotiDesc
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
