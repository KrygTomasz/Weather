//
//  WeatherView.swift
//  Weather
//
//  Created by Kryg Tomasz on 18.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import UIKit

class WeatherView: UIView {

    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.backgroundColor = Colors.MAIN_COLOR
            //topView.frame.size.height = UIScreen.main.bounds.height / 2
            let screenHeight = UIScreen.main.bounds.height
            initialTopViewHeight = screenHeight / 2
            minTopViewHeight = screenHeight / 4
            
        }
    }
    @IBOutlet weak var topViewHeight: NSLayoutConstraint! {
        didSet {
            topViewHeight.constant = UIScreen.main.bounds.height / 2
        }
    }
    @IBOutlet weak var cityLabel: UILabel! {
        didSet {
            cityLabel.text = ""
            cityLabel.textColor = Colors.LABEL_COLOR
            minTemperatureLabelFontSize = cityLabel.font.pointSize
            cityLabelHeight = cityLabel.frame.height
        }
    }
    @IBOutlet weak var cityLabelDistanceToTop: NSLayoutConstraint! {
        didSet {
            cityLabelDistanceToTop.constant = UIScreen.main.bounds.height / 8
            maxCityLabelDistanceToTop = UIScreen.main.bounds.height / 8
        }
    }
    @IBOutlet weak var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.text = ""
            temperatureLabel.textColor = Colors.LABEL_COLOR
            maxTemperatureLabelFontSize = temperatureLabel.font.pointSize
            temperatureLabelHeight = temperatureLabel.frame.height
        }
    }
    @IBOutlet weak var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = Colors.DARK_LABEL_COLOR
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
    
    var initialTopViewHeight: CGFloat = 0
    var mediumTopViewHeight: CGFloat = 0
    var minTopViewHeight: CGFloat = 0
    
    var cityLabelHeight: CGFloat = 0
    var temperatureLabelHeight: CGFloat = 0
    
    var maxCityLabelDistanceToTop: CGFloat = 0
    
    var maxTemperatureLabelFontSize: CGFloat = 0
    var minTemperatureLabelFontSize: CGFloat = 0
    
    var tableYOffsetWhenLabelSizeDecreases: CGFloat = 0
    
    var currentWeather = WSCurrentWeather()
    var dailyForecast = WSDailyForecast()
    
    class func instanceFromNib() -> WeatherView {
        return UINib(nibName: "WeatherView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! WeatherView
    }
    
    func setConstants() {
        mediumTopViewHeight = cityLabelHeight + temperatureLabelHeight
        minTopViewHeight = 2 * cityLabelHeight
        tableYOffsetWhenLabelSizeDecreases = initialTopViewHeight - mediumTopViewHeight
    }
    
    func setData(for city: String = "Katowice") {
        self.refreshBackgroundColor()
        currentWeather.downloadData(for: city, completion:  {
            self.fillCurrentWeather()
        })
        //self.refreshBackgroundColor()
        
        dailyForecast.downloadData(for: city, days: DAYS_NUMBER, completion: {
            self.fillDailyForecast()
            //self.refreshBackgroundColor()
        })
        //self.refreshBackgroundColor()
    }
    
    private func refreshBackgroundColor() {
        //let topColor = UIColor.init(red: 0, green: 0.2, blue: 0.5, alpha: 1)
        //let bottomColor = UIColor.init(red: 0, green: 0, blue: 0.3, alpha: 1)
        self.backgroundColor = Colors.MAIN_COLOR
        //ViewTool.addGradientBackground(to: self, using: [topColor, bottomColor])
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
        return DAYS_NUMBER + 1 // 1 is an empty header on the first place under the topView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let frame = CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height)
            let header = UIView(frame: frame)
            header.backgroundColor = UIColor.red
            return header
        }
        let header = DailyForecastView.instanceFromNib()
        if !dailyForecast.daysOfWeek.isEmpty {
            let index = section - 1
            let day = dailyForecast.daysOfWeek[index]
            let dayTemperature = dailyForecast.dayTemperatures[index]
            let nightTemperature = dailyForecast.nightTemperatures[index]
            header.setView(day: day, dayTemperature: dayTemperature, nightTemperature: nightTemperature)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return topView.frame.height
        }
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
        print(tableView.contentOffset.y)
        topViewHeight.constant = (initialTopViewHeight - (tableView.contentOffset.y))
        cityLabelDistanceToTop.constant = (maxCityLabelDistanceToTop - (tableView.contentOffset.y))
        if cityLabelDistanceToTop.constant <= 0 {
            cityLabelDistanceToTop.constant = 0
        }
        if topViewHeight.constant <= mediumTopViewHeight {
            var tempHeight = maxTemperatureLabelFontSize - (tableView.contentOffset.y - tableYOffsetWhenLabelSizeDecreases)
            if tempHeight < minTemperatureLabelFontSize {
                tempHeight = minTemperatureLabelFontSize
            }
            temperatureLabel.font = UIFont(name: temperatureLabel.font.fontName, size: tempHeight)
            if topViewHeight.constant <= minTopViewHeight {
                topViewHeight.constant = minTopViewHeight
            }
        } else {
            temperatureLabel.font = UIFont(name: temperatureLabel.font.fontName, size: maxTemperatureLabelFontSize)
        }
    }
    
}
