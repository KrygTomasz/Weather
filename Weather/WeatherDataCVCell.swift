//
//  WeatherDataCVCell.swift
//  Weather
//
//  Created by Kryg Tomasz on 18.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class WeatherDataCVCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setView(for city: String = "Katowice") {
        let weatherView = WeatherView.instanceFromNib()
        weatherView.setData(for: city)
        weatherView.frame = self.bounds
        self.addSubview(weatherView)
    }
    
}
