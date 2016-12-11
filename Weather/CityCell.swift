//
//  CityCell.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation
import UIKit

let cityCellReuseIdentifier = "cityCell"

class CityCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView?
    @IBOutlet weak var weather: UILabel?
    @IBOutlet weak var name: UILabel?
}
