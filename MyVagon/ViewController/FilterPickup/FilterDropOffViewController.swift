//
//  FilterDropOffViewController.swift
//  MyVagon
//
//  Created by Apple on 23/08/21.
//

import UIKit
import GooglePlaces
import CoreLocation

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


class FilterDropOffViewController: UIViewController,UITextFieldDelegate {

    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    var isForPickUp = false
    var selectedHaul : String = ""
    
    var ArrayForDropOffLocation : [ModelForDropOffLocation] = []
  
    var customTabBarController: CustomTabBarVC?
    var SelectedLocationClosour : ((CLLocationCoordinate2D,String,String)->())?
    var selectedLocation : (CLLocationCoordinate2D,String)?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var TblLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var TblLocation: UITableView!
    
    @IBOutlet weak var textFieldSearchLocation: themeTextfield!
    
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == textFieldSearchLocation {
            OpenPlacePicker()
            return false
        } 
        return true
    }
    
    func SetValue() {
        if isForPickUp {
            ArrayForDropOffLocation = [ModelForDropOffLocation(Title: "What distance around the selected cities are you willing to pick up a load?", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Short Haul", UptoKM: "(up to 50 KM)", IsSelected: true),SubModelForDropOffLocation(Title: "Medium Haul", UptoKM: "(up to 200 KM)", IsSelected: false),SubModelForDropOffLocation(Title: "Long Haul", UptoKM: "(over 200 KM)", IsSelected: false)])]
            //[ModelForDropOffLocation(Title: "Near you", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Athens", UptoKM: "", IsSelected: true),SubModelForDropOffLocation(Title: "Loannia", UptoKM: "", IsSelected: false)]),ModelForDropOffLocation(Title: "What distance around the selected cities are you willing to pick up a load?", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Short Haul", UptoKM: "(up to 50 KM)", IsSelected: true),SubModelForDropOffLocation(Title: "Medium Haul", UptoKM: "(up to 200 KM)", IsSelected: false),SubModelForDropOffLocation(Title: "Long Haul", UptoKM: "(over 200 KM)", IsSelected: false)])]
        } else {
            ArrayForDropOffLocation = [ModelForDropOffLocation(Title: "What distance around the selected cities are you willing to pick up a load?", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Short Haul", UptoKM: "(up to 50 KM)", IsSelected: true),SubModelForDropOffLocation(Title: "Medium Haul", UptoKM: "(up to 200 KM)", IsSelected: false),SubModelForDropOffLocation(Title: "Long Haul", UptoKM: "(over 200 KM)", IsSelected: false)])]
            //[ModelForDropOffLocation(Title: "Near you", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Athens", UptoKM: "", IsSelected: true),SubModelForDropOffLocation(Title: "Loannia", UptoKM: "", IsSelected: false)]),ModelForDropOffLocation(Title: "What distance around the selected cities are you willing to pick up a load?", SubModelForDropOffLocation: [SubModelForDropOffLocation(Title: "Short Haul", UptoKM: "(up to 50 KM)", IsSelected: true),SubModelForDropOffLocation(Title: "Medium Haul", UptoKM: "(up to 200 KM)", IsSelected: false),SubModelForDropOffLocation(Title: "Long Haul", UptoKM: "(over 200 KM)", IsSelected: false)])]
        }
        TblLocation.reloadData()
    }
    func OpenPlacePicker() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    
    @IBAction func BtnCancelAction(_ sender: themeButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BtnSubmitAction(_ sender: themeButton) {
        
        let CheckValidation = Validate()
        if CheckValidation.0 {
            
            if let click = self.SelectedLocationClosour {
                click(selectedLocation!.0, selectedLocation!.1,selectedHaul)
            }
            self.dismiss(animated: true, completion: nil)
            
        } else {
            Utilities.ShowAlertOfInfo(OfMessage: CheckValidation.1)
        }
        
      
       
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Validation ---------
    // ----------------------------------------------------
    func Validate() -> (Bool,String) {
        
          if textFieldSearchLocation.text == "" {
              return (false,(isForPickUp == true) ? "Please select pickup location" : "Please select dropoff location")
        }
        
       
        return (true,"")
    }

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
        if (ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].isSelected == true) {
            selectedHaul = ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].title ?? ""
        }
        
        if ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].uptoKM == "" {
            cell.LblDescripiton.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?.forEach({$0.isSelected = false})
        ArrayForDropOffLocation[indexPath.section].subModelForDropOffLocation?[indexPath.row].isSelected = true
        TblLocation.reloadData()
    }
    
}

extension FilterDropOffViewController: GMSAutocompleteViewControllerDelegate{
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if let vc = UIApplication.topViewController() {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectedLocation = (place.coordinate,place.formattedAddress ?? "")
        let tempAddres:String = "\(place.formattedAddress ?? "")"
         self.textFieldSearchLocation.text = tempAddres
        
        if let vc = UIApplication.topViewController() {
            vc.dismiss(animated: true, completion: nil)
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        if let vc = UIApplication.topViewController() {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}
