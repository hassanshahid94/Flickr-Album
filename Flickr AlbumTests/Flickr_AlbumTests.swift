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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetPhotos() {
        let data = readData(fileName: "PhotosResponse")
        
        var expected: FlickrAlbumPhotosResponse!
        expected = Mapper<FlickrAlbumPhotosResponse>().map(JSONObject: data)
        let expectatio = expectation(description: "GET \(Constants.baseURL)\(FlickrAlbumEndpoints.getPhotos.rawValue)")

        let params = GetPhotosBody()
        params.format = "json"
        params.apiKey = Constants.apiKey
        params.nojsoncallback = 1
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
            if let path = Bundle.main.path(forResource: fileName, ofType: "json")
            {
                do
                {let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                        return jsonResult as AnyObject
                    }
                } catch {
                    print ("File cannot be read...")
                }
            }
            return nil
            
        }
    
}
