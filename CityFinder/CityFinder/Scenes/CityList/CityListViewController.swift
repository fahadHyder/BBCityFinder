//
//  CityListViewController.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import UIKit

protocol CityListChildProtocol {
    func update(withCityData cityData: CityDataType)
}

class CityListViewController: UIViewController {
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cityListViewModel = CityListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityListViewModel.updateHandler = { [weak self] in
            self?.citiesTableView.reloadData()
        }
        citiesTableView.isAccessibilityElement = true
        citiesTableView.accessibilityIdentifier = "automationCitiesTableView"
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadData() {
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        cityListViewModel.fetchCitiesData {
            DispatchQueue.main.async { [weak self] in
                self?.view.isUserInteractionEnabled = true
                self?.activityIndicator.stopAnimating()
                self?.citiesTableView.reloadData()
                self?.cityListViewModel.setSelectedCityIndex(index: 0)
                self?.updateMapContainer()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapPushSegue" {
            if let destinationController = segue.destination as? CityMapViewController {
                if cityListViewModel.citiesCount > 0 {
                    let selectedCity = self.cityListViewModel.city(atIndex: self.cityListViewModel.selectedCityIndex)
                    let cityData = CityMapData(country: selectedCity.country, name: selectedCity.name, id: selectedCity.id, latitude: selectedCity.coordinate.latitude, longitude: selectedCity.coordinate.longitude)
                    destinationController.cityMapData = cityData
                }
            }
        }
    }
    
    func updateMapContainer() {
        self.children.forEach { [weak self] (child) in
            if let child = child as? CityListChildProtocol {
                guard let strongSelf = self else {
                    return
                }
                let selectedCity = strongSelf.cityListViewModel.city(atIndex: strongSelf.cityListViewModel.selectedCityIndex)
                let cityData = CityMapData(country: selectedCity.country, name: selectedCity.name, id: selectedCity.id, latitude: selectedCity.coordinate.latitude, longitude: selectedCity.coordinate.longitude)
                child.update(withCityData: cityData)
            }
        }
    }

}

// MARK: - Search Bar Delegate

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityListViewModel.searchCity(withKeyWord: searchText)
    }
}

// MARK: - UITableViewDelegate

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityListViewModel.setSelectedCityIndex(index: indexPath.row)
        
        if UIDevice.current.orientation.isLandscape {
            updateMapContainer()
        } else {
            performSegue(withIdentifier: "mapPushSegue", sender: self)
        }
    }
}

// MARK: - UITableViewDataSource

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListViewModel.citiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as? CityCell else {
            return UITableViewCell()
        }
        let cityData = cityListViewModel.city(atIndex: indexPath.row)
        cell.isAccessibilityElement = true
        cell.titleLabel?.text = cityData.name + "," + " \(cityData.country)"
        cell.subTitleLabel?.text = "\(cityData.coordinate.latitude), \(cityData.coordinate.longitude)"
        cell.accessibilityIdentifier = "automationCityCell_\(indexPath.row)"
        return cell
    }
    
}
