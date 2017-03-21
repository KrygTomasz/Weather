//
//  DailyForecastView.swift
//  Weather
//
//  Created by Kryg Tomasz on 21.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class DailyForecastView: UIView {

    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    
    @IBOutlet weak var nightTemperatureLabel: UILabel!
    
    class func instanceFromNib() -> DailyForecastView {
        return UINib(nibName: "DailyForecastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DailyForecastView
    }
    
    func setView(day: String, dayTemperature: String, nightTemperature: String) {
        dayLabel.text = day
        dayTemperatureLabel.text = dayTemperature
        nightTemperatureLabel.text = nightTemperature
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
