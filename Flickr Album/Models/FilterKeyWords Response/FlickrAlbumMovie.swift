//
//  FlickrAlbumMovie.swift
//  Flickr Album
//
//  Created by Hassan on 28.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumMovie : NSObject, Mappable {

	var sciencefiction : [String]?

	class func newInstance(map: Map) -> Mappable? {
		return FlickrAlbumMovie()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map) {
		sciencefiction <- map["Sciencefiction"]
	}
}
