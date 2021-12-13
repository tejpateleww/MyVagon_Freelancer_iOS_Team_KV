//
//  HeaderOfLocationsTbl.swift
//  MyVagon
//


import UIKit
import UIView_Shimmer

enum BidStatus:String {
    case all
    case pending
    case scheduled
    case inProgress
    case past
   
}

class HeaderOfLocationsTbl: UITableViewHeaderFooterView,ShimmeringViewProtocol {

    //MARK:-  ======= Outlets =======
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lblStatus: themeLabel!

    @IBOutlet weak var vwStatusShimmer: UIView!
    @IBOutlet weak var conHeightOfViewBidStatus: NSLayoutConstraint!
    @IBOutlet weak var LblShipperName: themeLabel!
    @IBOutlet weak var lblBidStatus: themeLabel!
    @IBOutlet weak var ViewStatusBidText: themeLabel!
    @IBOutlet weak var lblPrice: themeLabel!
    @IBOutlet weak var lblbookingID: themeLabel!
    @IBOutlet weak var lblDeadheadWithTruckType: themeLabel!
    @IBOutlet weak var lblWeightAndDistance: themeLabel!
    
    @IBOutlet weak var viewStatusBid: UIView!
    var bidStatus = BidStatus.all.rawValue
   
    var shimmeringAnimatedItems: [UIView]{
        [
            LblShipperName,
            viewStatusBid,
            lblbookingID,
            lblWeightAndDistance,
            lblDeadheadWithTruckType,
            lblPrice,
            vwStatusShimmer,
            lblBidStatus
        ]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewStatusBid.layer.cornerRadius = viewStatusBid.frame.height / 2
        viewStatusBid.clipsToBounds = true
        
        let radius = viewStatus.frame.height / 2
        //headerView.roundCorners(corners: [.topLeft,.topRight], radius: 15.0)
        viewStatus.roundCorners(corners: [.topLeft,.bottomLeft], radius: radius)
        
        
        
    }
    

}
