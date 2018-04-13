//
//  APIClient.swift
//  NASADailyPic
//
//  Created by Raphael Araújo on 2018-04-12.
//  Copyright © 2018 Raphael Araújo. All rights reserved.
//

import UIKit
import Alamofire

enum ClientConstants: String {
    case dailyPictureURL = "https://api.nasa.gov/planetary/apod"
    case apiKey = "lQ3CFIdAuqFcm4bvHRFNDoN5iC09nXdCmb9de2gL"
    // In case of the apiKey above doesn't work, you can try with  lQ3CFIdAuqFcm4bvHRFNDoN5iC09nXdCmb9de2gL
}

struct CustomError {
    var localizedDescription: String?
}

protocol APIClientProtocol {
    func fetchDailyPicture(onCompletion: @escaping (_ completed: Bool, _ picture: Picture?, _ error: CustomError?) -> Void)
}

class APIClient: APIClientProtocol {
    func fetchDailyPicture(onCompletion: @escaping (_ completed: Bool, _ picture: Picture?, _ error: CustomError?) -> Void) {
        if let url = URL(string: "\(ClientConstants.dailyPictureURL.rawValue)?api_key=\(ClientConstants.apiKey.rawValue)") {
            Alamofire.request(url)
                .validate(statusCode: [200,202])
                .validate(contentType: ["application/json"])
                .responseData { response in
                    switch response.result {
                    case .success:
                        if let data = response.value {
                            do {
                                let picture = try JSONDecoder().decode(Picture.self, from: data)
                                onCompletion(true, picture, nil)
                            } catch (let e) {
                                let e = self.handleError(error: e)
                                onCompletion(false, nil, e)
                            }
                        }
                    case .failure(let error):
                        let e = self.handleError(error: error)
                        onCompletion(false, nil, e)
                    }
            }
        }
    }
    
    private func handleError(error: Error) -> CustomError {
        return CustomError(localizedDescription: error.localizedDescription)
    }
}
