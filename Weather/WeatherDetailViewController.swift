//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation
import UIKit

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var weatherLabel: UILabel?
    @IBOutlet weak var pressureLabel: UILabel?
    @IBOutlet weak var descriptionsLabel: UILabel?
    
    var city:City?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func updateView() {
        guard  let cityItem = city else {
            return
        }
        nameLabel?.text = cityItem.name
        descriptionLabel?.text = cityItem.weatherDescription
        weatherLabel?.text = cityItem.temperature?.degrees
        pressureLabel?.text = String(cityItem.pressure)
        humidityLabel?.text = String(cityItem.humidity)
    }
    
}
