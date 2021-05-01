//
//  ServerManager.swift
//  Flickr Album
//
//  Created by Hassan on 23.4.2021.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

class ServerManager {
    // MARK: - APIs Functions
    public static func getAllPhotos(params: GetPhotosBody, completion: @escaping (String ,FlickrAlbumPhotosResponse?) -> Void) {
        //creating URL
        //addingPercentEncoding is used for encoding the url string to support text with spaces
        let url = "\(Constants.baseURL)\(FlickrAlbumEndpoints.getPhotos.rawValue)&format=\(String(describing: params.format!))&nojsoncallback=\(String(describing: params.nojsoncallback!))&api_key=\(String(describing: params.apiKey!))&page=\(String(describing: params.page!))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //creating request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //Making request to the server to call the API
        Alamofire.request(request).responseObject { (response: DataResponse<FlickrAlbumPhotosResponse>) in
            //Check the response of the API
            switch response.result {
                case .success:
                    let data = response.result.value
                    completion("success",data)
                case .failure(let error):
                    completion(error.localizedDescription, nil)
                    
            }
        }
    }
    public static func getSearchPhotos(params: GetPhotosBody, completion: @escaping (String ,FlickrAlbumPhotosResponse?) -> Void) {
        //creating URL
        //addingPercentEncoding is used for encoding the url string to support search text with spaces
        let url = "\(Constants.baseURL)\(FlickrAlbumEndpoints.searchPhotos.rawValue)&format=\(String(describing: params.format!))&nojsoncallback=\(String(describing: params.nojsoncallback!))&api_key=\(String(describing: params.apiKey!))&page=\(String(describing: params.page!))&text=\(params.text!)&content_type=\(params.contentType!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        //creating request
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //Making request to the server to call the API
        Alamofire.request(request).responseObject { (response: DataResponse<FlickrAlbumPhotosResponse>) in
            //Check the response of the API
            switch response.result {
                case .success:
                    let data = response.result.value
                    completion("success",data)
            case .failure(let error):
                completion(error.localizedDescription, nil)
            }
        }
    }
}

// MARK: - EndPoints
enum FlickrAlbumEndpoints: String {
    //Rest API URL/endpoints
    case getPhotos               = "rest/?method=flickr.photos.getRecent"
    case searchPhotos            = "rest/?method=flickr.photos.search"
}
