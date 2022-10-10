//
//  ViewNotesPopupVC.swift
//  MyVagon
//
//  Created by Apple on 06/10/21.
//

import UIKit

class ViewNotesPopupVC: UIViewController {
    
    // MARK: - Propertise
    @IBOutlet weak var lblNotes: themeTextView!
    @IBOutlet weak var btnDone: themeButton!
    @IBOutlet weak var lblTitle: themeLabel!
    
    var noteString : String?
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetValue()
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setLocalization()
    }
    
    //MARK: - Custom methods
    @objc func changeLanguage(){
        self.setLocalization()
    }
    
    func setLocalization() {
        self.lblTitle.text = "Notes".localized
        btnDone.setTitle("Done".localized, for: .normal)
    }
    
    func SetValue() {
        lblNotes.text = noteString
    }
    
    // MARK: - IBAction methods
    @IBAction func btnDoneClick(_ sender: themeButton) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
}
