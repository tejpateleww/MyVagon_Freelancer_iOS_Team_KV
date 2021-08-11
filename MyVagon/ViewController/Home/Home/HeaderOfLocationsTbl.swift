//
//  HeaderOfLocationsTbl.swift
//  MyVagon
//


import UIKit

class HeaderOfLocationsTbl: UITableViewHeaderFooterView {

    //MARK:-  ======= Outlets =======
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let radius = viewStatus.frame.height / 2
        //headerView.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
    }
    

}
