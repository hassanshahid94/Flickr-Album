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
    
    public static func getAllPhotos(params: GetPhotosBody, completion: @escaping (String ,FlickrAlbumPhotosResponse?) -> Void)
    {
        let url = "\(Constants.baseURL)\(FlickrAlbumEndpoints.getPhotos.rawValue)&format=\(String(describing: params.format!))&nojsoncallback=\(String(describing: params.nojsoncallback!))&api_key=\(String(describing: params.apiKey!))&page=\(String(describing: params.page!))"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(request).responseObject { (response: DataResponse<FlickrAlbumPhotosResponse>) in

            switch response.result
            {
                case .success:
                    let data = response.result.value
                    completion("success",data)
            case .failure(let error):
                print(error.localizedDescription)
                completion(error.localizedDescription, nil)
            }
        }
    }
}

enum FlickrAlbumEndpoints: String
{
    //Rest API URL
    case getPhotos               = "rest/?method=flickr.photos.getRecent"
}
