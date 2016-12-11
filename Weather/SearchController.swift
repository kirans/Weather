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
    
    var city:City?
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
                if let _ = searchCity {
                    self.city = searchCity
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
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
        guard  let weatherCity =  city else {
            return
        }
        cell.name?.text = weatherCity.name
        cell.weather?.text = "22"
    }
    
    
    func updateRecentSearchItems() {
        
    }
    
    
    func loadRecentSearchItems() {
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = city {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cityCellReuseIdentifier, for: indexPath) as? CityCell {
            self.configure(cell: cell, at:indexPath)
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

