//
//  FlickrAlbumVechicle.swift
//  Flickr Album
//
//  Created by Hassan on 28.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumVechicle : NSObject, Mappable {

	var car : [String]?
	var motorcycle : [String]?

	class func newInstance(map: Map) -> Mappable? {
		return FlickrAlbumVechicle()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map) {
		car <- map["Car"]
		motorcycle <- map["Motorcycle"]
	}
}
