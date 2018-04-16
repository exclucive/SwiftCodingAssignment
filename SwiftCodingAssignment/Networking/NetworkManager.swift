//
//  NetworkManager.swift
//
//  Created by Igor Novik on 2018-04-15.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    // MARK: Private
    private class func session() -> URLSession {
        return URLSession.shared
    }
    
    private class func requestWith(url: URL, parameters: [String: String]) -> URLRequest? {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = parameters.map { (parameter) -> URLQueryItem in
            return URLQueryItem(name: parameter.key, value: parameter.value)
        }
        guard let requestUrl = urlComponents?.url else {
            return nil
        }
        
        return URLRequest(url: requestUrl)
    }
    
    // MARK: Public
    class func getRequest(_ url: URL,
                        parameters: [String: String],
                        completionHandler: @escaping (Error?, Data?) -> ()) {
        
        guard let request = requestWith(url: url, parameters: parameters) else {
            // TODO: Generate error for this case
            completionHandler(nil, nil)
            return
        }
        
        session().dataTask(with: request) { (data, response, error) in
            completionHandler(error, data)
        }.resume()
    }
    
    class func getRequest(_ url: URL, completionHandler: @escaping (Error?, Data?) -> ()) {
        session().dataTask(with: url) { (data, response, error) in
            completionHandler(error, data)
        }.resume()
    }
}
