//
//  RelatedMatchesVC.swift
//  MyVagon
//
//  Created by Dhanajay  on 22/03/22.
//

import UIKit

class RelatedMatchesVC: BaseViewController {

    @IBOutlet weak var tblRelatedData: UITableView!
    
    var driverId = ""
    var bookingId = ""
    var relodeMatchViewModel = RelatedMatchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    //MARK: - Custom methods
    func setupUI(){
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Related Matches", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
    }
    
    func setupData(){
        self.callWebService()
    }
    
}
// Web service
extension RelatedMatchesVC{
    func callWebService(){
        let reqModel = RelatedMatchReqModel()
        reqModel.booking_id = self.bookingId
        reqModel.driver_id = self.driverId
        self.relodeMatchViewModel.callWebServiceForRelatedMatchList(reqModal: reqModel)
    }
}
