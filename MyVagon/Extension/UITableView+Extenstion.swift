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
}
extension UITableView {
  func reloadDataWithAutoSizingCellWorkAround() {
      self.reloadData()
      self.setNeedsLayout()
      self.layoutIfNeeded()
      self.reloadData()
  }
}
