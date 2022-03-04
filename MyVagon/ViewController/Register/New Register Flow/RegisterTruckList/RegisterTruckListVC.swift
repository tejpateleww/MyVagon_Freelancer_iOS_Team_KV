//
//  RegisterTruckListVC.swift
//  MyVagon
//
//  Created by Tej P on 02/03/22.
//

import UIKit

class RegisterTruckListVC: BaseViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tblTruckList: UITableView!
    @IBOutlet weak var btnAddTruck: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    var arrtruckData : [RegTruckDetailModel] = []
    var truckType : String = ""
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareView()
    }
    
    //MARK: - Custome methods
    func prepareView(){
        self.setupUI()
        self.setupData()
    }
    
    func setupUI(){
        self.tblTruckList.delegate = self
        self.tblTruckList.dataSource = self
        self.tblTruckList.separatorStyle = .none
        self.tblTruckList.showsHorizontalScrollIndicator = false
        self.tblTruckList.showsVerticalScrollIndicator = false
        
        self.registerNib()
        self.addNotificationObs()
    }
    
    func setupData(){
        self.arrtruckData = SingletonClass.sharedInstance.RegisterData.Reg_truck_data
        self.tblTruckList.reloadData()
        self.checkContinue()
    }
    
    func addNotificationObs(){
        NotificationCenter.default.removeObserver(self, name: .reloadRegTruckListScreen, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadScreen), name: .reloadRegTruckListScreen, object: nil)
    }
    
    func checkContinue(){
        if self.arrtruckData.count > 0 {
            self.btnContinue.isHidden = false
        }else{
            self.btnContinue.isHidden = true
        }
    }
    
    @objc func reloadScreen() {
        self.arrtruckData = SingletonClass.sharedInstance.RegisterData.Reg_truck_data
        self.tblTruckList.reloadData()
        self.checkContinue()
    }
    
    func registerNib(){
        let nib = UINib(nibName: RegisterTruckCell.className, bundle: nil)
        self.tblTruckList.register(nib, forCellReuseIdentifier: RegisterTruckCell.className)
        let nib3 = UINib(nibName: NoDataTableViewCell.className, bundle: nil)
        self.tblTruckList.register(nib3, forCellReuseIdentifier: NoDataTableViewCell.className)
    }
    
    //MARK: - UIButton action methods
    @IBAction func btnAddTruckAction(_ sender: Any) {
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: AddTruckVC.storyboardID) as! AddTruckVC
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        
        SingletonClass.sharedInstance.RegisterData.Reg_truck_data = self.arrtruckData
        UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
        UserDefault.SetRegiterData()
        UserDefault.synchronize()
        
        let RegisterMainVC = self.navigationController?.viewControllers.last as! RegisterAllInOneViewController
        let x = self.view.frame.size.width * 3
        RegisterMainVC.MainScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        RegisterMainVC.viewDidLayoutSubviews()
    }
}


//MARK: - UITableView Delegate and Data Sourse Methods
extension RegisterTruckListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrtruckData.count > 0) ? self.arrtruckData.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if(self.arrtruckData.count > 0){
            let cell = tblTruckList.dequeueReusableCell(withIdentifier: RegisterTruckCell.className) as! RegisterTruckCell
            cell.selectionStyle = .none
            
            for truck in SingletonClass.sharedInstance.TruckTypeList ?? []{
                if(truck.id ?? 0 == Int(self.arrtruckData[indexPath.row].truck_type)){
                    cell.lbltruckType.text = truck.name
                }
            }
            cell.lblTruckNumber.text = self.arrtruckData[indexPath.row].plate_number
            
            cell.btnDeleteClick = {
                self.arrtruckData.remove(at: indexPath.row)
                
                SingletonClass.sharedInstance.RegisterData.Reg_truck_data = self.arrtruckData
                UserDefault.setValue(2, forKey: UserDefaultsKey.UserDefaultKeyForRegister.rawValue)
                UserDefault.SetRegiterData()
                UserDefault.synchronize()
                
                self.tblTruckList.reloadData()
                self.checkContinue()
            }
            return cell
        }else{
            let NoDatacell = self.tblTruckList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            NoDatacell.lblNoDataTitle.text = "No Trucks Found"
            return NoDatacell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.arrtruckData.count > 0){
            return UITableView.automaticDimension
        }else{
            return tableView.frame.height
        }
        
    }
}
