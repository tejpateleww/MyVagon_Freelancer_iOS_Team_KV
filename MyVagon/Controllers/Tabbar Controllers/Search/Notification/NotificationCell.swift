//
//  NotificationCell.swift
//  MyVagon
//
//  Created by Dhanajay  on 21/06/22.
//

import UIKit
class NotificationCell : UITableViewCell {
    
    //MARK: - Propertise
    @IBOutlet weak var LblTitle: themeLabel!
    @IBOutlet weak var LblDate: themeLabel!
    @IBOutlet weak var LblDescription: themeLabel!
    @IBOutlet weak var LblCount: themeLabel!
    
    //MARK: - Life cycle method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.LblCount.isHidden = true
    }
}
