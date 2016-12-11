//
//  SearchController.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import UIKit
import Foundation

class SearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var tableView: UITableView?
    
    var recentItems = [City]()
    var searchItem:City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performSearch(searchTerm:String) {
        if searchTerm.characters.count == 0 {
            return
        }
        do {
            try ServiceController.sharedInstance.weather(byCity: searchTerm, completion: { (searchCity, error) in
                if let err = error {
                    //TODO
                }
                DispatchQueue.main.async { [weak self] in
                    if let city = searchCity {
                        self?.searchItem = city
                        self?.recentItems.append(city)
                    }
                    self?.tableView?.reloadData()
                }
            })
        } catch {
            //TODO: Handle error
            print("No Data")
        }
    }
    
    func updateTableView() {
        
    }
    
    func configure(cell:CityCell, at indexPath:IndexPath) {
        var cityItem:City?
        if let city = searchItem, indexPath.section == 0 {
            cityItem = city
            cell.name?.text = cityItem?.name
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.blue
        } else {
            cityItem = recentItems[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.name?.text = cityItem?.name
            cell.backgroundColor = UIColor.white

        }
        cell.weather?.text = cityItem?.temperature?.degrees
        cell.weatherCondition?.text = cityItem?.weatherDescription
        if let weather = cityItem?.weathers.first {
            ServiceController.sharedInstance.downloadWeatherIcon(with: weather.iconId, completion: { (image, error) in
                if error == nil {
                    cell.iconView?.image = image
                }
            })
        }
        cell.layoutIfNeeded()
    }
    
    
    func updateRecentItems() {
        
    }
    
    
    func loadRecentItems() {
        
    }
    
    func recentSearchItems() -> [String] {
        let userDefaults = UserDefaults.standard
        userDefaults.array(forKey: "RecentSearchItems")
        return []
    }
    
}


//TableView

extension SearchController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0  {
            if let _ = searchItem {
                return 1
            }
            return 0
        }
        return recentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cityCellReuseIdentifier, for: indexPath) as? CityCell {
            self.configure(cell: cell, at:indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if let _ = searchItem {
                return "Current Search"
            }
            return ""
        }
        return "Recent Search"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "weatherDetailViewController") as? WeatherDetailViewController{
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        //TODO
    }
}

//SearchBar Delegate

extension SearchController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            self.performSearch(searchTerm: term)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        if let term = searchBar.text {
            self.performSearch(searchTerm: term)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
}

