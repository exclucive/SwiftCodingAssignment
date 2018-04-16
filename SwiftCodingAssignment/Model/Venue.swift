//
//  Venue.swift
//
//  Created by Igor Novik on 2018-03-19.
//  Copyright © 2018 NAppsLab. All rights reserved.
//

import UIKit

struct VenueFetchRoot: Decodable {
    let response: VenueFetchResponse
}

struct VenueFetchResponse: Decodable {
    let venues: [Venue]
}

struct Venue: Decodable {
    let name: String
    let location: VenueLocation
    let contact: VenueContact?
    let categories: [VenueCategories]
}

// location
struct VenueLocation: Decodable {
    let formattedAddress: [String]
    let distance: Int
}

// contacts
struct VenueContact: Decodable {
    let formattedPhone: String?
}

// icons
struct VenueCategories: Decodable {
    let icon: VenueIcon
    
    struct VenueIcon: Decodable {
        let prefix: String
        let suffix: String
    }
}

extension Venue {
    enum VenueIconSize: Int {
        case big = 64
        case small = 32
        
        var value: Int {
            return rawValue
        }
    }
    
    func getIconURLForSize(_ size: VenueIconSize) -> URL? {
        guard categories.count > 0 else {
            return nil
        }
        let category = categories[0]
        let strURL = category.icon.prefix + "\(size.value)" + category.icon.suffix
        return URL(string: strURL)
    }
}
