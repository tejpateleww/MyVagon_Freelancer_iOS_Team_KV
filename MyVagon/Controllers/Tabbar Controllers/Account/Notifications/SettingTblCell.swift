//
//  SettingTblCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/06/22.
//

import UIKit
class settingTblCell : UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSwitch: ThemeSwitch!
    
    var getSelectedStatus : (()->())?
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - IBAction method
    @IBAction func btnActionSwitch(_ sender: UISwitch) {
        if let selected = getSelectedStatus {
            selected()
        }
    }
}
