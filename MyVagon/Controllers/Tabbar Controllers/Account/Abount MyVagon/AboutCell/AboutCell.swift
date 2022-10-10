//
//  AboutCell.swift
//  MyVagon
//
//  Created by Tej P on 22/02/22.
//

import UIKit

class AboutCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var lblCategory: themeLabel!
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
