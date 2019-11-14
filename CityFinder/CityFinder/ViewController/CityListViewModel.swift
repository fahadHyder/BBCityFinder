//
//  CityListViewModel.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import Foundation

class CityListViewModel {
    private let cityDataSource = CitiesDataSource()
    
    
    func fetchCitiesData()  {
        cityDataSource.getAllcities { (status) in
            switch status {
            case .success:
                print("success")
            case .error(let error):
                print(error)
            }
        }
    }
}
