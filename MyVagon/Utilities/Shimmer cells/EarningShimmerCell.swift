//
//  EarningShimmerCell.swift
//  MyVagon
//
//  Created by Tej P on 31/01/22.
//

import UIKit
import UIView_Shimmer

class EarningShimmerCell: UITableViewCell {
    
    @IBOutlet weak var VWContainer: UIView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    @IBOutlet weak var lbl5: UILabel!
    @IBOutlet weak var lbl6: UILabel!
    @IBOutlet weak var lbl7: UILabel!
    @IBOutlet weak var lbl8: UILabel!
    @IBOutlet weak var vwDotted: DottedLineView!
    
    var shimmeringAnimatedItems: [UIView] {
        [
            self.img2,
            self.img3,
            self.lbl1,
            self.lbl2,
            self.lbl4,
            self.lbl5,
            self.lbl6,
            self.lbl7,
            self.lbl8,
            self.vwDotted
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.VWContainer.layer.cornerRadius = 15
        self.VWContainer.layer.borderWidth = 1
        self.VWContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
