//
//  CityListViewController.swift
//  CityFinder
//
//  Created by fahad c h on 13/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let cityListViewModel = CityListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        cityListViewModel.updateHandler = { [weak self] in
            self?.citiesTableView.reloadData()
        }
        loadData()
    }
    
    func loadData() {
        activityIndicator.startAnimating()
        cityListViewModel.fetchCitiesData {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.citiesTableView.reloadData()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedChildSegue" {
            if let destinationController = segue.destination as? CityMapViewController {
                if cityListViewModel.citiesCount > 0 {
                    destinationController.cityCoordinate = cityListViewModel.cityCoordinate(atIndex: cityListViewModel.selectedCityIndex)
                }
            }
        }
    }

}

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cityListViewModel.searchCity(withKeyWord: searchText)
    }
}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityListViewModel.setSelectedCityIndex(index: indexPath.row)
        performSegue(withIdentifier: "embedChildSegue", sender: self)
    }
}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityListViewModel.citiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell") as? CityCell, let cityData = cityListViewModel.city(atIndex: indexPath.row) else {
            return UITableViewCell()
        }
        cell.titleLabel?.text = cityData.name + "," + " \(cityData.country)"
        cell.subTitleLabel?.text = "\(cityData.coordinate.latitude), \(cityData.coordinate.longitude)"
        return cell
    }
    
}
