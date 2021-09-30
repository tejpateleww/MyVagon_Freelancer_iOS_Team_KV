//
//  PickLoadCell.swift
//  MyVagon
//
//  Created by Apple on 07/09/21.
//

import UIKit

class PickLoadCell: UITableViewCell {
    @IBOutlet weak var lblProductName: themeLabel!
    @IBOutlet weak var lblWeight: themeLabel!
    @IBOutlet weak var lblCapacity: themeLabel!
    @IBOutlet weak var lblType: themeLabel!
    @IBOutlet weak var btnNotes: themeButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
