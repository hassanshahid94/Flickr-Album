//
//  PhotosVC.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import UIKit
import SnapKit
import SDWebImage
import LoadingPlaceholderView

class PhotosVC: UIViewController {

    //MARK:- Variables
    var isSearch = false
    var arrFliterResult = [FlickrAlbumPhoto]()
    var spinner = UIActivityIndicatorView()
    var photosVM : PhotosVM!
    var loadingPlaceholderView = LoadingPlaceholderView()
    var cellsIdentifiers = [
        "PhotosTCell",
        "PhotosTCell",
        "PhotosTCell",
        "PhotosTCell"
    ]
    
    //MARK:- Variables for Outlets/UI
    var lblHeading: UILabel!
    var txtSearch: UISearchBar!
    var tblPhotos: UITableView!{
        didSet {
            tblPhotos.coverableCellsIdentifiers = cellsIdentifiers
        }
    }
    
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        photosVM =  PhotosVM()
        configureUI()
        callToViewModelForUIUpdate()
    }
    

    //MARK:- Functions
    func configureUI() {
        
        // Adding a Label Heading Programtically
        lblHeading = UILabel()
        lblHeading.text = "Flickr Album"
        lblHeading.textColor = UIColor.FlickrAlbum_theme
        lblHeading.textAlignment = .center
        lblHeading.font = UIFont.FlickAlbum_heading
        self.view.addSubview(lblHeading)
        lblHeading.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self.view.frame.width * 0.95)
            make.topMargin.equalTo(10)
            make.centerXWithinMargins.equalToSuperview()
        }
        
        // Adding a search bar Programtically
        txtSearch = UISearchBar()
        txtSearch.searchBarStyle = .minimal
        txtSearch.placeholder = "Search"
        txtSearch.searchTextField.font = UIFont.FlickAlbum_description
        txtSearch.delegate = self
        self.view.addSubview(txtSearch)
        txtSearch.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(lblHeading.snp.width)
            make.top.equalTo(lblHeading.snp.bottom).offset(10)
            make.centerXWithinMargins.equalToSuperview()
        }
        
        // Adding a TableView Programtically
        tblPhotos = UITableView()
        tblPhotos.separatorStyle = .singleLine
        tblPhotos.rowHeight = 300
        tblPhotos.separatorStyle = .none
        // You must register the cell with a reuse identifier
        tblPhotos.register(PhotosTCell.self, forCellReuseIdentifier: "PhotosTCell")
        tblPhotos.dataSource = self
        tblPhotos.delegate = self
        self.view.addSubview(tblPhotos)
        tblPhotos.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(txtSearch.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(10)
            make.centerXWithinMargins.equalToSuperview()
        }
    }
    
    func callToViewModelForUIUpdate(){
        
        setupLoadingPlaceholderView()
        performFakeNetworkRequest()
        photosVM.bindPhotosVMToController = {
            self.tblPhotos.reloadData()
        }
    }
    func performFakeNetworkRequest() {
        loadingPlaceholderView.cover(view)
    }

    func finishFakeRequest() {
        loadingPlaceholderView.uncover()
    }

    func setupLoadingPlaceholderView() {
        
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
    }
}

//MARK:- UITableView DataSource
extension PhotosVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isSearch
        {
            return arrFliterResult.count
        }
        else{
            return photosVM.albumData == nil ? 0 : photosVM.albumData.photos!.photo!.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTCell", for: indexPath) as! PhotosTCell
        
        if isSearch{
            
            cell.lblTitle.text = arrFliterResult[indexPath.row].title == "" ? "N/A" : arrFliterResult[indexPath.row].title
            
            let picURL = "\(Constants.imgURL)\(arrFliterResult[indexPath.row].server ?? "")/\(String(describing: arrFliterResult[indexPath.row].id ?? ""))_\(arrFliterResult[indexPath.row].secret ?? "").jpg"
            cell.imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "placeholder"))
        }
        else{
            
            cell.lblTitle.text = photosVM.albumData.photos?.photo![indexPath.row].title == "" ? "N/A" : photosVM.albumData.photos?.photo![indexPath.row].title
            
            let picURL = "\(Constants.imgURL)\(photosVM.albumData.photos?.photo![indexPath.row].server ?? "")/\(String(describing: photosVM.albumData.photos?.photo![indexPath.row].id ?? ""))_\(photosVM.albumData.photos?.photo![indexPath.row].secret ?? "").jpg"
            cell.imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "placeholder"))
        }
        self.finishFakeRequest()
        return cell
    }
}

//MARK:- UITableView Delegate
extension PhotosVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print (indexPath.row)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       cell.backgroundColor = UIColor.clear
       
        if indexPath.row == photosVM.albumData.photos!.photo!.count - 1
       {
            if self.photosVM.albumData.photos!.pages! > self.photosVM.albumData.photos!.page!
            {
                spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                tblPhotos.tableFooterView = spinner
                tblPhotos.tableFooterView?.isHidden = false
                
                // Little delay to show activity indicator
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                 
                 self.photosVM.getMorePhotos(pageNumber: (self.photosVM.albumData.photos!.page! + 1)) {
                     self.spinner.stopAnimating()
                     self.tblPhotos.tableFooterView = nil
                     self.tblPhotos.tableFooterView?.isHidden = true
                     self.tblPhotos.reloadData()
                 }
                }
            }
       }
   }
}

//MARK:- UISearchBar Delegate
extension PhotosVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        isSearch = searchText == "" ? false : true
        print("searchText \(searchText)")
        arrFliterResult.removeAll()
        for (index, element) in photosVM.albumData.photos!.photo!.enumerated() {
            if (element.title?.contains(searchText)) != false
            {
                arrFliterResult.append(photosVM.albumData.photos!.photo![index])
            }
        }
        tblPhotos.reloadData()
    }
}
