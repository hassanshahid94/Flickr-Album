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
        view.addSubview(lblHeading)
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
        txtSearch.showsScopeBar = true
        view.addSubview(txtSearch)
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
        view.addSubview(tblPhotos)
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
        //Loading skeleton view and API call
        setupLoadingPlaceholderView()
        performFakeNetworkRequest()
        loadPhotos()
    }
    func loadPhotos() {
        photosVM.getPhotos { [self] (status) in
            if status == "success" {
                callToViewModelForUIUpdate()
            }
            else {
                showAlert(message: status)
            }
            finishFakeRequest()
        }
    }
    func callToViewModelForUIUpdate() {
        photosVM =  PhotosVM()
        photosVM.bindPhotosVMToController =  { [self] in
             tblPhotos.reloadData()
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
        txtSearch.text = ""
        view.endEditing(true)
        loadPhotos()
    }
}

//MARK:- UITableView DataSource
extension PhotosVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosVM.albumData == nil ? 0 : photosVM.albumData.photos!.photo!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTCell", for: indexPath) as! PhotosTCell
        cell.selectionStyle = .none
        //Setting title label text
        cell.lblTitle.text = photosVM.albumData.photos?.photo![indexPath.row].title == "" ? "N/A" : photosVM.albumData.photos?.photo![indexPath.row].title
        //creating the imageURL
        let picURL = "\(Constants.imgURL)\(photosVM.albumData.photos?.photo![indexPath.row].server ?? "")/\(String(describing: photosVM.albumData.photos?.photo![indexPath.row].id ?? ""))_\(photosVM.albumData.photos?.photo![indexPath.row].secret ?? "").jpg"
        //showing the spinner when image is loading
        cell.imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
        //setting the imageview
        cell.imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        return cell
    }
}

//MARK:- UITableView Delegate
extension PhotosVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Initialize both your image and the mediaZoom view associated.
        let imgAlbum = UIImageView(frame: CGRect(x: 0, y: 0, width: view.layer.frame.width, height: view.layer.frame.height))
        imgAlbum.contentMode = .scaleAspectFit
        //creating the image URL
        let picURL = "\(Constants.imgURL)\(photosVM.albumData.photos?.photo![indexPath.row].server ?? "")/\(String(describing: photosVM.albumData.photos?.photo![indexPath.row].id ?? ""))_\(photosVM.albumData.photos?.photo![indexPath.row].secret ?? "").jpg"
        //Showing the spinner during image loading
        imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
        //setting the imageview
        imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        //Initilaize the zoomimage
        let mediaZoom = XLMediaZoom(animationTime: 0.3, image: imgAlbum, blurEffect: false)
        //Add the mediaZoom view to your superView and show it.
        view.addSubview(mediaZoom!)
        mediaZoom!.show()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photosVM.albumData.photos!.photo!.count - 1 {
            if self.photosVM.albumData.photos!.pages! >= self.photosVM.albumData.photos!.page! {
                var spinner = UIActivityIndicatorView()
                spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                tblPhotos.tableFooterView = spinner
                tblPhotos.tableFooterView?.isHidden = false
                if isSearch {
                    photosVM.getSearchPhotos(pageNumber: photosVM.albumData.photos!.page! + 1, searchText: txtSearch.text!) { [self] (status) in
                        if status == "success" {
                            tblPhotos.reloadData()
                        }
                        else {
                            showAlert(message: status)
                        }
                    }
                }
                else {
                    photosVM.getPhotos(pageNumber: photosVM.albumData.photos!.page! + 1) { [self] (status) in
                        if status == "success" {
                            tblPhotos.reloadData()
                        }
                        else {
                            showAlert(message: status)
                        }
                    }
                }
                spinner.stopAnimating()
                tblPhotos.tableFooterView = nil
                tblPhotos.tableFooterView?.isHidden = true
            }
       }
   }
}

//MARK:- UISearchBar Delegate
extension PhotosVC: UISearchBarDelegate {
    /* this function is triggered whenever there is a change in searchbar text
         i.e. adding/removing alphabets */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = searchText == "" ? false : true
        if !isSearch{
            //Loading skeletonview and APIs call
            setupLoadingPlaceholderView()
            performFakeNetworkRequest()
            loadPhotos()
        }
    }
    // this function is called when search button is tapped!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Loading skeletonview
        if txtSearch.text == "0" {
            return
        }
        setupLoadingPlaceholderView()
        performFakeNetworkRequest()
        isSearch = true
        view.endEditing(true)
        photosVM.getSearchPhotos(searchText: txtSearch.text!) { [self] (status) in
            if status == "success" {
                tblPhotos.reloadData()
            }
            else {
                showAlert(message: status)
            }
            finishFakeRequest()
        }
    }
}
