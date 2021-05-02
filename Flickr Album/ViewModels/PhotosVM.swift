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
    var albumData: FlickrAlbumPhotosResponse! {
        didSet {
            self.bindPhotosVMToController()
        }
    }
    var keywordsDict: NSDictionary! { // First Heirarchy -> Dict for predefine keywords
        didSet {
            self.bindPhotosVMToController()
        }
    }
    
    //MARK:- Constructor
    override init() {
        super.init()
        keywordsDict = readData(fileName: "flickr-keyword-struct")!
        getPhotos { [self] (status) in
            if status != "success" {
                //Loading cache data if internet isn't available.
                if let photos = DataCache.instance.readObject(forKey: CacheValue.photos) {
                    albumData = Mapper<FlickrAlbumPhotosResponse>().map(JSONObject: photos)
               }
               else {
                   albumData = nil
               }
            }
        }
    }
    
    //MARK:- Functions
    func getPhotos(pageNumber: Int = 1, completion: @escaping (String) -> Void) {
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = pageNumber
        params.text = ""
        params.contentType = 1
        ServerManager.getAllPhotos(params: params) { [self] (status, data) in
            if status == "success" {
                if pageNumber == 1 {
                    albumData = data
                }
                else {
                     albumData.photos?.page = data?.photos?.page!
                     albumData.photos?.photo?.append(contentsOf: (data!.photos!.photo!))
                }
                //Cache Data
                 DataCache.instance.write(object: albumData.toJSON() as NSCoding, forKey: CacheValue.photos)
            }
            completion(status)
        }
    }
    public func getSearchPhotos(pageNumber: Int = 1, searchText: String, completion: @escaping (String) -> Void) {
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = pageNumber
        params.text = searchText
        params.contentType = 1
        ServerManager.getSearchPhotos(params: params) { [self] (status, data) in
            if status == "success" {
                if pageNumber == 1 {
                    albumData = data
                }
                else {
                    albumData.photos?.page = data?.photos?.page!
                    albumData.photos?.photo?.append(contentsOf: (data!.photos!.photo!))
                }
                //Cache Data
                DataCache.instance.write(object: albumData.toJSON() as NSCoding, forKey: CacheValue.photos)
            }
            completion(status)
        }
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
}
