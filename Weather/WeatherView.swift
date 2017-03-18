//
//  WeatherView.swift
//  Weather
//
//  Created by Kryg Tomasz on 18.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var weather = WSCurrentWeather()
    
    class func instanceFromNib() -> WeatherView {
        return UINib(nibName: "WeatherView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WeatherView
    }
    
    func setData(for city: String = "Katowice") {
//        self.setView()
        weather.downloadData(for: city, completion:  {
            self.setView()
        })
        
    }
    
    func setView() {
        self.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 1, alpha: 1)
        cityLabel.text = weather.location
        temperatureLabel.text = weather.temp
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
}
