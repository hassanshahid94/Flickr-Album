//
//  FlickrAlbumPhotosResponse.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation 
import ObjectMapper

class FlickrAlbumPhotosResponse : NSObject, Mappable{

	var photos : FlickrAlbumAllPhotos?
	var stat : String?

	class func newInstance(map: Map) -> Mappable?{
		return FlickrAlbumPhotosResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		photos <- map["photos"]
		stat <- map["stat"]
		
	}
}


// MARK: - Welcome
struct Employees: Decodable {
    let status: String
    let data: [EmployeeData]
}

// MARK: - Datum
struct EmployeeData: Decodable {
    let id, employeeName, employeeSalary, employeeAge: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case employeeName = "employee_name"
        case employeeSalary = "employee_salary"
        case employeeAge = "employee_age"
        case profileImage = "profile_image"
    }
}
