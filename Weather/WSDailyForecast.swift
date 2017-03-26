//
//  WSDailyForecast.swift
//  Weather
//
//  Created by Kryg Tomasz on 18.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Alamofire

class WSDailyForecast {
    
    private var _location: String?
    private var _dates: [Double?] = []
    private var _days: [Double?] = []
    private var _mins: [Double?] = []
    private var _maxs: [Double?] = []
    private var _nights: [Double?] = []
    private var _pressures: [Double?] = []
    private var _humidities: [Double?] = []
    private var _ids: [Int?] = []
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    private let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    private var city: String = "Katowice"
    private let units: String = "&units=metric&cnt="
    private var days: Int = 1
    private let appID = GlobalValues.APPID
    
    var location: String {
        return _location ?? "Invalid location"
    }
    
    var daysOfWeek: [String] {
        var weekDays: [String] = []
        for date in _dates {
            if let dateNumber: Double = date {
                let date = Date(timeIntervalSince1970: dateNumber)
//                let calendar = Calendar(identifier: .gregorian)
//                let weekDay = calendar.component(.weekday, from: date)
//                weekDays.append(weekDay)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
                let weekDay = dateFormatter.string(from: date)//"Sunday"
                weekDays.append(weekDay)
            } else {
                weekDays.append("Undefined")
            }
        }
        return weekDays
    }
    
    var dayTemperatures: [String] {
        let dayTemps = formatTemperatures(temperatures: _days)
        return dayTemps
    }
    
    var minTemperatures: [String] {
        let minTemps = formatTemperatures(temperatures: _mins)
        return minTemps
    }
    
    var maxTemperatures: [String] {
        let maxTemps = formatTemperatures(temperatures: _maxs)
        return maxTemps
    }
    
    var nightTemperatures: [String] {
        let nightTemps = formatTemperatures(temperatures: _nights)
        return nightTemps
    }
    
    private func formatTemperatures(temperatures: [Double?]) -> [String] {
        var temps: [String] = []
        for temp in temperatures {
            if let temperature: Double = temp {
                let formattedTemperature = String(format: "%.0f", temperature)
                temps.append(formattedTemperature)
            } else {
                temps.append("Null °C")
            }
        }
        return temps
    }
    
    var weatherImage: [UIImage] {
        
        var images: [UIImage] = []
        for id in _ids {
            let image = getImageFor(id: id)
            images.append(image)
        }
        return images

    }
    
    private func getImageFor(id: Int?) -> UIImage {
        
        guard let weatherId = id else {
            return UIImage()
        }
        
        switch weatherId {
        case 200...299:
            return #imageLiteral(resourceName: "thunder")
        case 300...399:
            return #imageLiteral(resourceName: "rain")
        case 500...599:
            return #imageLiteral(resourceName: "rain")
        case 600...699:
            return #imageLiteral(resourceName: "snow")
        case 700...799:
            return #imageLiteral(resourceName: "mist")
        case 800:
            return #imageLiteral(resourceName: "clear")
        case 801:
            return #imageLiteral(resourceName: "clouds")
        case 802...899:
            return #imageLiteral(resourceName: "bigClouds")
        default:
            return #imageLiteral(resourceName: "clouds")
        }
        
    }

    var url: URL {
        let address: String = urlString+"\(city)"+units+"\(days)"+appID
        guard let encodedAddress: String = address.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return URL(string: urlString)!
        }
        let urlAdress: URL = URL(string: encodedAddress)!
        return urlAdress
    }
    
    func downloadData(for city: String = "Katowice", days: Int = 1, completion: @escaping ()->()) {
        
        self.city = city
        self.days = days
        
        Alamofire.request(
            url,
            method: .get)
            .validate()
            .responseJSON(completionHandler: {
                response in
                let result = response.result
                print("\(response.result.value)")
                print("Sukces?", response.result.isSuccess)
                if let dict = result.value as? JSONStandard,
                    let city = dict["city"] as? JSONStandard,
                    let name = city["name"] as? String,
                    let list = dict["list"] as? [JSONStandard]
                {
                    self._location = name
                    
                    for dayData in list {
                        if let dt = dayData["dt"] as? Double,
                            let temp = dayData["temp"] as? JSONStandard,
                            let day = temp["day"] as? Double,
                            let min = temp["min"] as? Double,
                            let max = temp["max"] as? Double,
                            let night = temp["night"] as? Double,
                            let pressure = dayData["pressure"] as? Double,
                            let humidity = dayData["humidity"] as? Double,
                            let weatherArray = dayData["weather"] as? [JSONStandard],
                            let weather = weatherArray[0] as? JSONStandard,
                            let id = weather["id"] as? Int
                        {
                            self._dates.append(dt)
                            self._days.append(day)
                            self._mins.append(min)
                            self._maxs.append(max)
                            self._nights.append(night)
                            self._pressures.append(pressure)
                            self._humidities.append(humidity)
                            self._ids.append(id)
                        }
                    }
                }
                
                completion()
                
            })
    }
    
}
