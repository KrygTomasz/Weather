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
//
//    func setView(for city: String = "Katowice") {
//        let weatherView = WeatherView.instanceFromNib()
//        weatherView.frame = self.bounds
//        weatherView.setConstants()
//        weatherView.setData(for: city)
//        self.addSubview(weatherView)
//    }
//    
//}
    
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.backgroundColor = Colors.MAIN_COLOR
            let screenHeight = UIScreen.main.bounds.height
            initialTopViewHeight = screenHeight / 2
            minTopViewHeight = screenHeight / 4
            HEIGHT_FOR_FIRST_HEADER = initialTopViewHeight
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
    @IBOutlet weak var temperatureLabelTrailing: NSLayoutConstraint! {
        didSet {
            
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
    var HEIGHT_FOR_FIRST_HEADER: CGFloat = 0
    let HEIGHT_FOR_HEADER: CGFloat = 40
    
    var headersExpanded: [Bool] = []
    
    let DAYS_NUMBER = 16
    
    var initialTopViewHeight: CGFloat = 0
    var topViewHeightWhenLabelSizeDecreases: CGFloat = 0
    var minTopViewHeight: CGFloat = 0
    
    var cityLabelHeight: CGFloat = 0
    var temperatureLabelHeight: CGFloat = 0
    
    var maxCityLabelDistanceToTop: CGFloat = 0
    
    var maxTemperatureLabelFontSize: CGFloat = 0
    var minTemperatureLabelFontSize: CGFloat = 0
    
    var tableYOffsetWhenLabelSizeDecreases: CGFloat = 0
    
    var currentWeather = WSCurrentWeather()
    var dailyForecast = WSDailyForecast()
    
    func setConstants() {
        topViewHeightWhenLabelSizeDecreases = cityLabelHeight + temperatureLabelHeight
        minTopViewHeight = 2 * cityLabelHeight
        tableYOffsetWhenLabelSizeDecreases = initialTopViewHeight - topViewHeightWhenLabelSizeDecreases
    }
    
    func setData(for city: String = "Katowice") {
        setConstants()
        headersExpanded = [Bool](repeating: false, count: DAYS_NUMBER + 1)
        
        currentWeather.downloadData(for: city, completion:  {
            self.fillCurrentWeather()
        })
        
        dailyForecast.downloadData(for: city, days: DAYS_NUMBER, completion: {
            self.fillDailyForecast()
        })
    }
    
    private func fillCurrentWeather() {
        cityLabel.text = currentWeather.location
        temperatureLabel.text = currentWeather.temp
    }
    
    private func fillDailyForecast() {
        print(dailyForecast.daysOfWeek)
        tableView.reloadData()
    }
//    
//    override func draw(_ rect: CGRect) {
//        self.backgroundColor = Colors.MAIN_COLOR
//    }
    
}

extension WeatherDataCVCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DAYS_NUMBER + 1 // 1 is an empty header on the first place behind the topView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let index = section - 1
        if section == 0 {
            let frame = CGRect(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height)
            let header = UIView(frame: frame)
            return header
        }
        let header = DailyForecastView.instanceFromNib()
        header.onHeaderClick = {
            self.headersExpanded[section] = !self.headersExpanded[section]
            let indexPath = IndexPath(row: 0, section: section)
            tableView.reloadRows(at: [indexPath], with: .middle)
            print("Header \(section)")
        }
        if !dailyForecast.daysOfWeek.isEmpty {
            let day = dailyForecast.daysOfWeek[section-1]
            let dayTemperature = dailyForecast.dayTemperatures[section-1]
            let nightTemperature = dailyForecast.nightTemperatures[section-1]
            let weatherImage = dailyForecast.weatherImage[section-1]
            header.setView(day: day, dayTemperature: dayTemperature, nightTemperature: nightTemperature, image: weatherImage)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            print(topView.frame.height)
            return HEIGHT_FOR_FIRST_HEADER
        }
        return HEIGHT_FOR_HEADER
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: DAILY_CELL, for: indexPath) as? DailyForecastTVCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = Colors.DARK_LABEL_COLOR
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 0 // section=0 is the (unused) section below the topView
        {
            if headersExpanded[indexPath.section] {
                return 50
            }
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let tableYOffset = tableView.contentOffset.y
        print("Table Y Offset: \(tableYOffset)")
        
        topViewHeight.constant = (initialTopViewHeight - tableYOffset)
        cityLabelDistanceToTop.constant = (maxCityLabelDistanceToTop - tableYOffset)
        
        if cityLabelDistanceToTop.constant <= 0 {
            cityLabelDistanceToTop.constant = 0
        }
        
        if topViewHeight.constant <= topViewHeightWhenLabelSizeDecreases {
            var newTemperatureLabelHeight = maxTemperatureLabelFontSize - (tableYOffset - tableYOffsetWhenLabelSizeDecreases)
            if newTemperatureLabelHeight < minTemperatureLabelFontSize {
                newTemperatureLabelHeight = minTemperatureLabelFontSize
            }
            temperatureLabel.font = UIFont(name: temperatureLabel.font.fontName, size: newTemperatureLabelHeight)
            if topViewHeight.constant <= minTopViewHeight {
                topViewHeight.constant = minTopViewHeight
            }
        } else {
            temperatureLabel.font = UIFont(name: temperatureLabel.font.fontName, size: maxTemperatureLabelFontSize)
        }
    }
    
}
