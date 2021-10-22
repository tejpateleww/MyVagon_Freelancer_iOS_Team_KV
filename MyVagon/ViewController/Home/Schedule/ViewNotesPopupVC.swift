//
//  ViewNotesPopupVC.swift
//  MyVagon
//
//  Created by Apple on 06/10/21.
//

import UIKit

class ViewNotesPopupVC: UIViewController {

    
    // ----------------------------------------------------
    // MARK: - --------- Variables ---------
    // ----------------------------------------------------
    
    
   
    var noteString : String?
    // ----------------------------------------------------
    // MARK: - --------- IBOutlets ---------
    // ----------------------------------------------------
    
    
    @IBOutlet weak var lblNotes: themeLabel!
    
    @IBOutlet weak var btnDone: themeButton!
    
    // ----------------------------------------------------
    // MARK: - --------- Life-cycle Methods ---------
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
        SetValue()
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
    //    MainView.roundCorners(corners: [.topLeft,.topRight], radius: 30)
    }
    
    // ----------------------------------------------------
    // MARK: - --------- Custom Methods ---------
    // ----------------------------------------------------
    
    func SetValue() {
        
        lblNotes.text = noteString
    }
   
    // ----------------------------------------------------
    // MARK: - --------- IBAction Methods ---------
    // ----------------------------------------------------
    @IBAction func btnDoneClick(_ sender: themeButton) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
        
    }
    
   
    
    // ----------------------------------------------------
    // MARK: - --------- Webservice Methods ---------
    // ----------------------------------------------------
 

}
