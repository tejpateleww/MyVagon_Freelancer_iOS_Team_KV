//
//  LocationCell.swift
//  MyVagon
//
//  Created by Admin on 29/07/21.
//

import UIKit

class LocationCell: UITableViewCell {

    //MARK:-  Outlets ===
    @IBOutlet weak var viewLine: UIView!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
