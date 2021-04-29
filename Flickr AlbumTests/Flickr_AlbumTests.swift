//
//  Flickr_AlbumTests.swift
//  Flickr AlbumTests
//
//  Created by Hassan on 23.4.2021.
//

import XCTest
import ObjectMapper
import SwiftyJSON

@testable import Flickr_Album

class Flickr_AlbumTests: XCTestCase {
    
    //MARK:- Unit Testing
    func testGetPhotos() {
        let data = readData(fileName: "PhotosResponse")
        var expected: FlickrAlbumPhotosResponse!
        expected = Mapper<FlickrAlbumPhotosResponse>().map(JSONObject: data)
        let expectatio = expectation(description: "GET \(Constants.baseURL)\(FlickrAlbumEndpoints.getPhotos.rawValue)")
        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
        params.page = 1
        ServerManager.getAllPhotos(params: params) { (status, data) in
            XCTAssertEqual(expected.photos?.total, data?.photos?.total)
            expectatio.fulfill()
        }
        self.waitForExpectations(timeout: 5) { (error) in
            print ("\(String(describing: error?.localizedDescription))")
        }
    }
    //Reading Json File response
    func readData(fileName: String) -> AnyObject? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    return jsonResult as AnyObject
                }
            }
            catch {
                print ("File cannot be read...")
            }
        }
        return nil
    }
}
