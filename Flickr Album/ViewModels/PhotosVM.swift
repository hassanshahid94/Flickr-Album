//
//  PhotosVM.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation
import UIKit

class PhotosVM : NSObject {
    
    //MARK:- Variables
    var photosVC = PhotosVC()
     var albumData : FlickrAlbumPhotosResponse! {
        didSet {
            self.bindPhotosVMToController()
        }
    }

    
    var bindPhotosVMToController : (() -> ()) = {}
    
    override init() {
        super.init()
        getPhotos()
    }
    
    //MARK:- Functions
    func getPhotos() {
        
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = 1
        ServerManager.getAllPhotos(params: params) { (status, data) in
            if status == "success"
            {
                self.albumData = data
            }
            else
            {
                print ("something went wrong.")
            }
        }
    }
    
    public func getMorePhotos(completion: @escaping () -> Void) {
        
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = 2
        ServerManager.getAllPhotos(params: params) {(status, data) in
            if status == "success"
            {
                self.albumData.photos?.photo?.append(contentsOf: (data!.photos!.photo!))
               // self.photosVC.updateDataSource()
                completion()
                
            }
            else
            {
                print ("something went wrong.")
                completion()
            }
        }
    }
}
