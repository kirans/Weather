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
    
    var searchInProgress = false {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadSections(IndexSet(integer:0), with: .none)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.tableFooterView = UIView()
        self.loadRecentItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.searchBar?.becomeFirstResponder()
    }
    
    //Adds new city and syncs to defaults
    func addCity(city:City, update:Bool = false) {
        DispatchQueue.main.async { [weak self] in
            if let filterItems = self?.recentItems.filter({$0.name == city.name}), filterItems.count == 0 {
                self?.recentItems.insert(city, at: 0)
            }
            if update == true {
                self?.searchItem = city
                self?.updateRecentItems()
            }
            self?.tableView?.reloadData()
        }
    }

    //Configures the City Cell
    func configure(cell:CityCell, at indexPath:IndexPath) {
        var cityItem:City?
        if let city = searchItem, indexPath.section == 0 {
            cityItem = city
            cell.name?.text = cityItem?.name
            if let country = cityItem?.sys?.country, let name =  cityItem?.name {
                cell.name?.text = name + country
            }
            cell.accessoryType = .none
            cell.backgroundColor = UIColor.blue
            self.updateCurrentSearch(cell: cell)
        } else {
            cityItem = recentItems[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.white
            
        }
        cell.name?.text = cityItem?.name
        cell.weather?.text = cityItem?.temperature?.degrees
        cell.weatherCondition?.text = cityItem?.weatherDescription
        cell.messageIndicator?.hidesWhenStopped = true
        
        if let weather = cityItem?.weathers.first, weather.iconId.characters.count > 0 {
            ServiceController.sharedInstance.downloadWeatherIcon(with: weather.iconId, completion: { (image, error) in
                if error == nil {
                    cell.iconView?.image = image
                }
            })
        }
    }

    //Loads recentsSearchItems from userDefaults
    func loadRecentItems() {
        guard  let recentSearchItems = UserDefaults.standard.array(forKey: "RecentSearchItems") as? [String] else {
            return
        }
        self.recentItems.removeAll()
        for each in recentSearchItems {
            do {
                try ServiceController.sharedInstance.weather(byCity: each, completion: { (searchCity, error) in
                    if let city = searchCity {
                        self.addCity(city: city)
                    }
                })
            } catch {
                print("No Data")
            }
        }
    }

    //Performs Search for the entry
    func performSearch(searchTerm:String) {
        if searchTerm.characters.count == 0 {
            return
        }
        searchInProgress = true
        searchItem = City(with: [:])
        searchItem?.isDummy = true
        searchItem?.name = searchTerm
        self.searchInProgress = true
        do {
            try ServiceController.sharedInstance.weather(byCity: searchTerm, completion: { (searchCity, error) in
                self.searchInProgress = false
                if let err = error  {
                    self.searchItem?.error = err
                    return
                }

                if let city = searchCity {
                    self.addCity(city: city, update: true)
                }
            })
        } catch {
            print("No Data")
            self.searchInProgress = false
        }
    }
    
    //Based on search progress the current cell gets update
    func updateCurrentSearch(cell:CityCell) {
        guard let city = searchItem else {
            return
        }
        
        if city.isDummy == true {
            if let text = searchBar?.text, text.characters.count > 0 {
                if self.searchInProgress == true {
                    cell.mode = .Loading
                    cell.messageLabel?.text = "Searching City \(city.name)"
                    cell.backgroundColor = UIColor.white
                } else if let err = self.searchItem?.error  {
                    cell.mode = .Error
                    if let apiError = err as? APIError {
                        cell.messageLabel?.text = apiError.value() + " " + city.name
                    } else {
                        cell.messageLabel?.text = err.localizedDescription
                    }
                    cell.backgroundColor = UIColor.white
                } else {
                    cell.mode = .Normal
                    cell.backgroundColor = UIColor.blue
                }
            }
        }
    }

    //Syncs recentsSearchItems to defaults
    func updateRecentItems() {
        var searchItems = [String]()
        for each in self.recentItems {
            searchItems.append(each.name)
        }
        UserDefaults.standard.setValue(searchItems, forKey: "RecentSearchItems")
        UserDefaults.standard.synchronize()
    }
}


//MARK: TableView Delegate and Datasoruce

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
            return cell
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
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "weatherDetailViewController") as? WeatherDetailViewController {
            if let city = searchItem, indexPath.section == 0, city.isDummy == false {
                viewController.city = city
            } else if indexPath.section == 1 {
                viewController.city = recentItems[indexPath.row]
            }
            if viewController.city != nil {
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

//MARK:SearchBar Delegate

extension SearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let term = searchBar.text {
            self.performSearch(searchTerm: term)
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchItem = nil
        self.searchInProgress = false
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

