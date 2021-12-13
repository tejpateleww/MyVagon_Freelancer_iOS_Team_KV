//
//  Themes.swift
//  Danfo_Rider
//
//  Created by Hiral on 15/03/21.
//

import Foundation
import UIKit
import CountryPickerView
import SkyFloatingLabelTextField
import FSCalendar
import GrowingTextView



class ThemeButtonVerify : UIButton {
    
    @IBInspectable var isselectedbtn :  Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitleColor(isselectedbtn == true ? UIColor(hexString: "189B25"): UIColor.appColor(.themelightBlue), for: .normal)
         
        self.titleLabel?.font = CustomFont.PoppinsRegular.returnFont(16.0)
        }
      
    
    }

class GeneralPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var generalPickerDelegate: GeneralPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)


        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.generalPickerDelegate?.didTapDone()
    }

    
}
protocol GeneralPickerViewDelegate: AnyObject {
    func didTapDone()
    func didTapCancel()
}




class ThemeCalender : FSCalendar, FSCalendarDelegate {
    @IBInspectable var isMinimumDate : Bool = false
    @IBInspectable var DateForMinimum : Date = Date()
    @IBInspectable var CalenderScopeMonth : Bool = false
    @IBInspectable var CalenderHeaderBackground : Bool = false
    override func awakeFromNib() {
        self.backgroundColor = .white
        //UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
//        self.frame = CGRect(x: 100, y: 0, width: self.frame.width, height: self.frame.height)
        if !CalenderHeaderBackground {
            
        } else {
            self.calendarHeaderView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
            self.calendarWeekdayView.backgroundColor = UIColor(red: 247/255, green: 241/255, blue: 253/255, alpha: 1.0)
        }
        
        self.appearance.todaySelectionColor = UIColor.appColor(.themeColorForButton)
        self.allowsMultipleSelection = false
        self.appearance.headerTitleColor = UIColor(hexString: "#1F1F41")
        self.appearance.headerTitleFont = CustomFont.PoppinsRegular.returnFont(14.0)
        self.appearance.titleFont = CustomFont.PoppinsRegular.returnFont(12.0)
        self.appearance.weekdayFont = CustomFont.PoppinsMedium.returnFont(12.0)
        self.appearance.selectionColor = UIColor.appColor(.themeColorForButton);      self.appearance.titleSelectionColor = colors.white.value
        self.appearance.weekdayTextColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        self.appearance.headerDateFormat = "MMMM, yyyy"
        self.appearance.headerMinimumDissolvedAlpha = 0.0
        self.today = nil
        
        if CalenderScopeMonth {
            self.scope = .month
        } else {
            self.scope = .week
            
        }
       
        self.firstWeekday = 1
       // self.weekdayHeight = 40
        self.weekdayHeight = 40
        self.headerHeight = 30
        self.rowHeight = 40
       
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
        
        
        
    }
    
        
   
    
}

class ThemeSwitch : UISwitch {
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
        self.clipsToBounds = true
        self.onTintColor = #colorLiteral(red: 0.611544311, green: 0.2912456691, blue: 0.8909440637, alpha: 1)
            self.thumbTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.layer.cornerRadius = 16.0;

        
    }
}
class ChatthemeTextView: GrowingTextView {
    
    @IBInspectable public var isChat: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isChat {
            self.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            self.placeholderColor = UIColor.init(hexString: "#BABABA")
            self.textColor = UIColor.black
            self.layer.borderColor = UIColor.init(hexString: "#979797").withAlphaComponent(0.6).cgColor
            self.layer.borderWidth = 0.75
            self.layer.cornerRadius = 20
            
        } else {
            self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self.layer.cornerRadius = 5
        }
    }
}



class themeTextView : UITextView {
    override func awakeFromNib() {
        self.textColor =  #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.2549019608, alpha: 1)
        self.font = CustomFont.PoppinsRegular.returnFont(FontSize.size14.rawValue)
        self.layer.borderWidth = 1
        self.layer.borderColor =  hexStringToUIColor(hex: "#1F1F41").cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
