//
//  BidRequestTblCell.swift
//  MyVagon
//
//  Created by Admin on 13/08/21.
//

import UIKit

class BidRequestTblCell: UITableViewCell {

    
    //MARK:-  Outlets ===
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var btnBidRequest: UIButton!
    @IBOutlet weak var conHeightOfButton: NSLayoutConstraint!
    @IBOutlet weak var bottomHeightBtn: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
