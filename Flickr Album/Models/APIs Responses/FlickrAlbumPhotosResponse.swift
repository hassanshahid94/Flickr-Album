//
//  FlickrAlbumPhotosResponse.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumPhotosResponse : NSObject, Mappable {

	var photos : FlickrAlbumAllPhotos?
	var stat : String?

	class func newInstance(map: Map) -> Mappable? {
		return FlickrAlbumPhotosResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map) {
		photos <- map["photos"]
		stat <- map["stat"]
	}
}
