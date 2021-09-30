//
//  statisticsCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class statisticsCell: UITableViewCell {

    @IBOutlet weak var lblNumber: themeLabel!
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblDetails: themeLabel!
    @IBOutlet weak var imgGreater: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
