//
//  SearchLocationCell.swift
//  MyVagon
//
//  Created by Tej P on 01/02/22.
//

import UIKit

class SearchLocationCell: UITableViewCell {
    
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewHorizontalLine: DottedLineView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblDateTime: themeLabel!
    @IBOutlet weak var imgLocation: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
