//
//  StatisticsOneVC.swift
//  MyVagon
//
//  Created by Harsh Dave on 25/08/21.
//

import UIKit

class StatisticsData {
    var number:String?
    var details:String?
    var color:UIColor?
    
    init(Number:String,Details:String,Color:UIColor) {
        self.number = Number
        self.details = Details
        self.color = Color
    }
}

class StatisticsOneVC: BaseViewController {

    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    var ArrayStatistics : [StatisticsData] = [StatisticsData(Number: "81", Details: "LOADS/WEEK", Color: #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)),
                                              StatisticsData(Number: "$25", Details: "/km/week", Color: #colorLiteral(red: 0.8640190959, green: 0.6508947015, blue: 0.1648262739, alpha: 1)),
                                              StatisticsData(Number: "21", Details: "Deadhead", Color: #colorLiteral(red: 0.8429378271, green: 0.4088787436, blue: 0.4030963182, alpha: 1)),
                                              StatisticsData(Number: "45", Details: "EUR carbon saved", Color: #colorLiteral(red: 0.3038921356, green: 0.5736817122, blue: 0.8892048597, alpha: 1))]
    
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var tblStatistics: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblStatistics.delegate = self
        tblStatistics.dataSource = self
        tblStatistics.reloadData()
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Statistics", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true)
        // Do any additional setup after loading the view.
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
    
    
    
    
    
    
    
   
    
}

// ----------------------------------------------------
// MARK: - --------- TableView Methods ---------
// ----------------------------------------------------

extension StatisticsOneVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayStatistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:statisticsCell = tblStatistics.dequeueReusableCell(withIdentifier: statisticsCell.className) as! statisticsCell
        cell.vwMain.backgroundColor = ArrayStatistics[indexPath.row].color?.withAlphaComponent(0.13)
        cell.lblNumber.text = ArrayStatistics[indexPath.row].number?.uppercased()
        cell.lblNumber.fontColor = ArrayStatistics[indexPath.row].color ?? #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        cell.lblDetails.text = ArrayStatistics[indexPath.row].details?.uppercased()
        cell.lblDetails.fontColor = ArrayStatistics[indexPath.row].color ?? #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        cell.imgGreater.tintColor = ArrayStatistics[indexPath.row].color
       
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: ReviewShipperVC.storyboardID) as! ReviewShipperVC
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
        
        
        
        
        
    }
    
}
