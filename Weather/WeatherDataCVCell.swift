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
    
    @IBOutlet weak var weatherView: UIView! {
        didSet {
            weatherView.backgroundColor = Colors.MAIN_COLOR
        }
    }
    
    @IBOutlet weak var topView: UIView! {
        didSet {
            topView.backgroundColor = Colors.MAIN_COLOR
            //topView.backgroundColor = topView.backgroundColor?.withAlphaComponent(0.8)
            let screenHeight = UIScreen.main.bounds.height
            initialTopViewHeight = screenHeight / 2
            minTopViewHeight = screenHeight / 4
            HEIGHT_FOR_FIRST_HEADER = initialTopViewHeight
            
            ViewTool.addShadow(to: topView)
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
            temperatureLabelTrailing.constant = 1
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
    var HEIGHT_FOR_LAST_HEADER: CGFloat = 44
    let HEIGHT_FOR_HEADER: CGFloat = 40
    
    var headersExpanded: [Bool] = []
    let NUMBER_OF_HEADERS = GlobalValues.NUMBER_OF_DAYS + 2 // 2 - number of unused headers to fit tableView between top and bottom views
    
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
    
    private func setConstants() {
        topViewHeightWhenLabelSizeDecreases = cityLabelHeight + temperatureLabelHeight
        minTopViewHeight = 2 * cityLabelHeight
        tableYOffsetWhenLabelSizeDecreases = initialTopViewHeight - topViewHeightWhenLabelSizeDecreases
    }
    
    func setData(for location: Location) {
        setConstants()
        headersExpanded = [Bool](repeating: false, count: NUMBER_OF_HEADERS)
        dailyForecast.clean()
        
        currentWeather.downloadData(for: location, completion:  {
            self.fillCurrentWeather()
        })
        
        dailyForecast.downloadData(for: location, days: GlobalValues.NUMBER_OF_DAYS, completion: {
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

// MARK: - Table Delegate and DataSource

extension WeatherDataCVCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUMBER_OF_HEADERS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 0 && section < NUMBER_OF_HEADERS - 1 {
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
        } else if section == NUMBER_OF_HEADERS - 1 {
            let frame = CGRect(x: 0, y: 0, width: weatherView.frame.width, height: HEIGHT_FOR_LAST_HEADER)
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
            return HEIGHT_FOR_FIRST_HEADER
        } else if section == NUMBER_OF_HEADERS - 1 {
            return HEIGHT_FOR_LAST_HEADER
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

        if headersExpanded[indexPath.section] {
            return 50
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        temperatureLabelTrailing.constant = 1
        let tableYOffset = tableView.contentOffset.y
        print("Table Y Offset: \(tableYOffset)")
        
        topViewHeight.constant = (initialTopViewHeight - tableYOffset)
        cityLabelDistanceToTop.constant = (maxCityLabelDistanceToTop - tableYOffset/2)
        
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
