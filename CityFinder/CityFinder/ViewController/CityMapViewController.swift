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
    
    public var cityCoordinate: (Double, Double) = (0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
