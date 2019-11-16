//
//  CityDataType.swift
//  CityFinder
//
//  Created by fahad c h on 16/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

protocol CityDataType {
    var country: String { get set }
    var name: String { get set }
    var id: Int { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
}
