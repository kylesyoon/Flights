//
//  APIUtility.swift
//  Flights
//
//  Created by Yoon, Kyle on 2/12/16.
//  Copyright © 2016 Kyle Yoon. All rights reserved.
//

import Foundation
import Alamofire

typealias APIUtilitySuccessCompletion = ([String: AnyObject]) -> Void
typealias APIUtilityFailureCompletion = (ErrorType) -> Void

class APIUtility {
    
    static let SharedUtility = APIUtility()
    
    func postJSON(path: String,
        parameters: [String: AnyObject]?,
        success: APIUtilitySuccessCompletion,
        failure: APIUtilityFailureCompletion) {
            HTTPSessionManager
                .AlamofireManager
                .request(.POST,
                    path,
                    parameters: parameters,
                    encoding: .JSON,
                    headers: nil).responseJSON(completionHandler: {
                        [weak self]
                        response in
                        self?.handleResponse(response,
                            success: success,
                            failure: failure)
                        })
    }
    
    private func handleResponse(response: Response<AnyObject, NSError>,
        success: APIUtilitySuccessCompletion,
        failure: APIUtilityFailureCompletion) {
            if let dict = response.result.value as? [String: AnyObject] where response.result.isSuccess {
                success(dict)
            } else {
                // TODO: Error handling
                if let error = response.result.error {
                    failure(error)
                } else {
                    // Does the error from above only cover parsing errors?
                }
            }
    }
    
}