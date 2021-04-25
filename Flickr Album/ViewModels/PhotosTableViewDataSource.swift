//
//  PhotosTableViewDataSource.swift
//  Flickr Album
//
//  Created by Hassan on 24.4.2021.
//

import Foundation
import UIKit
import  LoadingPlaceholderView

class PhotosTableViewDataSource<CELL : UITableViewCell, T> : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- Variables
    var photosVM = PhotosVM()
    var spinner = UIActivityIndicatorView()
    var cellIdentifier : String!
    var items : [T]!
    var configureCell : (CELL, T) -> () = {_,_ in }
    
    
    init(cellIdentifier : String, items : [T], configureCell : @escaping (CELL, T) -> ()) {
        self.cellIdentifier = cellIdentifier
        self.items =  items
        self.configureCell = configureCell
    }
    
    //MARK:- UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
       
       let item = self.items[indexPath.row]
       self.configureCell(cell, item)
       return cell
    }
    
    //MARK:- UITableView Delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CELL
        
        print (indexPath.row)
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        
        if indexPath.row == items.count - 1
        {
            spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
            
            // Little delay to show activity indicator
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.photosVM.getMorePhotos {
                    self.spinner.stopAnimating()
                    tableView.tableFooterView = nil
                    tableView.tableFooterView?.isHidden = true
                    //tableView.reloadData()
                    
                }
            }
        }
    }
}
