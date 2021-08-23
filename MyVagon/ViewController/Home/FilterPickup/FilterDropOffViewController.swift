//
//  FilterDropOffViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit

class SubModelForDropOffLocation : NSObject {
    var title:String!
    var uptoKM:String!
    var isSelected:Bool = false
    
    init(Title:String,UptoKM:String,IsSelected:Bool) {
        self.title = Title
        self.uptoKM = UptoKM
        self.isSelected = IsSelected
    }
}
class ModelForDropOffLocation : NSObject {
    var title:String!
    var subModelForDropOffLocation:[SubModelForDropOffLocation]?
   
    init(Title:String,SubModelForDropOffLocation:[SubModelForDropOffLocation]) {
        self.title = Title
        self.subModelForDropOffLocation = SubModelForDropOffLocation
    }
}

class DropOffLocationCell : UITableViewCell {
    @IBOutlet weak var LblTitle: themeLabel!
    @IBOutlet weak var LblDescripiton: themeLabel!
    @IBOutlet weak var ButtonSelect: UIButton!
    override func awakeFromNib() {
        ButtonSelect.isUserInteractionEnabled = false
    }
    @IBAction func ButtonSelectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
       
    }
}


class FilterDropOffViewController: UIViewController {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var isForPickUp = false
    
    
    var ArrayForDropOffLocation : [ModelForDropOffLocation] = []
  
    var customTabBarController: CustomTabBarVC?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TblLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var TblLocation: UITableView!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController != nil {
            self.customTabBarController = (self.tabBarController as! CustomTabBarVC)
        }
        if TblLocation.observationInfo != nil {
            self.TblLocation.removeObserver(self, forKeyPath: "contentSize")
        }
        self.TblLocation.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        SetValue()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.customTabBarController?.hideTabBar()
    }
  
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        MainView.layer.cornerRadius = 30
        // Call the roundCorners() func right there.
        //        MainView.roundCorners(corners: [ .topRight], radius: 30)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                if newsize.height > UIScreen.main.bounds.height / 2 {
                    self.TblLocationHeight.constant = UIScreen.main.bounds.height / 2
                } else {
                    self.TblLocationHeight.constant = newsize.height
                }
            }
        }
    }
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        if isForPickUp {
            ArrayForDropOffLocation = [ModelForDropOffLocation(Title: "Near you", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Athens", UptoKM: "", IsSelected: true),SubModelForDropOffLocation(Title: "Loannia", UptoKM: "", IsSelected: false)]),ModelForDropOffLocation(Title: "What distance around the selected cities are you willing to pick up a load?", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Short Haul", UptoKM: "(up to 50 KM)", IsSelected: true),SubModelForDropOffLocation(Title: "Medium Haul", UptoKM: "(up to 200 KM)", IsSelected: false),SubModelForDropOffLocation(Title: "Long Haul", UptoKM: "(over 200 KM)", IsSelected: false)])]
        } else {
            ArrayForDropOffLocation = [ModelForDropOffLocation(Title: "Near you", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Athens", UptoKM: "", IsSelected: true),SubModelForDropOffLocation(Title: "Loannia", UptoKM: "", IsSelected: false)]),ModelForDropOffLocation(Title: "What distance around the selected cities are you willing to pick up a load?", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Short Haul", UptoKM: "(up to 50 KM)", IsSelected: true),SubModelForDropOffLocation(Title: "Medium Haul", UptoKM: "(up to 200 KM)", IsSelected: false),SubModelForDropOffLocation(Title: "Long Haul", UptoKM: "(over 200 KM)", IsSelected: false)])]
        }
        TblLocation.reloadData()
    }
    
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnSubmitAction(_ sender: themeButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------


}
// ----------------------------------------------------
// MARK: ---------- TableView Methods ---------
// ----------------------------------------------------
extension FilterDropOffViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ArrayForDropOffLocation.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArrayForDropOffLocation[section].subModelForDropOffLocation?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TblLocation.dequeueReusableCell(withIdentifier: "DropOffLocationCell", for: indexPath) as! DropOffLocationCell
        cell.LblTitle.text = ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].title
        cell.LblDescripiton.text = ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].uptoKM
        
        cell.ButtonSelect.isSelected = (ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].isSelected == true) ? true : false
        
        if ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].uptoKM == "" {
            cell.LblDescripiton.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
            headerView.backgroundColor = UIColor(hexString: "#FFFFFF")
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
            label.center = CGPoint(x: headerView.frame.size.width / 2, y: headerView.frame.size.height / 2)
            label.text = ArrayForDropOffLocation[section].title
            label.textAlignment = .left
            label.font = CustomFont.PoppinsRegular.returnFont(FontSize.size12.rawValue)
            label.textColor = #colorLiteral(red: 0.6978102326, green: 0.6971696019, blue: 0.7468633652, alpha: 1)
            headerView.addSubview(label)
            
            return headerView
        } else {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
            headerView.backgroundColor = UIColor(hexString: "#FFFFFF")
            let label = UILabel()
            label.frame = CGRect.init(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
            label.center = CGPoint(x: headerView.frame.size.width / 2, y: (headerView.frame.size.height / 2)+10)
            label.text = ArrayForDropOffLocation[section].title
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = CustomFont.PoppinsRegular.returnFont(FontSize.size14.rawValue)
            label.textColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1)
    
            headerView.addSubview(label)
            
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?.forEach({$0.isSelected = false})
        ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].isSelected = true
        
        TblLocation.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 80
        }
    }
    
}
