//
//  UITableView+Extenstion.swift
//  TempleBliss
//
//  Created by Apple on 24/12/20.
//  Copyright © 2020 EWW071. All rights reserved.
//

import UIKit
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async { [self] in
            let indexPath = IndexPath(row: 0, section: 0)
            if hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    func noDataFound(lblText:String){
        let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text          = lblText
        noDataLabel.font = CustomFont.PoppinsRegular.returnFont(14)
        noDataLabel.textColor     = #colorLiteral(red: 0, green: 0.08235294118, blue: 0.3882352941, alpha: 1)
        noDataLabel.textAlignment = .center
        self.backgroundView  = noDataLabel
        self.separatorStyle  = .none
        
    }
}
extension UITableView {
  func reloadDataWithAutoSizingCellWorkAround() {
      self.reloadData()
      self.setNeedsLayout()
      self.layoutIfNeeded()
      self.reloadData()
  }
}
extension UITableViewController {
    func sizeHeaderToFit() {
        if let headerView = tableView.tableHeaderView {
            
            headerView.setNeedsLayout()
            headerView.layoutIfNeeded()
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            frame.size.height = height
            headerView.frame = frame
            
            tableView.tableHeaderView = headerView
        }
    }
    
    func sizeFooterToFit() {
        if let footerView = tableView.tableFooterView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = footerView.frame
            frame.size.height = height
            footerView.frame = frame
            
            tableView.tableFooterView = footerView
        }
    }
    
}
