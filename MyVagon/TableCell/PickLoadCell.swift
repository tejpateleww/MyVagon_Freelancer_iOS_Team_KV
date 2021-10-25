//
//  PickLoadCell.swift
//  MyVagon
//
//  Created by Apple on 07/09/21.
//

import UIKit
import UIView_Shimmer

class PickLoadCell: UITableViewCell,ShimmeringViewProtocol {
    @IBOutlet weak var lblProductName: themeLabel!
    @IBOutlet weak var lblWeight: themeLabel!
    @IBOutlet weak var lblCapacity: themeLabel!
    @IBOutlet weak var lblType: themeLabel!
    @IBOutlet weak var btnNotes: themeButton!
    var shimmeringAnimatedItems: [UIView]{
        [
            lblProductName,
            lblWeight,
            lblCapacity,
            lblType,
            btnNotes
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
