//
//  ShimmerCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 22/10/21.
//

import UIKit
import UIView_Shimmer

class ShimmerCell: UITableViewCell,ShimmeringViewProtocol {

    @IBOutlet weak var imgShimmer: UIImageView!
    @IBOutlet weak var lblShimmer: UILabel!
    @IBOutlet weak var lblShimmer1: UILabel!
    @IBOutlet weak var lblShimmer2: UILabel!
    var shimmeringAnimatedItems: [UIView]{
        [
            imgShimmer,
            lblShimmer,
            lblShimmer1,
            lblShimmer2
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
