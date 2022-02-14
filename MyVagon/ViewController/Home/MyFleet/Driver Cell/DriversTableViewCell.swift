//
//  DriversTableViewCell.swift
//  MyVagon
//
//  Created by Harsh Dave on 26/01/22.
//

import UIKit

class DriversTableViewCell: UITableViewCell {

    //MARK: ===== Outlets =======
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var lblLoaded: themeLabel!
    @IBOutlet weak var lblAssigned: themeLabel!
    @IBOutlet weak var lblAvailable: themeLabel!
    
    
    var clickEdit : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBAction func btnActionEdit(_ sender: UIButton) {
        if let clicked = clickEdit {
            clicked()
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewContent.layoutIfNeeded()
        self.viewContent.layer.cornerRadius = 15
        self.viewContent.layer.masksToBounds = true

        let bezierPath = UIBezierPath.init(roundedRect: self.viewContent.bounds, cornerRadius: 15)
        self.viewContent.layer.shadowPath = bezierPath.cgPath
        self.viewContent.layer.masksToBounds = false
        self.viewContent.layer.shadowColor = UIColor.darkGray.cgColor
        self.viewContent.layer.shadowRadius = 3.0
        self.viewContent.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.viewContent.layer.shadowOpacity = 0.2

        // sending viewContainer color to the viewContents.
       // let backgroundCGColor =
        //You can set your color directly if you want by using below two lines. In my case I'm copying the color.
        self.viewContent.backgroundColor = nil
        self.viewContent.layer.backgroundColor =  UIColor.white.cgColor
        
        
        self.viewTop.layoutIfNeeded()
        self.viewTop.layer.cornerRadius = 15
        self.viewTop.layer.masksToBounds = true

        let bezierPathTop = UIBezierPath.init(roundedRect: self.viewTop.bounds, cornerRadius: 15)
        self.viewTop.layer.shadowPath = bezierPathTop.cgPath
        self.viewTop.layer.masksToBounds = false
        self.viewTop.layer.shadowColor = UIColor.darkGray.cgColor
        self.viewTop.layer.shadowRadius = 3.0
        self.viewTop.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.viewTop.layer.shadowOpacity = 0.2

        // sending viewContainer color to the viewContents.
       // let backgroundCGColor =
        //You can set your color directly if you want by using below two lines. In my case I'm copying the color.
        self.viewTop.backgroundColor = nil
        self.viewTop.layer.backgroundColor =  UIColor.white.cgColor

      
      }
    
    
}
