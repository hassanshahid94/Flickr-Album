//
//  FlickrAlbumAnimal.swift
//  Flickr Album
//
//  Created by Hassan on 28.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumAnimal : NSObject, Mappable {

	var domesticanimals : [String]?
	var pets : [String]?
	var wildanimals : [String]?

	class func newInstance(map: Map) -> Mappable? {
		return FlickrAlbumAnimal()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map) {
		domesticanimals <- map["Domesticanimals"]
		pets <- map["Pets"]
		wildanimals <- map["Wildanimals"]
	}
}
