//
//  PhotosVC.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import UIKit
import SnapKit
import SDWebImage
import GSImageViewerController
import DropDown

class PhotosVC: UIViewController {
    
    //MARK:- Variables
    var isSearch = false
    var photosVM = PhotosVM()
    var refreshControl = UIRefreshControl()
    let dropDownKeyWords = DropDown()
    var keywordsDict: NSDictionary! // First Heirarchy -> Dict for predefine keywords
    var keywordsDictLevel2: NSDictionary! // Second Heirarchy -> Dict for predefine keywords
    var items = [String]() // Second/Third Heirarchy -> Array using in CollectionView for predefine keywords
    
    //MARK:- Variables for Outlets/UI
    var lblHeading: UILabel!
    var txtSearch: UISearchBar!
    var lblDescription: UILabel!
    var tblPhotos: UITableView!
    var spinner = UIActivityIndicatorView()
    var btnDropDown: UIButton!
    var collectionVwFilter: UICollectionView!
    
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPredefineKeywords()
        //Creating UI Programmatically
        configureUI()
        //Binding API data response to UI
        callToViewModelForUIUpdate()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK:- Functions
    func loadPredefineKeywords() {
        // reading json keywords from json file
        keywordsDict = readData(fileName: "flickr-keyword-struct")!
        // loading level 1 keywords in dropdown
        setupDropDown(itemsCV: keywordsDict.allKeys as! [String])
        setUpCollectionViewForKeywords()
    }
    func configureUI() {
        // Adding a Label Heading Programtically
        lblHeading = UILabel()
        lblHeading.text = "Flickr Album"
        lblHeading.textColor = UIColor.FlickrAlbum_theme
        lblHeading.textAlignment = .center
        lblHeading.font = UIFont.FlickAlbum_heading
        view.addSubview(lblHeading)
        lblHeading.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.frame.width * 0.95)
            make.topMargin.equalTo(10)
            make.centerXWithinMargins.equalToSuperview()
        }
        // Adding a DropDown Button Heading Programtically
        btnDropDown = UIButton()
        btnDropDown.setTitle("Categories", for: .normal)
        btnDropDown.titleLabel?.font = UIFont.FlickAlbum_description
        btnDropDown.layer.borderColor = UIColor.FlickrAlbum_theme.cgColor
        btnDropDown.layer.borderWidth = 1
        btnDropDown.layer.cornerRadius = 10
        btnDropDown.setTitleColor(UIColor.FlickrAlbum_theme, for: .normal)
        btnDropDown.addTarget(self, action: #selector(btnDropDownAction), for: .touchUpInside)
        view.addSubview(btnDropDown)
        btnDropDown.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(-10)
            make.top.equalTo(lblHeading.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(40)
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
            make.leading.equalTo(10)
            make.trailing.equalTo(btnDropDown.snp.leading).offset(-10)
            make.centerY.equalTo(btnDropDown.snp.centerY)
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
    func callToViewModelForUIUpdate() {
        photosVM.bindPhotosVMToController =  { [self] in
            if photosVM.albumData == nil {
                showAlert(message: "The internet connection appears to be offline.")
            }
            removeSpinnerFromView()
            tblPhotos.reloadData()
        }
    }
    func loadPhotos() {
        photosVM.getPhotos { [self] (status) in
            if status == "success" {
                lblDescription.text = "Recent Photos"
                tblPhotos.reloadData()
            }
            else {
                //showing error message
                showAlert(message: status)
            }
            removeSpinnerFromView()
        }
    }
    //pull to refresh fucntion for TableView
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
    //Showing drop when clicked
    @objc func btnDropDownAction(sender : UIButton) {
        // disaply the drop down that contains level 1 keywords
        view.endEditing(true)
        dropDownKeyWords.show()
    }
    //Setting up the dropdown values
    func setupDropDown(itemsCV: [String]) {
        dropDownKeyWords.anchorView = btnDropDown // UIView or UIBarButtonItem
        // Will set a custom width instead of the anchor view width
        dropDownKeyWords.width = 200
        //dropDownKeyWords.direction = .top
        dropDownKeyWords.dataSource = itemsCV
        dropDownKeyWords.selectionAction = { [unowned self] (index, item) in
            addSpinnerToView()
            btnDropDown.setTitle(item, for: .normal)
            txtSearch.text = item
            getDataWithSearchKeyword()
            tblPhotos.tableHeaderView = collectionVwFilter
            collectionVwFilter.snp.makeConstraints { (make) -> Void in
                make.width.equalToSuperview()
                make.height.equalTo(50)
                make.centerXWithinMargins.equalToSuperview()
            }
            keywordsDictLevel2 = keywordsDict.value(forKey: "\(item)") as? NSDictionary
            items.removeAll()
            for subType in keywordsDictLevel2 {
                items.append(subType.key as! String)
            }
            // reload the buttons
            collectionVwFilter.reloadData()
        }
    }
    func setUpCollectionViewForKeywords() {
        // setting up the collection view
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionVwFilter = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50), collectionViewLayout: layout)
        collectionVwFilter.backgroundColor = UIColor.white
        collectionVwFilter.showsHorizontalScrollIndicator = false
        collectionVwFilter.register(FiltersCCell.self, forCellWithReuseIdentifier: "FiltersCCell")
        collectionVwFilter.dataSource = self
        collectionVwFilter.delegate = self
    }
    //Fetching the data from the local file json
    func readData(fileName: String) -> NSDictionary? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    return jsonResult as NSDictionary
                }
            }
            catch {
                print ("File cannot be read...")
            }
        }
        return nil
    }
    func getDataWithSearchKeyword() {
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
                    //Calling Recent photos API
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
            tblPhotos.tableHeaderView = nil
            btnDropDown.setTitle("Categories", for: .normal)
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
        getDataWithSearchKeyword()
    }
}

//MARK:- UICollectionView DataSource
extension PhotosVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersCCell", for: indexPath) as! FiltersCCell
        let title = items[indexPath.row]
        cell.lblFilter.text = title
        cell.lblFilter.sizeToFit()
        if txtSearch.text == cell.lblFilter.text {
            cell.vwBackground.backgroundColor = UIColor.FlickrAlbum_theme
            cell.lblFilter.textColor = UIColor.white
        }
        else {
            cell.vwBackground.backgroundColor = UIColor.white
            cell.lblFilter.textColor = UIColor.black
        }
        return cell
    }
}

//MARK:- UICollectionView Delegate and Flowlayout
extension PhotosVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addSpinnerToView()
        let title = items[indexPath.row]
        txtSearch.text = title
        getDataWithSearchKeyword()
        if let subSubTypes = keywordsDictLevel2.value(forKey: title) {
            items.removeAll()
            items = subSubTypes as! [String]
        }
        collectionVwFilter.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let width = collectionView.frame.size.width/2.5
        let height = CGFloat(50.0)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
