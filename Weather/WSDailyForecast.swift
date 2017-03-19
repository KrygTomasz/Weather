//
//  WSDailyForecast.swift
//  Weather
//
//  Created by Kryg Tomasz on 18.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Alamofire

class WSDailyForecast {
    
    private var _date: Double?
    private var _temp: String?
    private var _location: String?
    //private var _weather: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    private let urlString = "http://api.openweathermap.org/data/2.5/forecast/daily?q="
    private var city: String = "Katowice"
    private let units: String = "&units=metric"
    private let days: String = "&cnt=3"
    private let appID = GlobalValues.APPID
    
    var date: String {
        guard let dateNumber: Double = _date else { return "Invalid date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: dateNumber)
        return dateFormatter.string(from: date)
    }
    
    var temp: String {
        return _temp ?? "Invalid temperature"
    }
    
    var location: String {
        return _location ?? "Invalid location"
    }
//    
//    var weather: String {
//        return _weather ?? "Invalid weather"
//    }
    
    var url: URL {
        let address: String = urlString+"\(city)"+units+days+appID
        guard let encodedAddress: String = address.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return URL(string: urlString)!
        }
        let urlAdress: URL = URL(string: encodedAddress)!
        return urlAdress
    }
    
    func downloadData(for city: String = "Katowice", completion: @escaping ()->()) {
        
        self.city = city
        
        Alamofire.request(
            url,
            method: .get)
            .validate()
            .responseJSON(completionHandler: {
                response in
                let result = response.result
                print(response.result.value)
                print("Sukces?", response.result.isSuccess)
                if let dict = result.value as? JSONStandard,
                    let city = dict["city"] as? JSONStandard,
                    let name = city["name"] as? String,
                    let list = dict["list"] as? [JSONStandard]
                {
                    for dayData in list {
                        if let dt = dayData["dt"] as? Double,
                            let temp = dayData["temp"] as? JSONStandard,
                            let day = temp["day"] as? Double,
                            let min = temp["min"] as? Double,
                            let max = temp["max"] as? Double,
                            let night = temp["night"] as? Double,
                            let pressure = dayData["pressure"] as? Double,
                            let humidity = dayData["humidity"] as? Int,
                            let weatherArray = dayData["weather"] as? [JSONStandard],
                            let weather = weatherArray[0] as? JSONStandard,
                            let id = weather["id"] as? Int
                        {
                            //self._temp = String(format: "%.0f °C", temp - 273.15)
                            //self._weather = weather
                            //self._location = name
                            //self._date = dt
                        }
                        
                    }
                    //                    let temp = main["temp"] as? Double,
                    //                    let weatherArray = dict["weather"] as? [JSONStandard],
                    //                    let weather = weatherArray[0]["main"] as? String,
                    //                    let name = dict["name"] as? String,
                    //                    let dt = dict["dt"] as? Double {
                    
                    
                }
                
                completion()
                
            })
    }
    
}
