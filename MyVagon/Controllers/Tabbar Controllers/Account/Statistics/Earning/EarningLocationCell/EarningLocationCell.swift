//
//  EarningLocationCell.swift
//  MyVagon
//
//  Created by Tej P on 28/01/22.
//

import UIKit

class EarningLocationCell: UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblCompanyName: themeLabel!
    @IBOutlet weak var lblAddress: themeLabel!
    @IBOutlet weak var lblDateTime: themeLabel!
    @IBOutlet weak var imgLocation: UIImageView!

    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
