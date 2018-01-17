//
//  SearchResultController.swift
//  RJT_20_WeatherAPI2
//
//  Created by Mark on 12/31/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import CoreLocation

protocol SearchResultControllerDelegate {
    func didSelectZipCodeWith(_ coordinate: CLLocationCoordinate2D)
}

class SearchResultController: UIViewController {
    @IBOutlet weak var tableview: UITableView!
    
    lazy var zipToCoordinateMap: [String: CLLocationCoordinate2D] = LocationDataManager.shareInstance.locationData
    
    var delegate: SearchResultControllerDelegate?
    
    var matchingZip = [String]() {
        didSet {
            tableview.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func filteringZipWith(_ searchText: String?) {
        guard let searchZip = searchText else { return }
        let filteredZipToAddressMap = zipToCoordinateMap.filter {
           return $0.0.contains(searchZip)
        }
        matchingZip = Array(filteredZipToAddressMap.keys)
    }
}

extension SearchResultController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingZip.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        // configure cell here
        let currentZip = matchingZip[indexPath.row]
        
        cell.textLabel?.text = currentZip
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoordinate = zipToCoordinateMap[matchingZip[indexPath.row]]!
        delegate?.didSelectZipCodeWith(selectedCoordinate)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchResultController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteringZipWith(searchController.searchBar.text)
    }
}

