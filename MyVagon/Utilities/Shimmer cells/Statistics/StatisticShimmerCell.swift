//
//  StatisticShimmerCell.swift
//  MyVagon
//
//  Created by Tej P on 21/02/22.
//

import UIKit
import UIView_Shimmer

class StatisticShimmerCell: UITableViewCell, ShimmeringViewProtocol {
    
    @IBOutlet weak var vWContainer: UIView!
    @IBOutlet weak var lblCount: themeLabel!
    @IBOutlet weak var lblDesc: themeLabel!
    @IBOutlet weak var ImgArrow: UIImageView!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.lblCount,
            self.lblDesc,
            self.ImgArrow
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vWContainer.layer.masksToBounds = true
        vWContainer.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.200366896)
        vWContainer.layer.borderWidth = 1.0
        vWContainer.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
