//
//  FlickrAlbumPhotos.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation
import ObjectMapper

class FlickrAlbumAllPhotos : NSObject, Mappable{

    var page : Int?
    var pages : Int?
    var perpage : Int?
    var photo : [FlickrAlbumPhoto]?
    var total : Int?

    class func newInstance(map: Map) -> Mappable?{
        return FlickrAlbumAllPhotos()
    }
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        page <- map["page"]
        pages <- map["pages"]
        perpage <- map["perpage"]
        photo <- map["photo"]
        total <- map["total"]
        
    }
}
