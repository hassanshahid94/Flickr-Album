//
//  PhotosVM.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation
import UIKit
import DataCache
import SwiftyJSON
import ObjectMapper

class PhotosVM : NSObject  {
    
    //MARK:- Variables
    var bindPhotosVMToController : (() -> ()) = {}
    var albumData : FlickrAlbumPhotosResponse! {
        didSet {
            self.bindPhotosVMToController()
        }
    }
    
    //MARK:- Load
    override init() {
        super.init()
        loadDefaults()
    }
    
    //MARK:- Functions
    func loadDefaults()
    {
        if let photos = DataCache.instance.readObject(forKey: CacheValue.photos)
        {
             albumData = Mapper<FlickrAlbumPhotosResponse>().map(JSONObject: photos)
        }
    }
    func getPhotos(completion: @escaping (String) -> Void) {
        
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = 1
        ServerManager.getAllPhotos(params: params) { (status, data) in
            if status == "success"
            {
                self.albumData = data
                //Cache Data
                DataCache.instance.write(object: self.albumData.toJSON() as NSCoding, forKey: CacheValue.photos)
            }
            completion(status)
        }
    }
    
    public func getMorePhotos(pageNumber: Int, completion: @escaping (String) -> Void) {
        
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = pageNumber
        ServerManager.getAllPhotos(params: params) { [self](status, data) in
            if status == "success"
            {
                self.albumData.photos?.page = pageNumber
                self.albumData.photos?.photo?.append(contentsOf: (data!.photos!.photo!))
                
                //Cache Data
                DataCache.instance.write(object: self.albumData.toJSON() as NSCoding, forKey: CacheValue.photos)
            }
            completion(status)
        }
    }
}
