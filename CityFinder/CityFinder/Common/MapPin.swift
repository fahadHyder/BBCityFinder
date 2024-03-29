//
//  MapPin.swift
//  CityFinder
//
//  Created by fahad c h on 16/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import MapKit

class MapPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
