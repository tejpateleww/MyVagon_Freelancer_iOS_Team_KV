//
//  LocationCell.swift
//  MyVagon
//
//  Created by Admin on 29/07/21.
//

import UIKit
import UIView_Shimmer

class LocationCell: UITableViewCell,ShimmeringViewProtocol {

    //MARK:-  Outlets ===
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblDateTime: themeLabel!
    @IBOutlet weak var BtnShowMore: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    var shimmeringAnimatedItems: [UIView]{
        [
            viewLine,
            lblAddress,
            imgLocation,
            lblCompanyName,
            lblDateTime,
            BtnShowMore
        ]
    }
    
    var ShowMoreClosour : (() -> ())?
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func BtnShowMoreClick(_ sender: UIButton) {
        if let click = self.ShowMoreClosour {
            click()
        }
    }
}
