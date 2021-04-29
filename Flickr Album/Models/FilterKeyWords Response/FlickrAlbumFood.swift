//
//  FlickrAlbumFood.swift
//  Flickr Album
//
//  Created by Hassan on 28.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumFood : NSObject, Mappable {

	var dessert : [String]?
	var fastfood : [String]?

	class func newInstance(map: Map) -> Mappable? {
		return FlickrAlbumFood()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map) {
		dessert <- map["Dessert"]
		fastfood <- map["Fastfood"]
	}
}
