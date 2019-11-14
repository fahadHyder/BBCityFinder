//
//  CityModel.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import Foundation

//{"country":"DE","name":"Gatow","_id":2922336,"coord":{"lon":13.18285,"lat":52.483238}}
struct CityModel: Decodable {
    let country: String
    let name: String
    let id: Int
    let coordinate: Coordinate
    
    enum CodingKeys: String, CodingKey {
        case country = "country"
        case name = "name"
        case id = "_id"
        case coordinate = "coord"
    }
    
}

struct Coordinate: Decodable {
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}
