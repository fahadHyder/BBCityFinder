//
//  CityMapViewController.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import UIKit
import MapKit

class CityMapViewController: UIViewController {
    @IBOutlet weak var cityMap: MKMapView!
    
    public var cityMapData: CityMapData?

    override func viewDidLoad() {
        super.viewDidLoad()

        if cityMapData != nil {
            updateMapView()
        }
    }
    
    func updateMapView() {
        if let cityData = cityMapData {
            let coodinate = CLLocationCoordinate2D(latitude: cityData.latitude, longitude: cityData.longitude)
            let latDelta: CLLocationDegrees = 2.0
            let lonDelta: CLLocationDegrees = 2.0
            cityMap.setRegion(MKCoordinateRegion(center: coodinate, span: .init(latitudeDelta: latDelta, longitudeDelta: lonDelta)), animated: true)
            let mapPin = MapPin(coordinate: coodinate, title: cityData.name, subtitle: cityData.country)
            cityMap.addAnnotation(mapPin)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aboutViewSegue", let cityData = cityMapData {
            let aboutPresenter = AboutPresenter(cityData: cityData)
            if let destinationController = segue.destination as? AboutViewController {
                destinationController.presenter = aboutPresenter
            }
        }
    }

}

extension CityMapViewController: CityListChildProtocol {
    func update(withCityData cityData: CityDataType) {
        if let cityData = cityData as? CityMapData {
            cityMapData = cityData
        }
        updateMapView()
    }
}

struct CityMapData: CityDataType {
    var country: String
    
    var name: String
    
    var id: Int
    
    var latitude: Double
    
    var longitude: Double
    
}
