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
    var arrTruckEditData : [TruckDetails] = []
    var editTruckDetailViewModel = EditTruckViewModel()
    var truckType : String = ""
    var isFromEdit = false
    var isEditEnable = true
    var selectedIndex = 0
    var isEdit = true
    
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
        setNavigationBarInViewController(controller: self, naviColor: .clear, naviTitle: "Truck List", leftImage: NavItemsLeft.back.value, rightImages: [], isTranslucent: true, ShowShadow: true)
        self.registerNib()
        self.addNotificationObs()
        if isFromEdit{
            self.btnContinue.isHidden = false
            self.btnContinue.setTitle("Save", for: .normal)
        }
    }
    
    func setupData(){
        if isFromEdit{
            self.arrTruckEditData = SingletonClass.sharedInstance.UserProfileData?.vehicle?.truckDetails ?? []
        }else{
            self.arrtruckData = SingletonClass.sharedInstance.RegisterData.Reg_truck_data
        }
        self.tblTruckList.reloadData()
        if !isFromEdit{
        self.checkContinue()
        }
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
        if isFromEdit{
            controller.isToAdd = true
        }
        self.isEdit = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        if isFromEdit{
            if arrTruckEditData.count > 0{
                self.callWebService()
            }
        }else{
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
}

extension RegisterTruckListVC{
    
    func callWebService(){
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonString = try! encoder.encode(getReqModel())
        print(String(data: jsonString, encoding: .utf8)!)
        let finalJson = String(data: jsonString, encoding: .utf8)!
        let reqModel = EditTruckReqModel()
        reqModel.truck_details = finalJson

        self.editTruckDetailViewModel.callWebserviceForEditTruck(reqModel: reqModel)
    }
    
    func getReqModel() -> [TruckEditReqModel] {
        var array = [TruckEditReqModel]()
        for i in arrTruckEditData{
            let temp = TruckEditReqModel()
            temp.truck_type = i.truckType?.id
            temp.id = i.id
            temp.plate_number = i.plateNumber
            temp.truck_sub_category = i.truckSubCategory?.id
            temp.truck_features = i.truckFeatures
            temp.weight = i.weight
            temp.weight_unit = i.weightUnit?.id
            temp.capacity = i.loadCapacity
            temp.capacity_unit = i.loadCapacityUnit?.id
            temp.images = i.images.map({$0})?.joined(separator: ",")
            temp.default_truck = i.defaultTruck
            array.append(temp)
        }
        return array
    }
}

//MARK: - UITableView Delegate and Data Sourse Methods
extension RegisterTruckListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromEdit{
            return (self.arrTruckEditData.count > 0) ? self.arrTruckEditData.count : 1
        }else{
            return (self.arrtruckData.count > 0) ? self.arrtruckData.count : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        if(self.arrtruckData.count > 0 || self.arrTruckEditData.count > 0){
            let cell = tblTruckList.dequeueReusableCell(withIdentifier: RegisterTruckCell.className) as! RegisterTruckCell
            cell.selectionStyle = .none
            if isFromEdit{
                cell.lbltruckType.text = self.arrTruckEditData[indexPath.row].truckType?.name
                cell.lblTruckNumber.text = self.arrTruckEditData[indexPath.row].plateNumber
                cell.btnDeleteClick = {
                    if self.arrTruckEditData.count > 1{
                    self.arrTruckEditData.remove(at: indexPath.row)
                    self.tblTruckList.reloadData()
                    }
                }
            }else{
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
            }
            return cell
        }else{
            let NoDatacell = self.tblTruckList.dequeueReusableCell(withIdentifier: "NoDataTableViewCell", for: indexPath) as! NoDataTableViewCell
            NoDatacell.lblNoDataTitle.text = "No Trucks Found"
            return NoDatacell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isFromEdit && arrTruckEditData.count > 0){
        let controller = AppStoryboard.Auth.instance.instantiateViewController(withIdentifier: AddTruckVC.storyboardID) as! AddTruckVC
        controller.isFromEdit = true
        controller.isEditEnable = false
        controller.truckIndex = indexPath.row
        self.selectedIndex = indexPath.row
        self.isEdit = true
        controller.editeData = { (data) in
            if self.isEdit{
                self.arrTruckEditData.remove(at: self.selectedIndex)
                self.arrTruckEditData.insert(data, at: self.selectedIndex)
            }else{
                self.arrTruckEditData.append(data)
            }
            self.tblTruckList.reloadData()
        }
        controller.truckEditDeta = arrTruckEditData[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.arrtruckData.count > 0 || self.arrTruckEditData.count > 0){
            return UITableView.automaticDimension
        }else{
            return tableView.frame.height
        }
        
    }
}
