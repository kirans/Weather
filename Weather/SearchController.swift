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
        self.loadRecentItems()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //Performs Search for then entry
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
                if let err = error  as? APIError {
                    self.searchItem?.error = err
                    return
                }

                if let city = searchCity {
                    self.addCity(city: city, update: true)
                }
            })
        } catch {
            //TODO: Handle error
            print("No Data")
            self.searchInProgress = false
        }
    }
    
    
    //Configures the City Cell
    func configure(cell:CityCell, at indexPath:IndexPath) {
        var cityItem:City?
        if let city = searchItem, indexPath.section == 0 {
            cityItem = city
            cell.name?.text = cityItem?.name
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
    
    //Syncs recentsSearchItems to defaults
    func updateRecentItems() {
        var searchItems = [String]()
        for each in self.recentItems {
            searchItems.append(each.name)
        }
        UserDefaults.standard.setValue(searchItems, forKey: "RecentSearchItems")
        UserDefaults.standard.synchronize()
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
                } else if let err = self.searchItem?.error as? APIError {
                    cell.mode = .Error
                    cell.messageLabel?.text = err.value() + " " + city.name
                } else {
                    cell.mode = .Normal
                }
            }
        }
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
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "weatherDetailViewController") as? WeatherDetailViewController{
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        //TODO
    }
}

//MARK:SearchBar Delegate

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

