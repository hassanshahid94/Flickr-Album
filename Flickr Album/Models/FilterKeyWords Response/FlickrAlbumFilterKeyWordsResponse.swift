//
//  FlickrAlbumFilterKeyWordsResponse.swift
//  Flickr Album
//
//  Created by Hassan on 28.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumFilterKeyWordsResponse : NSObject, Mappable {

	var animals : FlickrAlbumAnimal?
	var food : FlickrAlbumFood?
	var movie : FlickrAlbumMovie?
	var vechicle : FlickrAlbumVechicle?

	class func newInstance(map: Map) -> Mappable?{
		return FlickrAlbumFilterKeyWordsResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map) {
		animals <- map["Animals"]
		food <- map["Food"]
		movie <- map["Movie"]
		vechicle <- map["Vechicle"]
	}
}
