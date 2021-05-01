//
//  PhotosVC.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import UIKit
import SnapKit
import SDWebImage
import XLMediaZoom
import GSImageViewerController

class PhotosVC: UIViewController {
    
    //MARK:- Variables
    var isSearch = false
    var photosVM = PhotosVM()
    var refreshControl = UIRefreshControl()
    
    //MARK:- Variables for Outlets/UI
    var lblHeading: UILabel!
    var txtSearch: UISearchBar!
    var lblDescription: UILabel!
    var tblPhotos: UITableView!
    var spinner = UIActivityIndicatorView()
    
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Creating UI Programmatically
        configureUI()
        //Binding API data response to UI
        callToViewModelForUIUpdate()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        txtSearch.setShowsCancelButton(true, animated: true)
        view.addSubview(txtSearch)
        txtSearch.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(lblHeading.snp.width)
            make.top.equalTo(lblHeading.snp.bottom).offset(10)
            make.centerXWithinMargins.equalToSuperview()
        }
        //Adding description label Programmatically
        lblDescription = UILabel()
        lblDescription.text = "Recent Photos"
        lblDescription.textColor = UIColor.FlickrAlbum_theme
        lblDescription.textAlignment = .center
        lblDescription.font = UIFont.FlickAlbum_heading
        view.addSubview(lblDescription)
        lblDescription.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.frame.width * 0.95)
            make.top.equalTo(txtSearch.snp.bottom).offset(10)
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
            make.top.equalTo(lblDescription.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).inset(10)
            make.centerXWithinMargins.equalToSuperview()
        }
       // pull to refresh tableview
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.FlickrAlbum_theme
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblPhotos.addSubview(refreshControl)
        addSpinnerToView()
    }
    func loadPhotos() {
        photosVM.getPhotos { [self] (status) in
            if status == "success" {
                lblDescription.text = "Recent Photos"
                callToViewModelForUIUpdate()
            }
            else {
                //showing error message
                showAlert(message: status)
            }
            removeSpinnerFromView()
        }
    }
    func callToViewModelForUIUpdate() {
        photosVM.bindPhotosVMToController =  { [self] in
            if photosVM.albumData == nil {
                showAlert(message: "The internet connection appears to be offline.")
            }
            removeSpinnerFromView()
            tblPhotos.reloadData()
        }
    }
    @objc func refresh(_ sender: Any) {
        txtSearch.text = ""
        view.endEditing(true)
        loadPhotos()
    }
    func addSpinnerToView() {
        tblPhotos.isHidden = true
        spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.FlickrAlbum_theme
        view.addSubview(spinner)
        spinner.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.frame.width)
            make.height.equalTo(view.frame.height)
            make.centerXWithinMargins.equalToSuperview()
            make.centerYWithinMargins.equalToSuperview()
        }
        spinner.startAnimating()
    }
    func removeSpinnerFromView() {
        refreshControl.endRefreshing()
        tblPhotos.isHidden = false
        spinner.stopAnimating()
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
        //setting the image on ImageView
        cell.imgAlbum.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "ic_placeholder"))
        return cell
    }
}

//MARK:- UITableView Delegate
extension PhotosVC: UITableViewDelegate {
    //Using this delegate to show full image view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        // access the tableview cell that has been tapped
        guard let cell = tableView.cellForRow(at: indexPath) as? PhotosTCell else { return }
        
        // image url required for HD image
        let picURL = "\(Constants.imgURL)\(photosVM.albumData.photos?.photo![indexPath.row].server ?? "")/\(String(describing: photosVM.albumData.photos?.photo![indexPath.row].id ?? ""))_\(photosVM.albumData.photos?.photo![indexPath.row].secret ?? "").jpg"
       
        // using GSImageInfo library to present a full screen image view
        let imageInfo = GSImageInfo(image: cell.imgAlbum.image!, imageMode: .aspectFit, imageHD: URL(string: picURL))
        let transitionInfo = GSTransitionInfo(fromView: cell.imgAlbum)
        let imgViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            imgViewer.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            imgViewer.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            imgViewer.view.sendSubviewToBack(blurEffectView)
        } else {
            imgViewer.backgroundColor = .black
        }
        
        present(imgViewer, animated: true, completion: nil)
    }
   
    //Using this delegate for pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last {
//                if indexPath == lastVisibleIndexPath {
//                    // do here...
//                    showAlert(message: "Last")
//                }
//            }
        if indexPath.row == photosVM.albumData.photos!.photo!.count - 1 {
            if photosVM.albumData.photos!.pages! >= photosVM.albumData.photos!.page! {
                spinner.color = UIColor.FlickrAlbum_theme
                spinner = UIActivityIndicatorView(style: .medium)
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                tblPhotos.tableFooterView = spinner
                tblPhotos.tableFooterView?.isHidden = false
                if isSearch {
                    //Calling search API with search keywords
                    photosVM.getSearchPhotos(pageNumber: photosVM.albumData.photos!.page! + 1, searchText: txtSearch.text!) { [self] (status) in
                        lblDescription.text = txtSearch.text
                        if status == "success" {
                            lblDescription.text = txtSearch.text
                            tblPhotos.reloadData()
                        }
                        else {
                            //showing error message
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
                            //showing error message
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
            //Showing recent photos when search is not active
            addSpinnerToView()
            loadPhotos()
        }
    }
    // this function is called when search button is tapped!
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if txtSearch.text == "0" {
            return
        }
        //Adding spinner to the view and hiding the tableview
        addSpinnerToView()
        isSearch = true
        view.endEditing(true)
        photosVM.getSearchPhotos(searchText: txtSearch.text!) { [self] (status) in
            if status == "success" {
                lblDescription.text = txtSearch.text
                tblPhotos.reloadData()
            }
            else {
                //showing error message
                showAlert(message: status)
            }
            //remove the spinner from the view and show the tableview
            removeSpinnerFromView()
        }
    }
    //keyboard dismiss when cancel button has been tapped
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
    }
}
