//
//  FlickrAlbumPhoto.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumPhoto : NSObject, Mappable{

	var farm : Int?
	var id : String?
	var isfamily : Int?
	var isfriend : Int?
	var ispublic : Int?
	var owner : String?
	var secret : String?
	var server : String?
	var title : String?

	class func newInstance(map: Map) -> Mappable?{
		return FlickrAlbumPhoto()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		farm <- map["farm"]
		id <- map["id"]
		isfamily <- map["isfamily"]
		isfriend <- map["isfriend"]
		ispublic <- map["ispublic"]
		owner <- map["owner"]
		secret <- map["secret"]
		server <- map["server"]
		title <- map["title"]
		
	}
}
