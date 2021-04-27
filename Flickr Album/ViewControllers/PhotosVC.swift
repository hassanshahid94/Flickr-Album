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
import XLMediaZoom

class PhotosVC: UIViewController {
    
    //MARK:- Variables
    var isSearch = false
    var arrFliterResult = [FlickrAlbumPhoto]()
    var spinner = UIActivityIndicatorView()
    var photosVM : PhotosVM!
    var loadingPlaceholderView = LoadingPlaceholderView()
    var refreshControl = UIRefreshControl()
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
        callToViewModelForUIUpdate()
        configureUI()
        
        
        
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
        
       // pull to refresh tableview
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblPhotos.addSubview(refreshControl)
        
        setupLoadingPlaceholderView()
        performFakeNetworkRequest()
        loadPhotos()
        
    }
    
    func loadPhotos()
    {
        photosVM.getPhotos { (status) in
            if status == "success"
            {
                self.callToViewModelForUIUpdate()
            }
            else{
                self.showAlert(message: status)
            }
            self.finishFakeRequest()
        }
    }
    func callToViewModelForUIUpdate(){
        photosVM =  PhotosVM()
        photosVM.bindPhotosVMToController = {
             self.tblPhotos.reloadData()
        }
    }
    func performFakeNetworkRequest() {
        loadingPlaceholderView.cover(view)
    }

    func finishFakeRequest() {
        refreshControl.endRefreshing()
        loadingPlaceholderView.uncover()
    }

    func setupLoadingPlaceholderView() {
        
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
    }
    
    @objc func refresh(_ sender: Any) {
        loadPhotos()
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
        cell.selectionStyle = .none
        if isSearch{
            
            cell.lblTitle.text = arrFliterResult[indexPath.row].title == "" ? "N/A" : arrFliterResult[indexPath.row].title
            
            let picURL = "\(Constants.imgURL)\(arrFliterResult[indexPath.row].server ?? "")/\(String(describing: arrFliterResult[indexPath.row].id ?? ""))_\(arrFliterResult[indexPath.row].secret ?? "").jpg"
            cell.imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        }
        else{
            
            cell.lblTitle.text = photosVM.albumData.photos?.photo![indexPath.row].title == "" ? "N/A" : photosVM.albumData.photos?.photo![indexPath.row].title
            
            let picURL = "\(Constants.imgURL)\(photosVM.albumData.photos?.photo![indexPath.row].server ?? "")/\(String(describing: photosVM.albumData.photos?.photo![indexPath.row].id ?? ""))_\(photosVM.albumData.photos?.photo![indexPath.row].secret ?? "").jpg"
            cell.imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        }
        
        return cell
    }
}

//MARK:- UITableView Delegate
extension PhotosVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Initialize both your image and the mediaZoom view associated.
        var picURL = ""
        let imgAlbum = UIImageView(frame: CGRect(x: 0, y: 0, width: view.layer.frame.width, height: view.layer.frame.height))
        imgAlbum.contentMode = .scaleAspectFit
        
        if isSearch
        {
            picURL = "\(Constants.imgURL)\(arrFliterResult[indexPath.row].server ?? "")/\(String(describing: arrFliterResult[indexPath.row].id ?? ""))_\(arrFliterResult[indexPath.row].secret ?? "").jpg"
            imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        }
        else
        {
            picURL = "\(Constants.imgURL)\(photosVM.albumData.photos?.photo![indexPath.row].server ?? "")/\(String(describing: photosVM.albumData.photos?.photo![indexPath.row].id ?? ""))_\(photosVM.albumData.photos?.photo![indexPath.row].secret ?? "").jpg"
            imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        }
        let mediaZoom = XLMediaZoom(animationTime: 0.3, image: imgAlbum, blurEffect: false)
        //Add the mediaZoom view to your superView and show it.
        view.addSubview(mediaZoom!)
        mediaZoom!.show()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
                 
                    self.photosVM.getMorePhotos(pageNumber: self.photosVM.albumData.photos!.page! + 1) { (status) in
                        
                        if status == "success"
                        {
                            self.tblPhotos.reloadData()
                        }
                        else
                        {
                            self.showAlert(message: status)
                        }
                        self.spinner.stopAnimating()
                        self.tblPhotos.tableFooterView = nil
                        self.tblPhotos.tableFooterView?.isHidden = true
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
        arrFliterResult.removeAll()
        if photosVM.albumData != nil{
            for (index, element) in photosVM.albumData.photos!.photo!.enumerated() {
                let txtSearch = searchText.lowercased()
                let txtContain = element.title?.lowercased()
                
                if (txtContain?.contains(txtSearch)) != false
                {
                    arrFliterResult.append(photosVM.albumData.photos!.photo![index])
                }
            }
        }
        tblPhotos.reloadData()
    }
}
