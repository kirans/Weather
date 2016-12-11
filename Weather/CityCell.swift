//
//  CityCell.swift
//  Weather
//
//  Created by Kiran Kumar Sanka on 12/10/16.
//  Copyright © 2016 Kiran Kumar Sanka. All rights reserved.
//

import Foundation
import UIKit


enum Mode:Int {
    case Normal = 1
    case Loading = 2
    case Error = 3
}

let cityCellReuseIdentifier = "cityCell"

class CityCell: UITableViewCell {
    
    @IBOutlet weak var iconView: UIImageView?
    @IBOutlet weak var weather: UILabel?
    @IBOutlet weak var name: UILabel?
    @IBOutlet weak var weatherCondition: UILabel?
    @IBOutlet weak var messageView: UIView?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var messageIndicator: UIActivityIndicatorView?

    var mode = Mode.Normal {
        didSet{
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }

    //Updates the view based on mode
    func updateView() {
        UIView.animate(withDuration: 0.2) {
            switch self.mode {
            case .Normal:
                self.messageView?.isHidden = true
                self.messageIndicator?.stopAnimating()
            case .Loading:
                self.messageView?.isHidden = false
                self.messageIndicator?.startAnimating()
                self.messageLabel?.textAlignment = .left

            case .Error:
                self.messageView?.isHidden = false
                self.messageIndicator?.stopAnimating()
                self.messageLabel?.textAlignment = .center
            }
        }
    }
    
    override func prepareForReuse() {
        self.name?.text = ""
        self.messageView?.isHidden = true
        self.mode = .Normal
    }
}
