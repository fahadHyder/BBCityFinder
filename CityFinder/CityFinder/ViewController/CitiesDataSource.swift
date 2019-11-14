//
//  CitiesDataSource.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import Foundation

class CitiesDataSource {
    
    public enum DataFetchStatus {
        case success
        case error(String)
    }
    
    public var citiesData: [CityModel]?
    
    public func getAllcities(completion: @escaping (DataFetchStatus) -> Void) {
        
        DispatchQueue.global().async { [weak self] in
            if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    self?.citiesData = try decoder.decode([CityModel].self, from: data)
                    completion(.success)
                } catch {
                    print("error:\(error)")
                    completion(.error(error.localizedDescription))
                }
            } else {
                completion(.error("No json file found"))
            }
        }
        
    }
}
