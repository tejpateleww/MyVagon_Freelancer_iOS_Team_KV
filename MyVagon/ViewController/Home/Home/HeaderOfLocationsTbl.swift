//
//  HeaderOfLocationsTbl.swift
//  MyVagon
//


import UIKit

class HeaderOfLocationsTbl: UITableViewHeaderFooterView {

    //MARK:-  ======= Outlets =======
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    @IBOutlet weak var conHeightOfViewBidStatus: NSLayoutConstraint!
    @IBOutlet weak var lblBidStatus: themeLabel!
    @IBOutlet weak var viewStatusBid: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewStatusBid.layer.cornerRadius = viewStatusBid.frame.height / 2
        viewStatusBid.clipsToBounds = true
        let radius = viewStatus.frame.height / 2
        //headerView.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
    }
    

}
