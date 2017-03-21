//
//  WeatherView.swift
//  Weather
//
//  Created by Kryg Tomasz on 18.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    @IBOutlet weak var cityLabel: UILabel! {
        didSet {
            cityLabel.textColor = Colors.LABEL_COLOR
        }
    }
    
    @IBOutlet weak var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.textColor = Colors.LABEL_COLOR
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let dailyForecastNib = UINib(nibName: DAILY_CELL, bundle: nil)
            tableView.register(dailyForecastNib, forCellReuseIdentifier: DAILY_CELL)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let DAILY_CELL = "DailyForecastTVCell"
    let HEIGHT_FOR_HEADER: CGFloat = 32
    
    let DAYS_NUMBER = 16
    
    var currentWeather = WSCurrentWeather()
    var dailyForecast = WSDailyForecast()
    
    class func instanceFromNib() -> WeatherView {
        return UINib(nibName: "WeatherView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WeatherView
    }
    
    func setData(for city: String = "Katowice") {
        currentWeather.downloadData(for: city, completion:  {
            self.fillCurrentWeather()
        })
        
        dailyForecast.downloadData(for: city, days: DAYS_NUMBER, completion: {
            self.fillDailyForecast()
            self.refreshBackgroundColor()
        })
        
    }
    
    private func refreshBackgroundColor() {
        let topColor = UIColor.init(red: 0, green: 0.2, blue: 0.5, alpha: 1).cgColor
        let bottomColor = UIColor.init(red: 0, green: 0, blue: 0.3, alpha: 1).cgColor
        ViewTool.addGradientBackground(to: self, using: [topColor, bottomColor])
    }
    
    private func fillCurrentWeather() {
        cityLabel.text = currentWeather.location
        temperatureLabel.text = currentWeather.temp
    }
    
    private func fillDailyForecast() {
        print(dailyForecast.daysOfWeek)
        tableView.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DAYS_NUMBER
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = DailyForecastView.instanceFromNib()
        if !dailyForecast.daysOfWeek.isEmpty {
            let day = dailyForecast.daysOfWeek[section]
            let dayTemperature = dailyForecast.dayTemperatures[section]
            let nightTemperature = dailyForecast.nightTemperatures[section]
            header.setView(day: day, dayTemperature: dayTemperature, nightTemperature: nightTemperature)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: DAILY_CELL, for: indexPath) as? DailyForecastTVCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(tableView.contentOffset.y)
//        tableViewHeight.constant = (tableViewHeight.constant + (tableView.contentOffset.y/8) / 2)
    }
    
}
