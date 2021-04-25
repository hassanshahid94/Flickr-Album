//
//  PhotosVC.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import UIKit
import SDWebImage
import LoadingPlaceholderView
class PhotosVC: UIViewController {

    //MARK:- Variables
    var photosVM : PhotosVM!
    var dataSource : PhotosTableViewDataSource<PhotosTCell,FlickrAlbumPhoto>!
    var loadingPlaceholderView = LoadingPlaceholderView()
    var cellsIdentifiers = [
        "PhotosTCell",
        "PhotosTCell",
        "PhotosTCell",
        "PhotosTCell"
    ]
    
    //MARK:- Outlets
    @IBOutlet weak var tblPhotos: UITableView!{
        didSet {
            tblPhotos.coverableCellsIdentifiers = cellsIdentifiers
        }
    }
    
    //MARK:- Load
    override func viewDidLoad() {
        super.viewDidLoad()
        callToViewModelForUIUpdate()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Functions
    func callToViewModelForUIUpdate(){
        
        setupLoadingPlaceholderView()
        performFakeNetworkRequest()
        photosVM =  PhotosVM()
        photosVM.bindPhotosVMToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        
        dataSource = PhotosTableViewDataSource(cellIdentifier: "PhotosTCell", items: photosVM.albumData.photos!.photo!, configureCell: { (cell, data) in

            self.finishFakeRequest()
            cell.lblTitle.text = data.title ?? ""
            cell.imgAlbum.sd_imageIndicator = SDWebImageActivityIndicator.large
            cell.imgAlbum.sd_setImage(with: URL(string: "\(Constants.imgURL)\(data.server ?? "")/\(String(describing: data.id ?? ""))_\(data.secret ?? "").jpg"), placeholderImage: UIImage(named: "placeholder"))
        })
        
        DispatchQueue.main.async {
            self.tblPhotos.dataSource = self.dataSource
            self.tblPhotos.delegate = self.dataSource
            self.tblPhotos.reloadData()
        }
    }
    
    private func performFakeNetworkRequest() {
        loadingPlaceholderView.cover(view)
    }

    private func finishFakeRequest() {
        loadingPlaceholderView.uncover()
    }

    private func setupLoadingPlaceholderView() {
        
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
    }

}
