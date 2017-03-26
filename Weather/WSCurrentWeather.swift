//
//  WSCurrentWeather.swift
//  Weather
//
//  Created by Kryg Tomasz on 16.03.2017.
//  Copyright © 2017 Kryg Tomek. All rights reserved.
//

import Alamofire

class WSCurrentWeather {
    
    private var _date: Double?
    private var _temp: Double?
    private var _location: String?
    private var _weather: String?
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    private let urlString = "http://api.openweathermap.org/data/2.5/weather?q="
    private var city: String = "Katowice"
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
        guard let temperature: Double = _temp else { return "Invalid temperature" }
        let formattedTemperature = String(format: "%.0f °C", temperature)
        return formattedTemperature
    }
    
    var location: String {
        return _location ?? "Invalid location"
    }
    
    var weather: String {
        return _weather ?? "Invalid weather"
    }
    
    var url: URL {
        let address: String = urlString+"\(city)"+appID
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
                print("\(response.result.value)")
                print("Sukces?", response.result.isSuccess)
                if let dict = result.value as? JSONStandard,
                    let main = dict["main"] as? JSONStandard,
                    let temp = main["temp"] as? Double,
                    let weatherArray = dict["weather"] as? [JSONStandard],
                    let weather = weatherArray[0]["main"] as? String,
                    let name = dict["name"] as? String,
                    let dt = dict["dt"] as? Double {
                    
                    self._temp = temp - 273.15
                    self._weather = weather
                    self._location = name
                    self._date = dt
                }
                
                completion()
                
            })
    }
    
}

