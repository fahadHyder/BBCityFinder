//
//  AboutViewController.swift
//  CityFinder
//
//  Created by fahad c h on 16/11/19.
//  Copyright © 2019 backbase. All rights reserved.
//

import UIKit

protocol ModelError:Error { }

protocol AboutView {
    func configure(with aboutInfo: AboutInfoData)
    func display(error: ModelError)
    func setActivityIndicator(hidden: Bool)
}

struct AboutInfoData {
    var country: String
    
    var name: String
    
    var id: Int
    
    var latitude: String
    
    var longitude: String
}

class AboutPresenter {
    let cityData: CityDataType
    var aboutInfo: AboutInfoData?
    
    init(cityData: CityDataType) {
        self.cityData = cityData
    }
    
    func loadAboutInfo() {
        aboutInfo = AboutInfoData(country: cityData.country, name: cityData.name, id: cityData.id, latitude: "\(cityData.latitude)", longitude: "\(cityData.longitude)")
    }
}

class AboutViewController: UITableViewController {
    
    typealias AboutInfoField = (name: String, keyPath: KeyPath<AboutInfoData, String>)
    
    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    let fields: [AboutInfoField] = [
        (name: "Name", keyPath: \AboutInfoData.name),
        (name: "Country", keyPath: \AboutInfoData.country),
        (name: "Latitude", keyPath: \AboutInfoData.latitude),
        (name: "longitude", keyPath: \AboutInfoData.longitude),
        ]
    
    var presenter: AboutPresenter? {
        didSet {
            presenter?.loadAboutInfo()
        }
    }
    var aboutInfo: AboutInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.isAccessibilityElement = true
        self.tableView.accessibilityIdentifier = "automationAboutTableView"
        
        self.navigationItem.titleView = self.activityIndicatorView
        self.activityIndicatorView.hidesWhenStopped = true
        
        if let aboutInfo = presenter?.aboutInfo {
            configure(with: aboutInfo)
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let aboutInfo = self.aboutInfo else { return UITableViewCell() }
        
        let field = self.fields[indexPath.row]
        let cell: UITableViewCell
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: "AboutInfoCell") {
            cell = dequeuedCell
        } else {
            cell = UITableViewCell(style: .value2, reuseIdentifier: "AboutInfoCell")
            cell.selectionStyle = .none
        }
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = "automationAboutCell_\(indexPath.row)"
        cell.textLabel?.isAccessibilityElement = true
        cell.detailTextLabel?.isAccessibilityElement = true
        
        cell.textLabel?.accessibilityIdentifier = "automationAboutCellTextLabel"
        cell.detailTextLabel?.accessibilityIdentifier = "automationAboutCelldetailTextLabel"

        cell.textLabel?.text = field.name
        cell.detailTextLabel?.text = aboutInfo[keyPath: field.keyPath]
        
        return cell
    }
}

// MARK: - AboutView protocol methods

extension AboutViewController: AboutView {
    func configure(with aboutInfo: AboutInfoData) {
        self.aboutInfo = aboutInfo
        self.tableView.reloadData()
    }
    
    func display(error: ModelError) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setActivityIndicator(hidden: Bool) {
        if hidden {
            self.activityIndicatorView.stopAnimating()
        } else {
            self.activityIndicatorView.startAnimating()
        }
    }
}


