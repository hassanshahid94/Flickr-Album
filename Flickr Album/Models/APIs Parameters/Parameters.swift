//
//  Parameters.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation
import ObjectMapper


//GetPhotos API Body
class GetPhotosBody: NSObject, Mappable {
    var format : String?
    var nojsoncallback : Int?
    var apiKey : String?
    var page: Int?
    var text: String?
    var contentType: Int?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        format <- map["format"]
        nojsoncallback <- map["nojsoncallback"]
        apiKey <- map["api_key"]
        page <- map["page"]
        text <- map["text"]
        contentType <- map["content_type"]
    }
}
