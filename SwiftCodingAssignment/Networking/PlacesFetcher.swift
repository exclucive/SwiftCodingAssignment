//
//  ForsquareNetworking.swift
//
//  Created by Igor Novik on 2018-03-19.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

class PlacesFetcher: NSObject {
    static private let kGetPlacessEndpoint = "/venues/search"
    
    class func requestVenues(term: String, coordinates: String, completion: @escaping ([Venue]?, Error?) -> Void) {
        let params = ["query": term,
                      "radius": "\(Constants.searchRange)",
                      "ll": coordinates,
                      "intent": "browse",
                      "client_id": Constants.clientID,
                      "client_secret": Constants.clientSecret,
                      "v": "20180319"]
        
        guard let requestUrl = URL(string: Constants.apiBaseURL + kGetPlacessEndpoint) else {
            return
        }
        
        NetworkManager.getRequest(requestUrl, parameters: params) { (error, data) in
            DispatchQueue.main.async {
                guard error == nil, let jsonData = data else {
                    completion(nil, error!)
                    return
                }

                // parse
                do {
                    let venueResponse = try JSONDecoder().decode(VenueFetchRoot.self, from: jsonData)
                    completion(venueResponse.response.venues, nil)
                }
                catch let error {
                    print(error)
                    completion(nil, error)
                }
            }
        }
    }
    
    
}
